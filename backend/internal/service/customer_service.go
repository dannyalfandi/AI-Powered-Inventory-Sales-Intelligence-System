package service

import (
	"context"
	"errors"
	"fmt"
	"net/mail"
	"regexp"
	"strings"

	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/model"
	"github.com/dannyalfandi/AI-Powered-Inventory-Sales-Intelligence-System/backend/internal/repository"
)

const (
	maxCustomerNameLength  = 255
	maxEmailLength         = 255
	maxAddressLength       = 1000
	customerPhoneMaxLength = 32
)

// phonePattern accepts digits with an optional leading +, spaces, dashes and
// parentheses, e.g. "+62 812-3456-7890" or "(021) 555 1234".
var phonePattern = regexp.MustCompile(`^\+?[0-9 ()\-]{6,32}$`)

type CustomerService interface {
	Create(ctx context.Context, in model.CreateCustomerInput) (*model.Customer, error)
	GetByID(ctx context.Context, id uint) (*model.Customer, error)
	List(ctx context.Context, params model.ListCustomersParams) ([]model.Customer, int64, model.ListCustomersParams, error)
	Update(ctx context.Context, id uint, in model.UpdateCustomerInput) (*model.Customer, error)
	Delete(ctx context.Context, id uint) error
}

type customerService struct {
	repo repository.CustomerRepository
}

func NewCustomerService(repo repository.CustomerRepository) CustomerService {
	return &customerService{repo: repo}
}

func (s *customerService) Create(ctx context.Context, in model.CreateCustomerInput) (*model.Customer, error) {
	c := &model.Customer{
		Name:    strings.TrimSpace(in.Name),
		Email:   normalizeEmail(in.Email),
		Phone:   strings.TrimSpace(in.Phone),
		Address: strings.TrimSpace(in.Address),
	}
	if err := validateCustomer(c); err != nil {
		return nil, err
	}

	if err := s.repo.Create(ctx, c); err != nil {
		return nil, mapCustomerRepoError(err, "customer "+c.Name)
	}
	return c, nil
}

func (s *customerService) GetByID(ctx context.Context, id uint) (*model.Customer, error) {
	c, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return nil, mapRepoError(err, fmt.Sprintf("customer %d", id))
	}
	return c, nil
}

func (s *customerService) List(ctx context.Context, params model.ListCustomersParams) ([]model.Customer, int64, model.ListCustomersParams, error) {
	params.Page, params.PageSize = normalizePage(params.Page, params.PageSize)
	params.Search = strings.TrimSpace(params.Search)
	customers, total, err := s.repo.List(ctx, params)
	if err != nil {
		return nil, 0, params, fmt.Errorf("list customers: %w", err)
	}
	return customers, total, params, nil
}

func (s *customerService) Update(ctx context.Context, id uint, in model.UpdateCustomerInput) (*model.Customer, error) {
	c, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return nil, mapRepoError(err, fmt.Sprintf("customer %d", id))
	}

	if in.Name != nil {
		c.Name = strings.TrimSpace(*in.Name)
	}
	if in.Email != nil {
		c.Email = normalizeEmail(*in.Email)
	}
	if in.Phone != nil {
		c.Phone = strings.TrimSpace(*in.Phone)
	}
	if in.Address != nil {
		c.Address = strings.TrimSpace(*in.Address)
	}
	if err := validateCustomer(c); err != nil {
		return nil, err
	}

	if err := s.repo.Update(ctx, c); err != nil {
		return nil, mapCustomerRepoError(err, fmt.Sprintf("customer %d", id))
	}
	return c, nil
}

// Delete soft-deletes a customer. It refuses (ErrConflict) while the customer
// has orders that are not CANCELLED (PENDING, CONFIRMED or SHIPPED).
func (s *customerService) Delete(ctx context.Context, id uint) error {
	if _, err := s.repo.FindByID(ctx, id); err != nil {
		return mapRepoError(err, fmt.Sprintf("customer %d", id))
	}

	n, err := s.repo.CountActiveOrders(ctx, id)
	if err != nil {
		return fmt.Errorf("customer %d: %w", id, err)
	}
	if n > 0 {
		return fmt.Errorf("%w: customer %d still has %d sales order(s) that are not cancelled", ErrConflict, id, n)
	}

	if err := s.repo.Delete(ctx, id); err != nil {
		return mapRepoError(err, fmt.Sprintf("customer %d", id))
	}
	return nil
}

// normalizeEmail trims and lowercases; an empty email is stored as NULL so
// the unique index ignores it.
func normalizeEmail(email string) *string {
	e := strings.ToLower(strings.TrimSpace(email))
	if e == "" {
		return nil
	}
	return &e
}

func validateCustomer(c *model.Customer) error {
	v := &ValidationError{}
	switch {
	case c.Name == "":
		v.add("name", "is required")
	case len(c.Name) > maxCustomerNameLength:
		v.add("name", fmt.Sprintf("must be at most %d characters", maxCustomerNameLength))
	}
	if c.Email != nil {
		switch addr, err := mail.ParseAddress(*c.Email); {
		case len(*c.Email) > maxEmailLength:
			v.add("email", fmt.Sprintf("must be at most %d characters", maxEmailLength))
		case err != nil || addr.Address != *c.Email:
			// addr.Address differs for inputs like "Budi <budi@x.id>".
			v.add("email", "must be a valid email address")
		}
	}
	if c.Phone != "" && !phonePattern.MatchString(c.Phone) {
		v.add("phone", fmt.Sprintf("must be 6-%d digits, optionally with +, spaces, dashes or parentheses", customerPhoneMaxLength))
	}
	if len(c.Address) > maxAddressLength {
		v.add("address", fmt.Sprintf("must be at most %d characters", maxAddressLength))
	}
	return v.errOrNil()
}

// mapCustomerRepoError reports a duplicate key as a conflict on the email,
// the only unique field besides the id.
func mapCustomerRepoError(err error, subject string) error {
	if errors.Is(err, repository.ErrDuplicateKey) {
		return fmt.Errorf("%w: email is already used by another customer", ErrConflict)
	}
	return mapRepoError(err, subject)
}
