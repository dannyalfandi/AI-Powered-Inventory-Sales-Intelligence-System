// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Inventory Intelligence';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonBack => 'Back';

  @override
  String get commonUnderstood => 'Got it';

  @override
  String get commonLoadMore => 'Load more';

  @override
  String get commonNoResults => 'No results.';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonUnexpectedError => 'Something went wrong.';

  @override
  String commonLoadFailed(String message) {
    return 'Could not load: $message';
  }

  @override
  String get commonSaveChanges => 'Save changes';

  @override
  String get commonClearSearch => 'Clear search';

  @override
  String get commonValidationFailed => 'Please fix the highlighted fields.';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navProducts => 'Products';

  @override
  String get navCategories => 'Categories';

  @override
  String get navCustomers => 'Customers';

  @override
  String get navOrders => 'Orders';

  @override
  String get networkTimeout => 'The server did not respond. Try again.';

  @override
  String get networkCancelled => 'Request cancelled.';

  @override
  String get networkUnreachable =>
      'Cannot reach the server. Check your connection or API_BASE_URL.';

  @override
  String networkServerError(String status) {
    return 'Server error (HTTP $status)';
  }

  @override
  String get networkServerErrorUnknown => 'Server error';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageSubtitle =>
      'Applies to the app and to the messages the server sends.';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageIndonesian => 'Bahasa Indonesia';

  @override
  String get settingsAppearanceSection => 'Appearance';

  @override
  String get settingsThemeMode => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSubtitle =>
      'System follows your phone\'s light and dark setting.';

  @override
  String get settingsAccent => 'Accent colour';

  @override
  String get settingsAccentSubtitle =>
      'Colours the buttons, charts and highlights. Status colours stay the same so a falling trend always reads as falling.';

  @override
  String settingsAccentSelected(String name) {
    return '$name selected';
  }

  @override
  String get settingsAccentTeal => 'Teal';

  @override
  String get settingsAccentIndigo => 'Indigo';

  @override
  String get settingsAccentViolet => 'Violet';

  @override
  String get settingsAccentMagenta => 'Magenta';

  @override
  String get settingsAccentAmber => 'Amber';

  @override
  String get settingsAccentSlate => 'Slate';

  @override
  String get settingsPreviewTitle => 'Preview';

  @override
  String get settingsPreviewMetric => 'Revenue';

  @override
  String get settingsPreviewAction => 'Primary action';

  @override
  String get settingsPreviewPositive => 'Up 12%';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsCurrencyNote =>
      'Amounts stay in Rupiah (Rp) in both languages.';

  @override
  String get productsTitle => 'Products';

  @override
  String get productsSearchHint => 'Search by name or SKU';

  @override
  String get productsEmpty => 'No products yet.';

  @override
  String productsEmptyForSearch(String query) {
    return 'No products match \"$query\".';
  }

  @override
  String get productsAdd => 'Add product';

  @override
  String productsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
    );
    return '$_temp0';
  }

  @override
  String get productsEmptyHint => 'No products yet.\nAdd your first product.';

  @override
  String get productSkuHint => 'e.g. KOPI-001';

  @override
  String get productFieldDescriptionOptional => 'Description (optional)';

  @override
  String get productCreated => 'Product added';

  @override
  String get productUpdated => 'Product updated';

  @override
  String productDeleted(String name) {
    return '$name deleted';
  }

  @override
  String get productCategoryLoadFailed => 'Could not load the category list';

  @override
  String get productCategoryReload => 'Reload categories';

  @override
  String productCategoryFallback(String id) {
    return 'Category #$id';
  }

  @override
  String get productNew => 'New product';

  @override
  String get productEdit => 'Edit product';

  @override
  String get productFieldSku => 'SKU';

  @override
  String get productFieldName => 'Name';

  @override
  String get productFieldPrice => 'Price (Rp)';

  @override
  String get productFieldCategory => 'Category';

  @override
  String get productNoCategory => 'No category';

  @override
  String get productDeleteConfirmTitle => 'Delete product?';

  @override
  String productDeleteConfirmBody(String name, String sku) {
    return '\"$name\" ($sku) will be removed from the list.';
  }

  @override
  String productDeleteFailed(String message) {
    return 'Could not delete the product: $message';
  }

  @override
  String productSaveFailed(String message) {
    return 'Could not save the product: $message';
  }

  @override
  String get productSkuTaken => 'This SKU is already used by another product';

  @override
  String get productStockTitle => 'Product detail';

  @override
  String get productStockLow => 'Low stock';

  @override
  String get productStockRecordMovement => 'Record movement';

  @override
  String get productStockHistory => 'Movement history';

  @override
  String get validationSkuRequired => 'SKU is required';

  @override
  String validationSkuTooLong(int max) {
    return 'SKU must be at most $max characters';
  }

  @override
  String get validationNameRequired => 'Name is required';

  @override
  String validationNameTooLong(int max) {
    return 'Name must be at most $max characters';
  }

  @override
  String validationDescriptionTooLong(int max) {
    return 'Description must be at most $max characters';
  }

  @override
  String get validationPriceRequired => 'Price is required';

  @override
  String get validationPriceInvalid => 'Price must be a whole number';

  @override
  String get validationPriceNegative => 'Price cannot be negative';

  @override
  String get validationPriceTooLarge => 'Price is too large';

  @override
  String get validationEmailInvalid => 'That email address is not valid';

  @override
  String validationEmailTooLong(int max) {
    return 'Email must be at most $max characters';
  }

  @override
  String validationPhoneInvalid(int max) {
    return 'Phone must be 6–$max digits (+, spaces, dashes and brackets allowed)';
  }

  @override
  String validationAddressTooLong(int max) {
    return 'Address must be at most $max characters';
  }

  @override
  String get validationQuantityRequired => 'Quantity is required';

  @override
  String get validationQuantityInvalid => 'Quantity must be a whole number';

  @override
  String get validationQuantityPositive => 'Quantity must be greater than 0';

  @override
  String get validationQuantityNegative => 'Quantity cannot be negative';

  @override
  String validationQuantityTooLarge(int max) {
    return 'Quantity must be at most $max';
  }

  @override
  String validationReasonTooLong(int max) {
    return 'Reason must be at most $max characters';
  }

  @override
  String get validationThresholdRequired => 'Threshold is required';

  @override
  String get validationThresholdInvalid => 'Threshold must be a whole number';

  @override
  String get validationThresholdNegative => 'Threshold cannot be negative';

  @override
  String get validationCustomerRequired => 'Pick a customer first';

  @override
  String get validationItemsRequired => 'Add at least one product';

  @override
  String get validationOrderTransition =>
      'This order cannot move to that status.';

  @override
  String get validationCategoryInvalid => 'Select a valid category';

  @override
  String validationItemsTooMany(int max) {
    return 'At most $max products per order';
  }

  @override
  String validationItemsDuplicate(int line) {
    return 'This product is already on line $line; merge the quantities';
  }

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get categoriesSearchHint => 'Search categories';

  @override
  String categoriesEmptyForSearch(String query) {
    return 'No categories match \"$query\".';
  }

  @override
  String get categoriesAdd => 'Add category';

  @override
  String categoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count categories',
      one: '1 category',
    );
    return '$_temp0';
  }

  @override
  String get categoriesEmptyHint =>
      'No categories yet.\nAdd your first category.';

  @override
  String get categoryNameHint => 'e.g. Beverages';

  @override
  String get categoryFieldDescriptionOptional => 'Description (optional)';

  @override
  String get categoryCreated => 'Category added';

  @override
  String get categoryUpdated => 'Category updated';

  @override
  String categoryDeleted(String name) {
    return 'Category $name deleted';
  }

  @override
  String get categoryNew => 'New category';

  @override
  String get categoryEdit => 'Edit category';

  @override
  String get categoryFieldName => 'Name';

  @override
  String get categoryDeleteConfirmTitle => 'Delete category?';

  @override
  String categoryDeleteConfirmBody(String name) {
    return '\"$name\" will be removed. Products keep their data but lose this category.';
  }

  @override
  String get categoryDeleteBlockedTitle => 'Category still in use';

  @override
  String categoryDeleteBlockedBody(String name, String reason) {
    return '\"$name\" cannot be deleted while products still use it: $reason Move those products to another category (or delete them) and try again.';
  }

  @override
  String categoryDeleteFailed(String message) {
    return 'Could not delete the category: $message';
  }

  @override
  String categorySaveFailed(String message) {
    return 'Could not save the category: $message';
  }

  @override
  String get categoryNameTaken => 'A category with this name already exists';

  @override
  String get customersTitle => 'Customers';

  @override
  String get customersSearchHint => 'Search by name, email or phone';

  @override
  String customersEmptyForSearch(String query) {
    return 'No customers match \"$query\".';
  }

  @override
  String get customersAdd => 'Add customer';

  @override
  String customersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count customers',
      one: '1 customer',
    );
    return '$_temp0';
  }

  @override
  String get customersEmptyHint =>
      'No customers yet.\nAdd your first customer.';

  @override
  String get customersPickerEmpty =>
      'No customers found.\nAdd one in the Customers tab first.';

  @override
  String get customerFieldEmailOptional => 'Email (optional)';

  @override
  String get customerFieldPhoneOptional => 'Phone (optional)';

  @override
  String get customerFieldAddressOptional => 'Address (optional)';

  @override
  String get customerPhoneHint => '+62 812-3456-7890';

  @override
  String get customerNoContact => 'No contact details';

  @override
  String get customerCreated => 'Customer added';

  @override
  String get customerUpdated => 'Customer updated';

  @override
  String customerDeleted(String name) {
    return 'Customer $name deleted';
  }

  @override
  String get customerNew => 'New customer';

  @override
  String get customerEdit => 'Edit customer';

  @override
  String get customerFieldName => 'Name';

  @override
  String get customerDeleteConfirmTitle => 'Delete customer?';

  @override
  String customerDeleteConfirmBody(String name) {
    return '\"$name\" will be removed from the list.';
  }

  @override
  String get customerDeleteBlockedTitle => 'Customer still has orders';

  @override
  String customerDeleteBlockedBody(String name, String reason) {
    return '\"$name\" still has orders that are not cancelled: $reason A customer with order history cannot be deleted; cancel the pending or confirmed orders first if they are not going ahead.';
  }

  @override
  String customerDeleteFailed(String message) {
    return 'Could not delete the customer: $message';
  }

  @override
  String customerSaveFailed(String message) {
    return 'Could not save the customer: $message';
  }

  @override
  String get customerEmailTaken =>
      'This email is already used by another customer';

  @override
  String get customerPick => 'Select customer';

  @override
  String get inventoryLowStockTitle => 'Low stock';

  @override
  String get inventoryLowStockAllGood =>
      'All stock is healthy.\nNo product is below its low-stock threshold.';

  @override
  String inventoryRestockCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products need a restock',
      one: '1 product needs a restock',
    );
    return '$_temp0';
  }

  @override
  String get inventoryOutOfStock => 'Out of stock';

  @override
  String get inventoryHealthy => 'Healthy';

  @override
  String get inventoryCurrentStock => 'Current stock';

  @override
  String inventoryThresholdLine(int value) {
    return 'Low-stock threshold: $value';
  }

  @override
  String inventoryMovementsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count movements',
      one: '1 movement',
    );
    return '$_temp0';
  }

  @override
  String get inventoryHistoryEmptyHint =>
      'No stock movements yet.\nRecord the first stock-in.';

  @override
  String get inventoryEditProduct => 'Edit product';

  @override
  String get movementLabelIn => 'In';

  @override
  String get movementLabelOut => 'Out';

  @override
  String get movementLabelAdjustment => 'Adjustment';

  @override
  String movementRecorded(String type, int before, int after) {
    return '$type recorded: stock $before → $after';
  }

  @override
  String get movementQuantityIn => 'Quantity in';

  @override
  String get movementQuantityOut => 'Quantity out';

  @override
  String get movementQuantityAdjustment => 'New stock (physical count)';

  @override
  String movementCurrentStock(int value) {
    return 'Current stock: $value';
  }

  @override
  String get movementFieldReasonOptional => 'Note (optional)';

  @override
  String get movementReasonHint =>
      'e.g. supplier restock, damaged goods, stock take';

  @override
  String inventoryRemaining(int count) {
    return '$count left';
  }

  @override
  String inventoryThresholdShort(int value) {
    return 'threshold $value';
  }

  @override
  String get movementFormTitle => 'Record stock movement';

  @override
  String get movementFieldQuantity => 'Quantity';

  @override
  String get ordersTitle => 'Sales orders';

  @override
  String get ordersEmptyForFilter => 'No orders match this filter.';

  @override
  String ordersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count orders',
      one: '1 order',
    );
    return '$_temp0';
  }

  @override
  String get ordersEmptyHint => 'No orders yet.\nCreate your first order.';

  @override
  String get ordersFilterCustomerPick => 'Filter by customer';

  @override
  String orderCustomerFallback(String id) {
    return 'Customer #$id';
  }

  @override
  String orderStatusChanged(String number, String status) {
    return 'Order $number is now $status';
  }

  @override
  String orderNoMoreActions(String status) {
    return 'Order $status — no further actions.';
  }

  @override
  String get orderStatusBlockedTitle => 'Status cannot be changed';

  @override
  String get orderConfirmBlockedTitle => 'Order cannot be confirmed';

  @override
  String orderDetailItemsHeading(int count) {
    return 'Items ($count)';
  }

  @override
  String get orderDetailPriceNote =>
      'Prices are a snapshot from when the order was created. Items cannot be edited; cancel and create a new order if something is wrong.';

  @override
  String orderDialogItemsAffected(String items) {
    return 'Items affected:\n$items';
  }

  @override
  String orderCreated(String number) {
    return 'Order $number created (awaiting confirmation)';
  }

  @override
  String orderFormAlreadyAdded(String name) {
    return '$name is already in this order; change its quantity instead.';
  }

  @override
  String orderFormItemsHeading(int count) {
    return 'Items ($count)';
  }

  @override
  String get orderFormTotalCurrent => 'Total (current prices)';

  @override
  String orderFormSubtotal(String amount) {
    return 'Subtotal $amount';
  }

  @override
  String get orderFormRemoveProduct => 'Remove product';

  @override
  String get ordersFilterStatusAll => 'All';

  @override
  String get ordersFilterCustomerClear => 'All customers';

  @override
  String get orderStatusPending => 'Pending';

  @override
  String get orderStatusConfirmed => 'Confirmed';

  @override
  String get orderStatusShipped => 'Shipped';

  @override
  String get orderStatusCancelled => 'Cancelled';

  @override
  String get orderActionConfirm => 'Confirm';

  @override
  String get orderActionShip => 'Ship';

  @override
  String get orderActionCancel => 'Cancel order';

  @override
  String get orderActionMarkPending => 'Mark as pending';

  @override
  String get orderDetailTitle => 'Order detail';

  @override
  String get orderDetailTotal => 'Total';

  @override
  String get orderDetailNotes => 'Notes';

  @override
  String get orderDetailCustomer => 'Customer';

  @override
  String get orderDetailCreatedAt => 'Created';

  @override
  String get orderDetailConfirmedAt => 'Confirmed';

  @override
  String get orderDetailShippedAt => 'Shipped';

  @override
  String get orderDetailCancelledAt => 'Cancelled';

  @override
  String orderItemLine(int quantity, String price) {
    return '$quantity × $price';
  }

  @override
  String get orderConfirmDialogTitle => 'Confirm this order?';

  @override
  String get orderConfirmDialogBody =>
      'Stock will be deducted for every item in this order.';

  @override
  String get orderShipDialogTitle => 'Mark as shipped?';

  @override
  String get orderShipDialogBody =>
      'Stock was already deducted when the order was confirmed; this only records the delivery.';

  @override
  String get orderCancelDialogTitle => 'Cancel this order?';

  @override
  String get orderCancelDialogBodyPending =>
      'The order has not touched stock yet, so nothing is returned.';

  @override
  String get orderCancelDialogBodyConfirmed =>
      'The stock deducted at confirmation is returned to inventory.';

  @override
  String get orderChangeStatusDialogTitle => 'Change status?';

  @override
  String get orderStockProblemBody => 'Nothing changed. Fix these items first:';

  @override
  String orderStatusChangedElsewhere(String message) {
    return 'The order status changed somewhere else ($message). Reloading the order.';
  }

  @override
  String orderItemDeleted(String label) {
    return '$label: the product was deleted, so it cannot be confirmed.';
  }

  @override
  String orderItemProblem(String label, String message) {
    return '$label: $message';
  }

  @override
  String get orderFormTitle => 'New order';

  @override
  String get orderFormCustomer => 'Customer';

  @override
  String get orderFormPickCustomer => 'Select customer';

  @override
  String get orderFormAddProduct => 'Add product';

  @override
  String get orderFormPickProduct => 'Select product';

  @override
  String get orderFormProductAlreadyAdded => 'already added';

  @override
  String get orderFormNoItems => 'No products added yet.';

  @override
  String get orderFormNotesOptional => 'Notes (optional)';

  @override
  String get orderFormSubmit => 'Create order';

  @override
  String orderCreateFailed(String message) {
    return 'Could not create the order: $message';
  }

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardRefresh => 'Refresh';

  @override
  String dashboardRangeDays(int days) {
    return '$days days';
  }

  @override
  String get dashboardRangePick => 'Pick dates';

  @override
  String get dashboardRangePickerHelp => 'Select a date range';

  @override
  String get dashboardRangePickerApply => 'Apply';

  @override
  String get dashboardSummaryTitle => 'Summary';

  @override
  String get dashboardSummaryRevenue => 'Revenue';

  @override
  String get dashboardSummaryOrders => 'Orders';

  @override
  String get dashboardSummaryItemsSold => 'Items sold';

  @override
  String get dashboardSummaryAverageOrder => 'Average/order';

  @override
  String get dashboardTrendTitle => 'Sales trend';

  @override
  String get dashboardTrendDaily => 'Daily';

  @override
  String get dashboardTrendWeekly => 'Weekly';

  @override
  String get dashboardTrendNoPeriods => 'No periods in this range.';

  @override
  String get dashboardTrendNoSales => 'No sales in this range yet.';

  @override
  String dashboardTrendTooltipOrders(int count) {
    return '$count orders';
  }

  @override
  String get dashboardTopProductsTitle => 'Best sellers';

  @override
  String get dashboardTopProductsEmpty => 'No products sold in this range yet.';

  @override
  String dashboardTopProductSold(String sku, int count) {
    return '$sku · $count sold';
  }

  @override
  String get dashboardCategoryTitle => 'Sales by category';

  @override
  String get dashboardCategoryEmpty => 'No category sales in this range yet.';

  @override
  String get dashboardLowStockTitle => 'Low stock';

  @override
  String get dashboardLowStockSubtitle => 'Products to reorder soon';

  @override
  String get dashboardLowStockAllGood => 'All stock levels are fine';

  @override
  String get dashboardLowStockCountFailed => 'Count could not be loaded';

  @override
  String get dashboardLowStockReload => 'Reload the count';

  @override
  String get dashboardInsightsTitle => 'Business insights';

  @override
  String get dashboardInsightsUnavailable =>
      'Business insights are unavailable';

  @override
  String get dashboardInsightsUnavailableDetail =>
      'The analysis service is down. The sales figures on this page are still up to date.';

  @override
  String get dashboardInsightsEmpty =>
      'No sales in this range yet, so there are no insights.';

  @override
  String get dashboardInsightsNone => 'No insight for this product.';

  @override
  String get dashboardForecastTitle => 'Demand forecast';

  @override
  String get dashboardForecastUnavailable => 'Demand forecast is unavailable';

  @override
  String get dashboardForecastUnavailableDetail =>
      'The forecasting service is down. The other sales data on this page is still up to date.';

  @override
  String get dashboardForecastEmpty =>
      'Nothing was sold in this range, so there is nothing to forecast.';

  @override
  String dashboardForecastHorizon(int days) {
    return 'Next $days days, from the daily sales average';
  }

  @override
  String dashboardForecastUnits(String value) {
    return '$value units';
  }

  @override
  String dashboardForecastPerDay(String value) {
    return '$value/day';
  }

  @override
  String dashboardForecastSemantics(String product, String date) {
    return 'Forecast for $product until $date';
  }

  @override
  String get trendUp => 'Up';

  @override
  String get trendDown => 'Down';

  @override
  String get trendStable => 'Steady';

  @override
  String trendUpPercent(int percent) {
    return 'Up $percent%';
  }

  @override
  String trendDownPercent(int percent) {
    return 'Down $percent%';
  }
}
