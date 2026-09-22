/// What is wrong with a field, without saying it in any language.
///
/// The rules live in `domain/` and must stay free of Flutter, so they return
/// one of these instead of a sentence; the UI turns it into text from the ARB
/// files (see `core/l10n/field_issue_text.dart`). That is also why the
/// backend's own validation messages are shown as they arrive: those are
/// already localized by `Accept-Language`.
enum FieldIssueKind {
  skuRequired,
  skuTooLong,
  nameRequired,
  nameTooLong,
  descriptionTooLong,
  priceRequired,
  priceInvalid,
  priceNegative,
  priceTooLarge,
  categoryInvalid,
  orderTransitionInvalid,
  emailInvalid,
  emailTooLong,
  phoneInvalid,
  addressTooLong,
  quantityRequired,
  quantityInvalid,
  quantityPositive,
  quantityNegative,
  quantityTooLarge,
  reasonTooLong,
  thresholdRequired,
  thresholdInvalid,
  thresholdNegative,
  customerRequired,
  itemsRequired,
  itemsTooMany,
  itemsDuplicateProduct,
}

/// One rejected field. [max] fills the number in messages that mention a
/// limit ("at most 64 characters"); [line] fills the one-based order line a
/// message points back to ("already on line 1").
class FieldIssue {
  const FieldIssue(this.kind, {this.max, this.line});

  final FieldIssueKind kind;
  final int? max;
  final int? line;

  @override
  String toString() {
    final arg = max ?? line;
    return arg == null ? kind.name : '${kind.name}($arg)';
  }

  @override
  bool operator ==(Object other) =>
      other is FieldIssue && other.kind == kind && other.max == max && other.line == line;

  @override
  int get hashCode => Object.hash(kind, max, line);
}
