import 'package:flutter/widgets.dart';

import '../validation/field_issue.dart';
import 'l10n.dart';

/// Renders a [FieldIssue] from the domain rules in the app's language.
///
/// Form fields call it directly: `validator: (v) => context.messageFor(
/// ProductRules.validateSku(v ?? ''))` — null issue means the field is fine,
/// so the validator's null-means-valid contract survives.
extension FieldIssueText on BuildContext {
  String? messageFor(FieldIssue? issue) {
    if (issue == null) return null;
    final l10n = this.l10n;
    final max = issue.max ?? 0;
    return switch (issue.kind) {
      FieldIssueKind.skuRequired => l10n.validationSkuRequired,
      FieldIssueKind.skuTooLong => l10n.validationSkuTooLong(max),
      FieldIssueKind.nameRequired => l10n.validationNameRequired,
      FieldIssueKind.nameTooLong => l10n.validationNameTooLong(max),
      FieldIssueKind.descriptionTooLong => l10n.validationDescriptionTooLong(max),
      FieldIssueKind.priceRequired => l10n.validationPriceRequired,
      FieldIssueKind.priceInvalid => l10n.validationPriceInvalid,
      FieldIssueKind.priceNegative => l10n.validationPriceNegative,
      FieldIssueKind.priceTooLarge => l10n.validationPriceTooLarge,
      FieldIssueKind.categoryInvalid => l10n.validationCategoryInvalid,
      FieldIssueKind.orderTransitionInvalid => l10n.validationOrderTransition,
      FieldIssueKind.emailInvalid => l10n.validationEmailInvalid,
      FieldIssueKind.emailTooLong => l10n.validationEmailTooLong(max),
      FieldIssueKind.phoneInvalid => l10n.validationPhoneInvalid(max),
      FieldIssueKind.addressTooLong => l10n.validationAddressTooLong(max),
      FieldIssueKind.quantityRequired => l10n.validationQuantityRequired,
      FieldIssueKind.quantityInvalid => l10n.validationQuantityInvalid,
      FieldIssueKind.quantityPositive => l10n.validationQuantityPositive,
      FieldIssueKind.quantityNegative => l10n.validationQuantityNegative,
      FieldIssueKind.quantityTooLarge => l10n.validationQuantityTooLarge(max),
      FieldIssueKind.reasonTooLong => l10n.validationReasonTooLong(max),
      FieldIssueKind.thresholdRequired => l10n.validationThresholdRequired,
      FieldIssueKind.thresholdInvalid => l10n.validationThresholdInvalid,
      FieldIssueKind.thresholdNegative => l10n.validationThresholdNegative,
      FieldIssueKind.customerRequired => l10n.validationCustomerRequired,
      FieldIssueKind.itemsRequired => l10n.validationItemsRequired,
      FieldIssueKind.itemsTooMany => l10n.validationItemsTooMany(max),
      FieldIssueKind.itemsDuplicateProduct => l10n.validationItemsDuplicate(issue.line ?? 0),
    };
  }
}
