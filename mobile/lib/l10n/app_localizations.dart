import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// Application name, shown as the task title
  ///
  /// In en, this message translates to:
  /// **'Inventory Intelligence'**
  String get appTitle;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonUnderstood.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get commonUnderstood;

  /// No description provided for @commonLoadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get commonLoadMore;

  /// No description provided for @commonNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results.'**
  String get commonNoResults;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonUnexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get commonUnexpectedError;

  /// No description provided for @commonLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load: {message}'**
  String commonLoadFailed(String message);

  /// No description provided for @commonSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get commonSaveChanges;

  /// No description provided for @commonClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get commonClearSearch;

  /// No description provided for @commonValidationFailed.
  ///
  /// In en, this message translates to:
  /// **'Please fix the highlighted fields.'**
  String get commonValidationFailed;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get navProducts;

  /// No description provided for @navCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get navCategories;

  /// No description provided for @navCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get navCustomers;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @networkTimeout.
  ///
  /// In en, this message translates to:
  /// **'The server did not respond. Try again.'**
  String get networkTimeout;

  /// No description provided for @networkCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled.'**
  String get networkCancelled;

  /// No description provided for @networkUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the server. Check your connection or API_BASE_URL.'**
  String get networkUnreachable;

  /// No description provided for @networkServerError.
  ///
  /// In en, this message translates to:
  /// **'Server error (HTTP {status})'**
  String networkServerError(String status);

  /// No description provided for @networkServerErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get networkServerErrorUnknown;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Applies to the app and to the messages the server sends.'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get settingsLanguageIndonesian;

  /// No description provided for @settingsAppearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceSection;

  /// No description provided for @settingsThemeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeMode;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'System follows your phone\'s light and dark setting.'**
  String get settingsThemeSubtitle;

  /// No description provided for @settingsAccent.
  ///
  /// In en, this message translates to:
  /// **'Accent colour'**
  String get settingsAccent;

  /// No description provided for @settingsAccentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Colours the buttons, charts and highlights. Status colours stay the same so a falling trend always reads as falling.'**
  String get settingsAccentSubtitle;

  /// No description provided for @settingsAccentSelected.
  ///
  /// In en, this message translates to:
  /// **'{name} selected'**
  String settingsAccentSelected(String name);

  /// No description provided for @settingsAccentTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get settingsAccentTeal;

  /// No description provided for @settingsAccentIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get settingsAccentIndigo;

  /// No description provided for @settingsAccentViolet.
  ///
  /// In en, this message translates to:
  /// **'Violet'**
  String get settingsAccentViolet;

  /// No description provided for @settingsAccentMagenta.
  ///
  /// In en, this message translates to:
  /// **'Magenta'**
  String get settingsAccentMagenta;

  /// No description provided for @settingsAccentAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get settingsAccentAmber;

  /// No description provided for @settingsAccentSlate.
  ///
  /// In en, this message translates to:
  /// **'Slate'**
  String get settingsAccentSlate;

  /// No description provided for @settingsPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get settingsPreviewTitle;

  /// No description provided for @settingsPreviewMetric.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get settingsPreviewMetric;

  /// No description provided for @settingsPreviewAction.
  ///
  /// In en, this message translates to:
  /// **'Primary action'**
  String get settingsPreviewAction;

  /// No description provided for @settingsPreviewPositive.
  ///
  /// In en, this message translates to:
  /// **'Up 12%'**
  String get settingsPreviewPositive;

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// No description provided for @settingsCurrencyNote.
  ///
  /// In en, this message translates to:
  /// **'Amounts stay in Rupiah (Rp) in both languages.'**
  String get settingsCurrencyNote;

  /// No description provided for @productsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productsTitle;

  /// No description provided for @productsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or SKU'**
  String get productsSearchHint;

  /// No description provided for @productsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products yet.'**
  String get productsEmpty;

  /// No description provided for @productsEmptyForSearch.
  ///
  /// In en, this message translates to:
  /// **'No products match \"{query}\".'**
  String productsEmptyForSearch(String query);

  /// No description provided for @productsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get productsAdd;

  /// No description provided for @productsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product} other{{count} products}}'**
  String productsCount(int count);

  /// No description provided for @productsEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No products yet.\nAdd your first product.'**
  String get productsEmptyHint;

  /// No description provided for @productSkuHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. KOPI-001'**
  String get productSkuHint;

  /// No description provided for @productFieldDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get productFieldDescriptionOptional;

  /// No description provided for @productCreated.
  ///
  /// In en, this message translates to:
  /// **'Product added'**
  String get productCreated;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated'**
  String get productUpdated;

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String productDeleted(String name);

  /// No description provided for @productCategoryLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the category list'**
  String get productCategoryLoadFailed;

  /// No description provided for @productCategoryReload.
  ///
  /// In en, this message translates to:
  /// **'Reload categories'**
  String get productCategoryReload;

  /// No description provided for @productCategoryFallback.
  ///
  /// In en, this message translates to:
  /// **'Category #{id}'**
  String productCategoryFallback(String id);

  /// No description provided for @productNew.
  ///
  /// In en, this message translates to:
  /// **'New product'**
  String get productNew;

  /// No description provided for @productEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get productEdit;

  /// No description provided for @productFieldSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get productFieldSku;

  /// No description provided for @productFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get productFieldName;

  /// No description provided for @productFieldPrice.
  ///
  /// In en, this message translates to:
  /// **'Price (Rp)'**
  String get productFieldPrice;

  /// No description provided for @productFieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get productFieldCategory;

  /// No description provided for @productNoCategory.
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get productNoCategory;

  /// No description provided for @productDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete product?'**
  String get productDeleteConfirmTitle;

  /// No description provided for @productDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" ({sku}) will be removed from the list.'**
  String productDeleteConfirmBody(String name, String sku);

  /// No description provided for @productDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the product: {message}'**
  String productDeleteFailed(String message);

  /// No description provided for @productSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the product: {message}'**
  String productSaveFailed(String message);

  /// No description provided for @productSkuTaken.
  ///
  /// In en, this message translates to:
  /// **'This SKU is already used by another product'**
  String get productSkuTaken;

  /// No description provided for @productStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Product detail'**
  String get productStockTitle;

  /// No description provided for @productStockLow.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get productStockLow;

  /// No description provided for @productStockRecordMovement.
  ///
  /// In en, this message translates to:
  /// **'Record movement'**
  String get productStockRecordMovement;

  /// No description provided for @productStockHistory.
  ///
  /// In en, this message translates to:
  /// **'Movement history'**
  String get productStockHistory;

  /// No description provided for @validationSkuRequired.
  ///
  /// In en, this message translates to:
  /// **'SKU is required'**
  String get validationSkuRequired;

  /// No description provided for @validationSkuTooLong.
  ///
  /// In en, this message translates to:
  /// **'SKU must be at most {max} characters'**
  String validationSkuTooLong(int max);

  /// No description provided for @validationNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get validationNameRequired;

  /// No description provided for @validationNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name must be at most {max} characters'**
  String validationNameTooLong(int max);

  /// No description provided for @validationDescriptionTooLong.
  ///
  /// In en, this message translates to:
  /// **'Description must be at most {max} characters'**
  String validationDescriptionTooLong(int max);

  /// No description provided for @validationPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get validationPriceRequired;

  /// No description provided for @validationPriceInvalid.
  ///
  /// In en, this message translates to:
  /// **'Price must be a whole number'**
  String get validationPriceInvalid;

  /// No description provided for @validationPriceNegative.
  ///
  /// In en, this message translates to:
  /// **'Price cannot be negative'**
  String get validationPriceNegative;

  /// No description provided for @validationPriceTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Price is too large'**
  String get validationPriceTooLarge;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'That email address is not valid'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationEmailTooLong.
  ///
  /// In en, this message translates to:
  /// **'Email must be at most {max} characters'**
  String validationEmailTooLong(int max);

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Phone must be 6–{max} digits (+, spaces, dashes and brackets allowed)'**
  String validationPhoneInvalid(int max);

  /// No description provided for @validationAddressTooLong.
  ///
  /// In en, this message translates to:
  /// **'Address must be at most {max} characters'**
  String validationAddressTooLong(int max);

  /// No description provided for @validationQuantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Quantity is required'**
  String get validationQuantityRequired;

  /// No description provided for @validationQuantityInvalid.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be a whole number'**
  String get validationQuantityInvalid;

  /// No description provided for @validationQuantityPositive.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than 0'**
  String get validationQuantityPositive;

  /// No description provided for @validationQuantityNegative.
  ///
  /// In en, this message translates to:
  /// **'Quantity cannot be negative'**
  String get validationQuantityNegative;

  /// No description provided for @validationQuantityTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be at most {max}'**
  String validationQuantityTooLarge(int max);

  /// No description provided for @validationReasonTooLong.
  ///
  /// In en, this message translates to:
  /// **'Reason must be at most {max} characters'**
  String validationReasonTooLong(int max);

  /// No description provided for @validationThresholdRequired.
  ///
  /// In en, this message translates to:
  /// **'Threshold is required'**
  String get validationThresholdRequired;

  /// No description provided for @validationThresholdInvalid.
  ///
  /// In en, this message translates to:
  /// **'Threshold must be a whole number'**
  String get validationThresholdInvalid;

  /// No description provided for @validationThresholdNegative.
  ///
  /// In en, this message translates to:
  /// **'Threshold cannot be negative'**
  String get validationThresholdNegative;

  /// No description provided for @validationCustomerRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick a customer first'**
  String get validationCustomerRequired;

  /// No description provided for @validationItemsRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least one product'**
  String get validationItemsRequired;

  /// No description provided for @validationOrderTransition.
  ///
  /// In en, this message translates to:
  /// **'This order cannot move to that status.'**
  String get validationOrderTransition;

  /// No description provided for @validationCategoryInvalid.
  ///
  /// In en, this message translates to:
  /// **'Select a valid category'**
  String get validationCategoryInvalid;

  /// No description provided for @validationItemsTooMany.
  ///
  /// In en, this message translates to:
  /// **'At most {max} products per order'**
  String validationItemsTooMany(int max);

  /// No description provided for @validationItemsDuplicate.
  ///
  /// In en, this message translates to:
  /// **'This product is already on line {line}; merge the quantities'**
  String validationItemsDuplicate(int line);

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @categoriesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search categories'**
  String get categoriesSearchHint;

  /// No description provided for @categoriesEmptyForSearch.
  ///
  /// In en, this message translates to:
  /// **'No categories match \"{query}\".'**
  String categoriesEmptyForSearch(String query);

  /// No description provided for @categoriesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get categoriesAdd;

  /// No description provided for @categoriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 category} other{{count} categories}}'**
  String categoriesCount(int count);

  /// No description provided for @categoriesEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No categories yet.\nAdd your first category.'**
  String get categoriesEmptyHint;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Beverages'**
  String get categoryNameHint;

  /// No description provided for @categoryFieldDescriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get categoryFieldDescriptionOptional;

  /// No description provided for @categoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Category added'**
  String get categoryCreated;

  /// No description provided for @categoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Category updated'**
  String get categoryUpdated;

  /// No description provided for @categoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category {name} deleted'**
  String categoryDeleted(String name);

  /// No description provided for @categoryNew.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get categoryNew;

  /// No description provided for @categoryEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get categoryEdit;

  /// No description provided for @categoryFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get categoryFieldName;

  /// No description provided for @categoryDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete category?'**
  String get categoryDeleteConfirmTitle;

  /// No description provided for @categoryDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be removed. Products keep their data but lose this category.'**
  String categoryDeleteConfirmBody(String name);

  /// No description provided for @categoryDeleteBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Category still in use'**
  String get categoryDeleteBlockedTitle;

  /// No description provided for @categoryDeleteBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" cannot be deleted while products still use it: {reason} Move those products to another category (or delete them) and try again.'**
  String categoryDeleteBlockedBody(String name, String reason);

  /// No description provided for @categoryDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the category: {message}'**
  String categoryDeleteFailed(String message);

  /// No description provided for @categorySaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the category: {message}'**
  String categorySaveFailed(String message);

  /// No description provided for @categoryNameTaken.
  ///
  /// In en, this message translates to:
  /// **'A category with this name already exists'**
  String get categoryNameTaken;

  /// No description provided for @customersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customersTitle;

  /// No description provided for @customersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, email or phone'**
  String get customersSearchHint;

  /// No description provided for @customersEmptyForSearch.
  ///
  /// In en, this message translates to:
  /// **'No customers match \"{query}\".'**
  String customersEmptyForSearch(String query);

  /// No description provided for @customersAdd.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get customersAdd;

  /// No description provided for @customersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 customer} other{{count} customers}}'**
  String customersCount(int count);

  /// No description provided for @customersEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No customers yet.\nAdd your first customer.'**
  String get customersEmptyHint;

  /// No description provided for @customersPickerEmpty.
  ///
  /// In en, this message translates to:
  /// **'No customers found.\nAdd one in the Customers tab first.'**
  String get customersPickerEmpty;

  /// No description provided for @customerFieldEmailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get customerFieldEmailOptional;

  /// No description provided for @customerFieldPhoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get customerFieldPhoneOptional;

  /// No description provided for @customerFieldAddressOptional.
  ///
  /// In en, this message translates to:
  /// **'Address (optional)'**
  String get customerFieldAddressOptional;

  /// No description provided for @customerPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+62 812-3456-7890'**
  String get customerPhoneHint;

  /// No description provided for @customerNoContact.
  ///
  /// In en, this message translates to:
  /// **'No contact details'**
  String get customerNoContact;

  /// No description provided for @customerCreated.
  ///
  /// In en, this message translates to:
  /// **'Customer added'**
  String get customerCreated;

  /// No description provided for @customerUpdated.
  ///
  /// In en, this message translates to:
  /// **'Customer updated'**
  String get customerUpdated;

  /// No description provided for @customerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Customer {name} deleted'**
  String customerDeleted(String name);

  /// No description provided for @customerNew.
  ///
  /// In en, this message translates to:
  /// **'New customer'**
  String get customerNew;

  /// No description provided for @customerEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit customer'**
  String get customerEdit;

  /// No description provided for @customerFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get customerFieldName;

  /// No description provided for @customerDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete customer?'**
  String get customerDeleteConfirmTitle;

  /// No description provided for @customerDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be removed from the list.'**
  String customerDeleteConfirmBody(String name);

  /// No description provided for @customerDeleteBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer still has orders'**
  String get customerDeleteBlockedTitle;

  /// No description provided for @customerDeleteBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" still has orders that are not cancelled: {reason} A customer with order history cannot be deleted; cancel the pending or confirmed orders first if they are not going ahead.'**
  String customerDeleteBlockedBody(String name, String reason);

  /// No description provided for @customerDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the customer: {message}'**
  String customerDeleteFailed(String message);

  /// No description provided for @customerSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the customer: {message}'**
  String customerSaveFailed(String message);

  /// No description provided for @customerEmailTaken.
  ///
  /// In en, this message translates to:
  /// **'This email is already used by another customer'**
  String get customerEmailTaken;

  /// No description provided for @customerPick.
  ///
  /// In en, this message translates to:
  /// **'Select customer'**
  String get customerPick;

  /// No description provided for @inventoryLowStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get inventoryLowStockTitle;

  /// No description provided for @inventoryLowStockAllGood.
  ///
  /// In en, this message translates to:
  /// **'All stock is healthy.\nNo product is below its low-stock threshold.'**
  String get inventoryLowStockAllGood;

  /// No description provided for @inventoryRestockCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 product needs a restock} other{{count} products need a restock}}'**
  String inventoryRestockCount(int count);

  /// No description provided for @inventoryOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get inventoryOutOfStock;

  /// No description provided for @inventoryHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get inventoryHealthy;

  /// No description provided for @inventoryCurrentStock.
  ///
  /// In en, this message translates to:
  /// **'Current stock'**
  String get inventoryCurrentStock;

  /// No description provided for @inventoryThresholdLine.
  ///
  /// In en, this message translates to:
  /// **'Low-stock threshold: {value}'**
  String inventoryThresholdLine(int value);

  /// No description provided for @inventoryMovementsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 movement} other{{count} movements}}'**
  String inventoryMovementsCount(int count);

  /// No description provided for @inventoryHistoryEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No stock movements yet.\nRecord the first stock-in.'**
  String get inventoryHistoryEmptyHint;

  /// No description provided for @inventoryEditProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get inventoryEditProduct;

  /// No description provided for @movementLabelIn.
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get movementLabelIn;

  /// No description provided for @movementLabelOut.
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get movementLabelOut;

  /// No description provided for @movementLabelAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get movementLabelAdjustment;

  /// No description provided for @movementRecorded.
  ///
  /// In en, this message translates to:
  /// **'{type} recorded: stock {before} → {after}'**
  String movementRecorded(String type, int before, int after);

  /// No description provided for @movementQuantityIn.
  ///
  /// In en, this message translates to:
  /// **'Quantity in'**
  String get movementQuantityIn;

  /// No description provided for @movementQuantityOut.
  ///
  /// In en, this message translates to:
  /// **'Quantity out'**
  String get movementQuantityOut;

  /// No description provided for @movementQuantityAdjustment.
  ///
  /// In en, this message translates to:
  /// **'New stock (physical count)'**
  String get movementQuantityAdjustment;

  /// No description provided for @movementCurrentStock.
  ///
  /// In en, this message translates to:
  /// **'Current stock: {value}'**
  String movementCurrentStock(int value);

  /// No description provided for @movementFieldReasonOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get movementFieldReasonOptional;

  /// No description provided for @movementReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. supplier restock, damaged goods, stock take'**
  String get movementReasonHint;

  /// No description provided for @inventoryRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} left'**
  String inventoryRemaining(int count);

  /// No description provided for @inventoryThresholdShort.
  ///
  /// In en, this message translates to:
  /// **'threshold {value}'**
  String inventoryThresholdShort(int value);

  /// No description provided for @movementFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Record stock movement'**
  String get movementFormTitle;

  /// No description provided for @movementFieldQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get movementFieldQuantity;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales orders'**
  String get ordersTitle;

  /// No description provided for @ordersEmptyForFilter.
  ///
  /// In en, this message translates to:
  /// **'No orders match this filter.'**
  String get ordersEmptyForFilter;

  /// No description provided for @ordersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 order} other{{count} orders}}'**
  String ordersCount(int count);

  /// No description provided for @ordersEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'No orders yet.\nCreate your first order.'**
  String get ordersEmptyHint;

  /// No description provided for @ordersFilterCustomerPick.
  ///
  /// In en, this message translates to:
  /// **'Filter by customer'**
  String get ordersFilterCustomerPick;

  /// No description provided for @orderCustomerFallback.
  ///
  /// In en, this message translates to:
  /// **'Customer #{id}'**
  String orderCustomerFallback(String id);

  /// No description provided for @orderStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Order {number} is now {status}'**
  String orderStatusChanged(String number, String status);

  /// No description provided for @orderNoMoreActions.
  ///
  /// In en, this message translates to:
  /// **'Order {status} — no further actions.'**
  String orderNoMoreActions(String status);

  /// No description provided for @orderStatusBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Status cannot be changed'**
  String get orderStatusBlockedTitle;

  /// No description provided for @orderConfirmBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order cannot be confirmed'**
  String get orderConfirmBlockedTitle;

  /// No description provided for @orderDetailItemsHeading.
  ///
  /// In en, this message translates to:
  /// **'Items ({count})'**
  String orderDetailItemsHeading(int count);

  /// No description provided for @orderDetailPriceNote.
  ///
  /// In en, this message translates to:
  /// **'Prices are a snapshot from when the order was created. Items cannot be edited; cancel and create a new order if something is wrong.'**
  String get orderDetailPriceNote;

  /// No description provided for @orderDialogItemsAffected.
  ///
  /// In en, this message translates to:
  /// **'Items affected:\n{items}'**
  String orderDialogItemsAffected(String items);

  /// No description provided for @orderCreated.
  ///
  /// In en, this message translates to:
  /// **'Order {number} created (awaiting confirmation)'**
  String orderCreated(String number);

  /// No description provided for @orderFormAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} is already in this order; change its quantity instead.'**
  String orderFormAlreadyAdded(String name);

  /// No description provided for @orderFormItemsHeading.
  ///
  /// In en, this message translates to:
  /// **'Items ({count})'**
  String orderFormItemsHeading(int count);

  /// No description provided for @orderFormTotalCurrent.
  ///
  /// In en, this message translates to:
  /// **'Total (current prices)'**
  String get orderFormTotalCurrent;

  /// No description provided for @orderFormSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal {amount}'**
  String orderFormSubtotal(String amount);

  /// No description provided for @orderFormRemoveProduct.
  ///
  /// In en, this message translates to:
  /// **'Remove product'**
  String get orderFormRemoveProduct;

  /// No description provided for @ordersFilterStatusAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ordersFilterStatusAll;

  /// No description provided for @ordersFilterCustomerClear.
  ///
  /// In en, this message translates to:
  /// **'All customers'**
  String get ordersFilterCustomerClear;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get orderStatusPending;

  /// No description provided for @orderStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderStatusConfirmed;

  /// No description provided for @orderStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderStatusCancelled;

  /// No description provided for @orderActionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get orderActionConfirm;

  /// No description provided for @orderActionShip.
  ///
  /// In en, this message translates to:
  /// **'Ship'**
  String get orderActionShip;

  /// No description provided for @orderActionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get orderActionCancel;

  /// No description provided for @orderActionMarkPending.
  ///
  /// In en, this message translates to:
  /// **'Mark as pending'**
  String get orderActionMarkPending;

  /// No description provided for @orderDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order detail'**
  String get orderDetailTitle;

  /// No description provided for @orderDetailTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get orderDetailTotal;

  /// No description provided for @orderDetailNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get orderDetailNotes;

  /// No description provided for @orderDetailCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get orderDetailCustomer;

  /// No description provided for @orderDetailCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get orderDetailCreatedAt;

  /// No description provided for @orderDetailConfirmedAt.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get orderDetailConfirmedAt;

  /// No description provided for @orderDetailShippedAt.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderDetailShippedAt;

  /// No description provided for @orderDetailCancelledAt.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get orderDetailCancelledAt;

  /// No description provided for @orderItemLine.
  ///
  /// In en, this message translates to:
  /// **'{quantity} × {price}'**
  String orderItemLine(int quantity, String price);

  /// No description provided for @orderConfirmDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm this order?'**
  String get orderConfirmDialogTitle;

  /// No description provided for @orderConfirmDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Stock will be deducted for every item in this order.'**
  String get orderConfirmDialogBody;

  /// No description provided for @orderShipDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark as shipped?'**
  String get orderShipDialogTitle;

  /// No description provided for @orderShipDialogBody.
  ///
  /// In en, this message translates to:
  /// **'Stock was already deducted when the order was confirmed; this only records the delivery.'**
  String get orderShipDialogBody;

  /// No description provided for @orderCancelDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel this order?'**
  String get orderCancelDialogTitle;

  /// No description provided for @orderCancelDialogBodyPending.
  ///
  /// In en, this message translates to:
  /// **'The order has not touched stock yet, so nothing is returned.'**
  String get orderCancelDialogBodyPending;

  /// No description provided for @orderCancelDialogBodyConfirmed.
  ///
  /// In en, this message translates to:
  /// **'The stock deducted at confirmation is returned to inventory.'**
  String get orderCancelDialogBodyConfirmed;

  /// No description provided for @orderChangeStatusDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Change status?'**
  String get orderChangeStatusDialogTitle;

  /// No description provided for @orderStockProblemBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing changed. Fix these items first:'**
  String get orderStockProblemBody;

  /// No description provided for @orderStatusChangedElsewhere.
  ///
  /// In en, this message translates to:
  /// **'The order status changed somewhere else ({message}). Reloading the order.'**
  String orderStatusChangedElsewhere(String message);

  /// No description provided for @orderItemDeleted.
  ///
  /// In en, this message translates to:
  /// **'{label}: the product was deleted, so it cannot be confirmed.'**
  String orderItemDeleted(String label);

  /// No description provided for @orderItemProblem.
  ///
  /// In en, this message translates to:
  /// **'{label}: {message}'**
  String orderItemProblem(String label, String message);

  /// No description provided for @orderFormTitle.
  ///
  /// In en, this message translates to:
  /// **'New order'**
  String get orderFormTitle;

  /// No description provided for @orderFormCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get orderFormCustomer;

  /// No description provided for @orderFormPickCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select customer'**
  String get orderFormPickCustomer;

  /// No description provided for @orderFormAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get orderFormAddProduct;

  /// No description provided for @orderFormPickProduct.
  ///
  /// In en, this message translates to:
  /// **'Select product'**
  String get orderFormPickProduct;

  /// No description provided for @orderFormProductAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'already added'**
  String get orderFormProductAlreadyAdded;

  /// No description provided for @orderFormNoItems.
  ///
  /// In en, this message translates to:
  /// **'No products added yet.'**
  String get orderFormNoItems;

  /// No description provided for @orderFormNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get orderFormNotesOptional;

  /// No description provided for @orderFormSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create order'**
  String get orderFormSubmit;

  /// No description provided for @orderCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the order: {message}'**
  String orderCreateFailed(String message);

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get dashboardRefresh;

  /// No description provided for @dashboardRangeDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String dashboardRangeDays(int days);

  /// No description provided for @dashboardRangePick.
  ///
  /// In en, this message translates to:
  /// **'Pick dates'**
  String get dashboardRangePick;

  /// No description provided for @dashboardRangePickerHelp.
  ///
  /// In en, this message translates to:
  /// **'Select a date range'**
  String get dashboardRangePickerHelp;

  /// No description provided for @dashboardRangePickerApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get dashboardRangePickerApply;

  /// No description provided for @dashboardSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get dashboardSummaryTitle;

  /// No description provided for @dashboardSummaryRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get dashboardSummaryRevenue;

  /// No description provided for @dashboardSummaryOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get dashboardSummaryOrders;

  /// No description provided for @dashboardSummaryItemsSold.
  ///
  /// In en, this message translates to:
  /// **'Items sold'**
  String get dashboardSummaryItemsSold;

  /// No description provided for @dashboardSummaryAverageOrder.
  ///
  /// In en, this message translates to:
  /// **'Average/order'**
  String get dashboardSummaryAverageOrder;

  /// No description provided for @dashboardTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales trend'**
  String get dashboardTrendTitle;

  /// No description provided for @dashboardTrendDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get dashboardTrendDaily;

  /// No description provided for @dashboardTrendWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get dashboardTrendWeekly;

  /// No description provided for @dashboardTrendNoPeriods.
  ///
  /// In en, this message translates to:
  /// **'No periods in this range.'**
  String get dashboardTrendNoPeriods;

  /// No description provided for @dashboardTrendNoSales.
  ///
  /// In en, this message translates to:
  /// **'No sales in this range yet.'**
  String get dashboardTrendNoSales;

  /// No description provided for @dashboardTrendTooltipOrders.
  ///
  /// In en, this message translates to:
  /// **'{count} orders'**
  String dashboardTrendTooltipOrders(int count);

  /// No description provided for @dashboardTopProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Best sellers'**
  String get dashboardTopProductsTitle;

  /// No description provided for @dashboardTopProductsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products sold in this range yet.'**
  String get dashboardTopProductsEmpty;

  /// No description provided for @dashboardTopProductSold.
  ///
  /// In en, this message translates to:
  /// **'{sku} · {count} sold'**
  String dashboardTopProductSold(String sku, int count);

  /// No description provided for @dashboardCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales by category'**
  String get dashboardCategoryTitle;

  /// No description provided for @dashboardCategoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No category sales in this range yet.'**
  String get dashboardCategoryEmpty;

  /// No description provided for @dashboardLowStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get dashboardLowStockTitle;

  /// No description provided for @dashboardLowStockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Products to reorder soon'**
  String get dashboardLowStockSubtitle;

  /// No description provided for @dashboardLowStockAllGood.
  ///
  /// In en, this message translates to:
  /// **'All stock levels are fine'**
  String get dashboardLowStockAllGood;

  /// No description provided for @dashboardLowStockCountFailed.
  ///
  /// In en, this message translates to:
  /// **'Count could not be loaded'**
  String get dashboardLowStockCountFailed;

  /// No description provided for @dashboardLowStockReload.
  ///
  /// In en, this message translates to:
  /// **'Reload the count'**
  String get dashboardLowStockReload;

  /// No description provided for @dashboardInsightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Business insights'**
  String get dashboardInsightsTitle;

  /// No description provided for @dashboardInsightsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Business insights are unavailable'**
  String get dashboardInsightsUnavailable;

  /// No description provided for @dashboardInsightsUnavailableDetail.
  ///
  /// In en, this message translates to:
  /// **'The analysis service is down. The sales figures on this page are still up to date.'**
  String get dashboardInsightsUnavailableDetail;

  /// No description provided for @dashboardInsightsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sales in this range yet, so there are no insights.'**
  String get dashboardInsightsEmpty;

  /// No description provided for @dashboardInsightsNone.
  ///
  /// In en, this message translates to:
  /// **'No insight for this product.'**
  String get dashboardInsightsNone;

  /// No description provided for @dashboardForecastTitle.
  ///
  /// In en, this message translates to:
  /// **'Demand forecast'**
  String get dashboardForecastTitle;

  /// No description provided for @dashboardForecastUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Demand forecast is unavailable'**
  String get dashboardForecastUnavailable;

  /// No description provided for @dashboardForecastUnavailableDetail.
  ///
  /// In en, this message translates to:
  /// **'The forecasting service is down. The other sales data on this page is still up to date.'**
  String get dashboardForecastUnavailableDetail;

  /// No description provided for @dashboardForecastEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing was sold in this range, so there is nothing to forecast.'**
  String get dashboardForecastEmpty;

  /// No description provided for @dashboardForecastHorizon.
  ///
  /// In en, this message translates to:
  /// **'Next {days} days, from the daily sales average'**
  String dashboardForecastHorizon(int days);

  /// No description provided for @dashboardForecastUnits.
  ///
  /// In en, this message translates to:
  /// **'{value} units'**
  String dashboardForecastUnits(String value);

  /// No description provided for @dashboardForecastPerDay.
  ///
  /// In en, this message translates to:
  /// **'{value}/day'**
  String dashboardForecastPerDay(String value);

  /// No description provided for @dashboardForecastSemantics.
  ///
  /// In en, this message translates to:
  /// **'Forecast for {product} until {date}'**
  String dashboardForecastSemantics(String product, String date);

  /// No description provided for @trendUp.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get trendUp;

  /// No description provided for @trendDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get trendDown;

  /// No description provided for @trendStable.
  ///
  /// In en, this message translates to:
  /// **'Steady'**
  String get trendStable;

  /// No description provided for @trendUpPercent.
  ///
  /// In en, this message translates to:
  /// **'Up {percent}%'**
  String trendUpPercent(int percent);

  /// No description provided for @trendDownPercent.
  ///
  /// In en, this message translates to:
  /// **'Down {percent}%'**
  String trendDownPercent(int percent);

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the account your administrator gave you.'**
  String get loginSubtitle;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @loginShowPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPassword;

  /// No description provided for @loginHidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginHidePassword;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password. Check both and try again.'**
  String get loginInvalidCredentials;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in: {message}'**
  String loginFailed(String message);

  /// No description provided for @splashCheckingSession.
  ///
  /// In en, this message translates to:
  /// **'Checking your session…'**
  String get splashCheckingSession;

  /// No description provided for @settingsAccountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountSection;

  /// No description provided for @settingsAccountRole.
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String settingsAccountRole(String role);

  /// No description provided for @settingsLogout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get settingsLogout;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {min} characters'**
  String validationPasswordTooShort(int min);

  /// No description provided for @validationPasswordTooLong.
  ///
  /// In en, this message translates to:
  /// **'Password must be at most {max} bytes'**
  String validationPasswordTooLong(int max);

  /// No description provided for @validationRoleRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a role'**
  String get validationRoleRequired;

  /// No description provided for @settingsAdminSection.
  ///
  /// In en, this message translates to:
  /// **'Administration'**
  String get settingsAdminSection;

  /// No description provided for @settingsAdminRoles.
  ///
  /// In en, this message translates to:
  /// **'Roles & permissions'**
  String get settingsAdminRoles;

  /// No description provided for @settingsAdminRolesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Decide who can do what'**
  String get settingsAdminRolesSubtitle;

  /// No description provided for @settingsAdminUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get settingsAdminUsers;

  /// No description provided for @settingsAdminUsersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts, their role and access'**
  String get settingsAdminUsersSubtitle;

  /// No description provided for @rolesTitle.
  ///
  /// In en, this message translates to:
  /// **'Roles & permissions'**
  String get rolesTitle;

  /// No description provided for @rolesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add role'**
  String get rolesAdd;

  /// No description provided for @rolesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No roles yet.'**
  String get rolesEmpty;

  /// No description provided for @roleSystemBadge.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get roleSystemBadge;

  /// No description provided for @rolePermissionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No permissions} =1{1 permission} other{{count} permissions}}'**
  String rolePermissionCount(int count);

  /// No description provided for @roleAllPermissions.
  ///
  /// In en, this message translates to:
  /// **'All permissions'**
  String get roleAllPermissions;

  /// No description provided for @roleUserCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No linked users} =1{1 linked user} other{{count} linked users}}'**
  String roleUserCount(int count);

  /// No description provided for @roleNew.
  ///
  /// In en, this message translates to:
  /// **'New role'**
  String get roleNew;

  /// No description provided for @roleEdit.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleEdit;

  /// No description provided for @roleFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get roleFieldName;

  /// No description provided for @roleFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get roleFieldDescription;

  /// No description provided for @roleSystemNote.
  ///
  /// In en, this message translates to:
  /// **'This is the system role. It always holds every permission, and it can\'t be renamed, deleted or given a permission list.'**
  String get roleSystemNote;

  /// No description provided for @roleCreated.
  ///
  /// In en, this message translates to:
  /// **'Role \"{name}\" created'**
  String roleCreated(String name);

  /// No description provided for @roleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Role saved'**
  String get roleUpdated;

  /// No description provided for @roleSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the role: {message}'**
  String roleSaveFailed(String message);

  /// No description provided for @rolePermissionsSection.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get rolePermissionsSection;

  /// No description provided for @roleEditPermissions.
  ///
  /// In en, this message translates to:
  /// **'Edit permissions'**
  String get roleEditPermissions;

  /// No description provided for @roleNoPermissionsYet.
  ///
  /// In en, this message translates to:
  /// **'This role has no permissions yet.'**
  String get roleNoPermissionsYet;

  /// No description provided for @roleDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete role?'**
  String get roleDeleteConfirmTitle;

  /// No description provided for @roleDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'The role \"{name}\" will be deleted.'**
  String roleDeleteConfirmBody(String name);

  /// No description provided for @roleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Role \"{name}\" deleted'**
  String roleDeleted(String name);

  /// No description provided for @roleDeleteBlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'Role can\'t be deleted'**
  String get roleDeleteBlockedTitle;

  /// No description provided for @roleDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the role: {message}'**
  String roleDeleteFailed(String message);

  /// No description provided for @permissionEditorTitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions · {role}'**
  String permissionEditorTitle(String role);

  /// No description provided for @permissionEditorSave.
  ///
  /// In en, this message translates to:
  /// **'Save permissions'**
  String get permissionEditorSave;

  /// No description provided for @permissionEditorSaved.
  ///
  /// In en, this message translates to:
  /// **'Permissions saved'**
  String get permissionEditorSaved;

  /// No description provided for @permissionEditorSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} selected'**
  String permissionEditorSelected(int count, int total);

  /// No description provided for @permissionEditorNotHeld.
  ///
  /// In en, this message translates to:
  /// **'Greyed-out permissions are ones you don\'t hold yourself, so you can\'t grant them.'**
  String get permissionEditorNotHeld;

  /// No description provided for @permissionEditorSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the permissions: {message}'**
  String permissionEditorSaveFailed(String message);

  /// No description provided for @permissionGroupProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get permissionGroupProducts;

  /// No description provided for @permissionGroupCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get permissionGroupCategories;

  /// No description provided for @permissionGroupInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get permissionGroupInventory;

  /// No description provided for @permissionGroupCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get permissionGroupCustomers;

  /// No description provided for @permissionGroupSalesOrders.
  ///
  /// In en, this message translates to:
  /// **'Sales orders'**
  String get permissionGroupSalesOrders;

  /// No description provided for @permissionGroupAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get permissionGroupAnalytics;

  /// No description provided for @permissionGroupUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get permissionGroupUsers;

  /// No description provided for @permissionGroupRoles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get permissionGroupRoles;

  /// No description provided for @usersTitle.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get usersTitle;

  /// No description provided for @usersAdd.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get usersAdd;

  /// No description provided for @usersSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name or email'**
  String get usersSearchHint;

  /// No description provided for @usersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No users yet.'**
  String get usersEmpty;

  /// No description provided for @usersEmptyForSearch.
  ///
  /// In en, this message translates to:
  /// **'No user matches \"{query}\"'**
  String usersEmptyForSearch(String query);

  /// No description provided for @usersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 user} other{{count} users}}'**
  String usersCount(int count);

  /// No description provided for @userActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get userActive;

  /// No description provided for @userInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get userInactive;

  /// No description provided for @userYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get userYou;

  /// No description provided for @userOutOfScope.
  ///
  /// In en, this message translates to:
  /// **'Beyond your permissions'**
  String get userOutOfScope;

  /// No description provided for @userNew.
  ///
  /// In en, this message translates to:
  /// **'New user'**
  String get userNew;

  /// No description provided for @userEdit.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userEdit;

  /// No description provided for @userFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get userFieldName;

  /// No description provided for @userFieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get userFieldEmail;

  /// No description provided for @userFieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get userFieldPassword;

  /// No description provided for @userFieldNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password (optional)'**
  String get userFieldNewPassword;

  /// No description provided for @userFieldNewPasswordHelper.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to keep the current one. A new password signs the user out on every device.'**
  String get userFieldNewPasswordHelper;

  /// No description provided for @userFieldRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get userFieldRole;

  /// No description provided for @userFieldActive.
  ///
  /// In en, this message translates to:
  /// **'Active account'**
  String get userFieldActive;

  /// No description provided for @userFieldActiveHelper.
  ///
  /// In en, this message translates to:
  /// **'An inactive user can\'t sign in, and their sessions end at once.'**
  String get userFieldActiveHelper;

  /// No description provided for @userRolesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Roles could not be loaded'**
  String get userRolesLoadFailed;

  /// No description provided for @userRolesReload.
  ///
  /// In en, this message translates to:
  /// **'Reload roles'**
  String get userRolesReload;

  /// No description provided for @userSelfDeactivate.
  ///
  /// In en, this message translates to:
  /// **'You can\'t deactivate your own account.'**
  String get userSelfDeactivate;

  /// No description provided for @userSelfRole.
  ///
  /// In en, this message translates to:
  /// **'You can\'t change your own role.'**
  String get userSelfRole;

  /// No description provided for @userSelfDelete.
  ///
  /// In en, this message translates to:
  /// **'You can\'t delete your own account.'**
  String get userSelfDelete;

  /// No description provided for @userCreated.
  ///
  /// In en, this message translates to:
  /// **'User \"{name}\" created'**
  String userCreated(String name);

  /// No description provided for @userUpdated.
  ///
  /// In en, this message translates to:
  /// **'User saved'**
  String get userUpdated;

  /// No description provided for @userSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the user: {message}'**
  String userSaveFailed(String message);

  /// No description provided for @userDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete user?'**
  String get userDeleteConfirmTitle;

  /// No description provided for @userDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'{name} ({email}) will be deleted and signed out on every device.'**
  String userDeleteConfirmBody(String name, String email);

  /// No description provided for @userDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String userDeleted(String name);

  /// No description provided for @userDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the user: {message}'**
  String userDeleteFailed(String message);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
