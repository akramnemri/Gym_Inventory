import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Gym Inventory'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @machines.
  ///
  /// In en, this message translates to:
  /// **'Machines'**
  String get machines;

  /// No description provided for @addMachine.
  ///
  /// In en, this message translates to:
  /// **'Add machine'**
  String get addMachine;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm delete'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get confirmDeleteMessage;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneHelperText.
  ///
  /// In en, this message translates to:
  /// **'8 digits only'**
  String get phoneHelperText;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHelperText.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters, must include letters & numbers'**
  String get passwordHelperText;

  /// No description provided for @adminCodeOptional.
  ///
  /// In en, this message translates to:
  /// **'Admin Code (optional)'**
  String get adminCodeOptional;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone'**
  String get invalidPhone;

  /// No description provided for @passwordTooWeak.
  ///
  /// In en, this message translates to:
  /// **'Password too weak'**
  String get passwordTooWeak;

  /// No description provided for @errorSigningUp.
  ///
  /// In en, this message translates to:
  /// **'Error signing up'**
  String get errorSigningUp;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @loginHere.
  ///
  /// In en, this message translates to:
  /// **'Login here'**
  String get loginHere;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get creating;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username or Email'**
  String get usernameOrEmail;

  /// No description provided for @fieldCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty.'**
  String get fieldCannotBeEmpty;

  /// No description provided for @passwordCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty.'**
  String get passwordCannotBeEmpty;

  /// No description provided for @errorConnectingServer.
  ///
  /// In en, this message translates to:
  /// **'Error connecting to server.'**
  String get errorConnectingServer;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed.'**
  String get loginFailed;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @enterRegisteredEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email'**
  String get enterRegisteredEmail;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @passwordResetInitiated.
  ///
  /// In en, this message translates to:
  /// **'Password reset initiated. Please check your email.'**
  String get passwordResetInitiated;

  /// No description provided for @errorPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Error initiating password reset.'**
  String get errorPasswordReset;

  /// No description provided for @errorSendingResetRequest.
  ///
  /// In en, this message translates to:
  /// **'Error sending reset request. Please try again later.'**
  String get errorSendingResetRequest;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmail;

  /// No description provided for @passwordResetEmailInstructions.
  ///
  /// In en, this message translates to:
  /// **'A reset token has been sent to your registered email. Once you have it, click \'Enter Token\' to reset your password.'**
  String get passwordResetEmailInstructions;

  /// No description provided for @enterToken.
  ///
  /// In en, this message translates to:
  /// **'Enter token'**
  String get enterToken;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @enterTokenAndNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter the token received via email and your new password.'**
  String get enterTokenAndNewPassword;

  /// No description provided for @resetTokenFromEmail.
  ///
  /// In en, this message translates to:
  /// **'Reset token from email'**
  String get resetTokenFromEmail;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters with letters and numbers.'**
  String get passwordRequirements;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get passwordResetSuccess;

  /// No description provided for @passwordResetFailed.
  ///
  /// In en, this message translates to:
  /// **'Password reset failed.'**
  String get passwordResetFailed;

  /// No description provided for @inventoryLogin.
  ///
  /// In en, this message translates to:
  /// **'Inventory Login'**
  String get inventoryLogin;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @signUpHere.
  ///
  /// In en, this message translates to:
  /// **'Sign up here'**
  String get signUpHere;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @productsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh Products'**
  String get productsRefresh;

  /// No description provided for @productsAddNew.
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get productsAddNew;

  /// No description provided for @productsSearchByName.
  ///
  /// In en, this message translates to:
  /// **'Search Products by Name'**
  String get productsSearchByName;

  /// No description provided for @productsEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter product name...'**
  String get productsEnterName;

  /// No description provided for @productsNoProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get productsNoProductsFound;

  /// No description provided for @productsUnexpectedDataFormat.
  ///
  /// In en, this message translates to:
  /// **'Unexpected data format received'**
  String get productsUnexpectedDataFormat;

  /// No description provided for @productsErrorFetching.
  ///
  /// In en, this message translates to:
  /// **'Error fetching products'**
  String get productsErrorFetching;

  /// No description provided for @productsErrorOpeningDetails.
  ///
  /// In en, this message translates to:
  /// **'Error opening product details'**
  String get productsErrorOpeningDetails;

  /// No description provided for @confirmDeleteProductMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this product?'**
  String get confirmDeleteProductMessage;

  /// No description provided for @productsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get productsDeleteSuccess;

  /// No description provided for @productsDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete product'**
  String get productsDeleteFailed;

  /// No description provided for @productsErrorDeleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting product'**
  String get productsErrorDeleting;

  /// No description provided for @productsStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get productsStock;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @productDetailsUnexpectedComponentsFormat.
  ///
  /// In en, this message translates to:
  /// **'Unexpected components format'**
  String get productDetailsUnexpectedComponentsFormat;

  /// No description provided for @productDetailsFailedToLoadComponents.
  ///
  /// In en, this message translates to:
  /// **'Failed to load components'**
  String get productDetailsFailedToLoadComponents;

  /// No description provided for @productDetailsErrorFetchingComponents.
  ///
  /// In en, this message translates to:
  /// **'Error fetching components'**
  String get productDetailsErrorFetchingComponents;

  /// No description provided for @productDetailsUnexpectedProductFormat.
  ///
  /// In en, this message translates to:
  /// **'Unexpected product format'**
  String get productDetailsUnexpectedProductFormat;

  /// No description provided for @productDetailsFailedToLoadProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to load product'**
  String get productDetailsFailedToLoadProduct;

  /// No description provided for @productDetailsErrorFetchingProduct.
  ///
  /// In en, this message translates to:
  /// **'Error fetching product'**
  String get productDetailsErrorFetchingProduct;

  /// No description provided for @productDetailsErrorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking image'**
  String get productDetailsErrorPickingImage;

  /// No description provided for @productDetailsAddRequiredComponent.
  ///
  /// In en, this message translates to:
  /// **'Add Required Component'**
  String get productDetailsAddRequiredComponent;

  /// No description provided for @productDetailsSearchComponentByReference.
  ///
  /// In en, this message translates to:
  /// **'Search Component by Reference'**
  String get productDetailsSearchComponentByReference;

  /// No description provided for @productDetailsEnterReference.
  ///
  /// In en, this message translates to:
  /// **'Enter reference...'**
  String get productDetailsEnterReference;

  /// No description provided for @productDetailsComponent.
  ///
  /// In en, this message translates to:
  /// **'Component'**
  String get productDetailsComponent;

  /// No description provided for @productDetailsUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get productDetailsUnknown;

  /// No description provided for @productDetailsNoRef.
  ///
  /// In en, this message translates to:
  /// **'No Ref'**
  String get productDetailsNoRef;

  /// No description provided for @productDetailsQuantityRequired.
  ///
  /// In en, this message translates to:
  /// **'Quantity Required'**
  String get productDetailsQuantityRequired;

  /// No description provided for @productDetailsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get productDetailsAdd;

  /// No description provided for @productDetailsNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Product name is required'**
  String get productDetailsNameRequired;

  /// No description provided for @productDetailsStockRequired.
  ///
  /// In en, this message translates to:
  /// **'Stock quantity is required'**
  String get productDetailsStockRequired;

  /// No description provided for @productDetailsStockValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Stock must be a valid number'**
  String get productDetailsStockValidNumber;

  /// No description provided for @productDetailsStockCannotBeNegative.
  ///
  /// In en, this message translates to:
  /// **'Stock cannot be negative'**
  String get productDetailsStockCannotBeNegative;

  /// No description provided for @productDetailsCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product created successfully!'**
  String get productDetailsCreateSuccess;

  /// No description provided for @productDetailsUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully!'**
  String get productDetailsUpdateSuccess;

  /// No description provided for @productDetailsUnexpectedResponseFormat.
  ///
  /// In en, this message translates to:
  /// **'Unexpected response format'**
  String get productDetailsUnexpectedResponseFormat;

  /// No description provided for @unknownErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownErrorOccurred;

  /// No description provided for @productDetailsFailedTo.
  ///
  /// In en, this message translates to:
  /// **'Failed to'**
  String get productDetailsFailedTo;

  /// No description provided for @productDetailsProduct.
  ///
  /// In en, this message translates to:
  /// **'product'**
  String get productDetailsProduct;

  /// No description provided for @productDetailsError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get productDetailsError;

  /// No description provided for @productDetailsCreating.
  ///
  /// In en, this message translates to:
  /// **'creating'**
  String get productDetailsCreating;

  /// No description provided for @productDetailsSaving.
  ///
  /// In en, this message translates to:
  /// **'saving'**
  String get productDetailsSaving;

  /// No description provided for @productDetailsConfirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this product? This action cannot be undone.'**
  String get productDetailsConfirmDeleteMessage;

  /// No description provided for @productDetailsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get productDetailsDeleteSuccess;

  /// No description provided for @productDetailsFailedToDeleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete product'**
  String get productDetailsFailedToDeleteProduct;

  /// No description provided for @productDetailsErrorDeletingProduct.
  ///
  /// In en, this message translates to:
  /// **'Error deleting product'**
  String get productDetailsErrorDeletingProduct;

  /// No description provided for @productDetailsProduceSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product produced successfully'**
  String get productDetailsProduceSuccess;

  /// No description provided for @productDetailsFailedToProduce.
  ///
  /// In en, this message translates to:
  /// **'Failed to produce'**
  String get productDetailsFailedToProduce;

  /// No description provided for @productDetailsErrorProducingProduct.
  ///
  /// In en, this message translates to:
  /// **'Error producing product'**
  String get productDetailsErrorProducingProduct;

  /// No description provided for @productDetailsKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get productDetailsKey;

  /// No description provided for @productDetailsValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get productDetailsValue;

  /// No description provided for @productDetailsUnknownComponent.
  ///
  /// In en, this message translates to:
  /// **'Unknown Component'**
  String get productDetailsUnknownComponent;

  /// No description provided for @productDetailsAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get productDetailsAddProduct;

  /// No description provided for @productDetailsDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetailsDetails;

  /// No description provided for @productDetailsChooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose Image'**
  String get productDetailsChooseImage;

  /// No description provided for @productDetailsName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get productDetailsName;

  /// No description provided for @productDetailsEnterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get productDetailsEnterProductName;

  /// No description provided for @productDetailsCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get productDetailsCategory;

  /// No description provided for @productDetailsEnterProductCategory.
  ///
  /// In en, this message translates to:
  /// **'Enter product category'**
  String get productDetailsEnterProductCategory;

  /// No description provided for @productDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDetailsDescription;

  /// No description provided for @productDetailsEnterProductDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter product description'**
  String get productDetailsEnterProductDescription;

  /// No description provided for @productDetailsStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get productDetailsStock;

  /// No description provided for @productDetailsEnterStockQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter stock quantity'**
  String get productDetailsEnterStockQuantity;

  /// No description provided for @productDetailsDecreaseStock.
  ///
  /// In en, this message translates to:
  /// **'Decrease stock'**
  String get productDetailsDecreaseStock;

  /// No description provided for @productDetailsIncreaseStock.
  ///
  /// In en, this message translates to:
  /// **'Increase stock'**
  String get productDetailsIncreaseStock;

  /// No description provided for @productDetailsProduce.
  ///
  /// In en, this message translates to:
  /// **'Produce'**
  String get productDetailsProduce;

  /// No description provided for @productDetailsAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get productDetailsAdditionalInfo;

  /// No description provided for @productDetailsAddInfo.
  ///
  /// In en, this message translates to:
  /// **'Add Info'**
  String get productDetailsAddInfo;

  /// No description provided for @productDetailsRequiredComponents.
  ///
  /// In en, this message translates to:
  /// **'Required Components'**
  String get productDetailsRequiredComponents;

  /// No description provided for @productDetailsAddComponent.
  ///
  /// In en, this message translates to:
  /// **'Add Component'**
  String get productDetailsAddComponent;

  /// No description provided for @productDetailsPleaseSelectComponent.
  ///
  /// In en, this message translates to:
  /// **'Please select a component.'**
  String get productDetailsPleaseSelectComponent;

  /// No description provided for @productDetailsQuantityPositive.
  ///
  /// In en, this message translates to:
  /// **'Quantity required must be a positive number.'**
  String get productDetailsQuantityPositive;

  /// No description provided for @productDetailsNoComponentsFound.
  ///
  /// In en, this message translates to:
  /// **'No components found.'**
  String get productDetailsNoComponentsFound;

  /// No description provided for @productDetailsProductionFailed.
  ///
  /// In en, this message translates to:
  /// **'Production Failed'**
  String get productDetailsProductionFailed;

  /// No description provided for @productDetailsInsufficientStockMessage.
  ///
  /// In en, this message translates to:
  /// **'Cannot produce this product due to insufficient stock of required components:'**
  String get productDetailsInsufficientStockMessage;

  /// No description provided for @productDetailsMissingComponents.
  ///
  /// In en, this message translates to:
  /// **'Missing Components:'**
  String get productDetailsMissingComponents;

  /// No description provided for @productDetailsRequiredQuantity.
  ///
  /// In en, this message translates to:
  /// **'Required: {quantity}'**
  String productDetailsRequiredQuantity(String quantity);

  /// No description provided for @productDetailsAvailableQuantity.
  ///
  /// In en, this message translates to:
  /// **'Available: {quantity}'**
  String productDetailsAvailableQuantity(String quantity);

  /// No description provided for @productDetailsShortage.
  ///
  /// In en, this message translates to:
  /// **'Shortage: {quantity}'**
  String productDetailsShortage(String quantity);

  /// No description provided for @productDetailsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get productDetailsClose;

  /// No description provided for @productDetailsNoStockToSell.
  ///
  /// In en, this message translates to:
  /// **'No stock available to sell'**
  String get productDetailsNoStockToSell;

  /// No description provided for @productDetailsConfirmSell.
  ///
  /// In en, this message translates to:
  /// **'Confirm Sale'**
  String get productDetailsConfirmSell;

  /// No description provided for @productDetailsConfirmSellMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to mark one unit as sold? This will decrease the stock by 1.'**
  String get productDetailsConfirmSellMessage;

  /// No description provided for @productDetailsConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get productDetailsConfirm;

  /// No description provided for @productDetailsSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get productDetailsSell;

  /// No description provided for @productDetailsSellSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product sold successfully'**
  String get productDetailsSellSuccess;

  /// No description provided for @productDetailsFailedToSell.
  ///
  /// In en, this message translates to:
  /// **'Failed to sell product'**
  String get productDetailsFailedToSell;

  /// No description provided for @productDetailsErrorSelling.
  ///
  /// In en, this message translates to:
  /// **'Error selling product'**
  String get productDetailsErrorSelling;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @filterSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or reference...'**
  String get filterSearchHint;

  /// No description provided for @filterAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced Filters'**
  String get filterAdvanced;

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get filterClear;

  /// No description provided for @filterType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get filterType;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get filterReference;

  /// No description provided for @filterReferenceHint.
  ///
  /// In en, this message translates to:
  /// **'Filter by reference...'**
  String get filterReferenceHint;

  /// No description provided for @filterDimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get filterDimensions;

  /// No description provided for @filterDimensionsHint.
  ///
  /// In en, this message translates to:
  /// **'Filter by dimensions...'**
  String get filterDimensionsHint;

  /// No description provided for @filterLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get filterLength;

  /// No description provided for @filterWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get filterWeight;

  /// No description provided for @filterHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get filterHeight;

  /// No description provided for @filterStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get filterStock;

  /// No description provided for @filterMin.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get filterMin;

  /// No description provided for @filterMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get filterMax;

  /// No description provided for @componentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get componentsTitle;

  /// No description provided for @componentsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get componentsRefresh;

  /// No description provided for @componentsAddComponent.
  ///
  /// In en, this message translates to:
  /// **'Add Component'**
  String get componentsAddComponent;

  /// No description provided for @componentsNoComponentsFound.
  ///
  /// In en, this message translates to:
  /// **'No components found'**
  String get componentsNoComponentsFound;

  /// No description provided for @componentsNoMatchingFilters.
  ///
  /// In en, this message translates to:
  /// **'No components match your filters'**
  String get componentsNoMatchingFilters;

  /// No description provided for @componentsUnexpectedDataFormat.
  ///
  /// In en, this message translates to:
  /// **'Unexpected data format received'**
  String get componentsUnexpectedDataFormat;

  /// No description provided for @componentsErrorFetching.
  ///
  /// In en, this message translates to:
  /// **'Error fetching components'**
  String get componentsErrorFetching;

  /// No description provided for @componentsErrorOpeningDetails.
  ///
  /// In en, this message translates to:
  /// **'Error opening component details'**
  String get componentsErrorOpeningDetails;

  /// No description provided for @componentsConfirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get componentsConfirmDeleteTitle;

  /// No description provided for @componentsConfirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this component?'**
  String get componentsConfirmDeleteMessage;

  /// No description provided for @componentsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Component deleted successfully'**
  String get componentsDeleteSuccess;

  /// No description provided for @componentsCreateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Component created successfully'**
  String get componentsCreateSuccess;

  /// No description provided for @componentsUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Component updated successfully'**
  String get componentsUpdateSuccess;

  /// No description provided for @componentsDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete component'**
  String get componentsDeleteFailed;

  /// No description provided for @componentsErrorDeleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting component'**
  String get componentsErrorDeleting;

  /// No description provided for @componentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Component Details'**
  String get componentDetailsTitle;

  /// No description provided for @componentDetailsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Component'**
  String get componentDetailsAdd;

  /// No description provided for @componentDetailsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get componentDetailsRefresh;

  /// No description provided for @componentDetailsChooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose Image'**
  String get componentDetailsChooseImage;

  /// No description provided for @componentDetailsName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get componentDetailsName;

  /// No description provided for @componentDetailsType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get componentDetailsType;

  /// No description provided for @componentDetailsLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get componentDetailsLength;

  /// No description provided for @componentDetailsWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get componentDetailsWeight;

  /// No description provided for @componentDetailsDimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions'**
  String get componentDetailsDimensions;

  /// No description provided for @componentDetailsHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get componentDetailsHeight;

  /// No description provided for @componentDetailsReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get componentDetailsReference;

  /// No description provided for @componentDetailsStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get componentDetailsStock;

  /// No description provided for @componentDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get componentDetailsDescription;

  /// No description provided for @componentDetailsAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get componentDetailsAdditionalInfo;

  /// No description provided for @componentDetailsKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get componentDetailsKey;

  /// No description provided for @componentDetailsValue.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get componentDetailsValue;

  /// No description provided for @componentDetailsAddInfo.
  ///
  /// In en, this message translates to:
  /// **'Add Info'**
  String get componentDetailsAddInfo;

  /// No description provided for @componentDetailsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get componentDetailsSave;

  /// No description provided for @componentDetailsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get componentDetailsDelete;

  /// No description provided for @componentDetailsNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get componentDetailsNameRequired;

  /// No description provided for @componentDetailsTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Type is required'**
  String get componentDetailsTypeRequired;

  /// No description provided for @componentDetailsUnexpectedFormat.
  ///
  /// In en, this message translates to:
  /// **'Unexpected component format'**
  String get componentDetailsUnexpectedFormat;

  /// No description provided for @componentDetailsFailedToLoad.
  ///
  /// In en, this message translates to:
  /// **'Failed to load component'**
  String get componentDetailsFailedToLoad;

  /// No description provided for @componentDetailsErrorFetching.
  ///
  /// In en, this message translates to:
  /// **'Error fetching component'**
  String get componentDetailsErrorFetching;

  /// No description provided for @componentDetailsErrorPicking.
  ///
  /// In en, this message translates to:
  /// **'Error picking image'**
  String get componentDetailsErrorPicking;

  /// No description provided for @componentDetailsCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Component created successfully'**
  String get componentDetailsCreatedSuccess;

  /// No description provided for @componentDetailsUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Component updated successfully'**
  String get componentDetailsUpdatedSuccess;

  /// No description provided for @componentDetailsUnexpectedResponse.
  ///
  /// In en, this message translates to:
  /// **'Unexpected response format'**
  String get componentDetailsUnexpectedResponse;

  /// No description provided for @componentDetailsFailedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save component'**
  String get componentDetailsFailedToSave;

  /// No description provided for @componentDetailsErrorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error saving component'**
  String get componentDetailsErrorSaving;

  /// No description provided for @componentDetailsConfirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get componentDetailsConfirmDeleteTitle;

  /// No description provided for @componentDetailsConfirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this component? This action cannot be undone.'**
  String get componentDetailsConfirmDeleteMessage;

  /// No description provided for @componentDetailsDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Component deleted successfully'**
  String get componentDetailsDeletedSuccess;

  /// No description provided for @componentDetailsFailedToDelete.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete component'**
  String get componentDetailsFailedToDelete;

  /// No description provided for @componentDetailsErrorDeleting.
  ///
  /// In en, this message translates to:
  /// **'Error deleting component'**
  String get componentDetailsErrorDeleting;

  /// No description provided for @componentDetailsUnsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get componentDetailsUnsavedChanges;

  /// No description provided for @componentDetailsUnsavedMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get componentDetailsUnsavedMessage;

  /// No description provided for @componentDetailsStay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get componentDetailsStay;

  /// No description provided for @componentDetailsLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get componentDetailsLeave;

  /// No description provided for @componentDetailsDiameter.
  ///
  /// In en, this message translates to:
  /// **'diameter'**
  String get componentDetailsDiameter;

  /// No description provided for @componentTypePrimeMaterial.
  ///
  /// In en, this message translates to:
  /// **'Prime Material'**
  String get componentTypePrimeMaterial;

  /// No description provided for @componentTypeConsumablePieces.
  ///
  /// In en, this message translates to:
  /// **'Consumable Pieces'**
  String get componentTypeConsumablePieces;

  /// No description provided for @componentTypeStandardPieces.
  ///
  /// In en, this message translates to:
  /// **'Standard Pieces'**
  String get componentTypeStandardPieces;

  /// No description provided for @componentTypeFurniture.
  ///
  /// In en, this message translates to:
  /// **'Furniture'**
  String get componentTypeFurniture;

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

  /// No description provided for @dashboardWelcomeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Welcome Admin'**
  String get dashboardWelcomeAdmin;

  /// No description provided for @dashboardWelcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome User'**
  String get dashboardWelcomeUser;

  /// No description provided for @dashboardWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Here\'s a quick overview of your system. Review alerts, monitor stock movements, and check session activity—all in one place.'**
  String get dashboardWelcomeMessage;

  /// No description provided for @dashboardGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get dashboardGotIt;

  /// No description provided for @dashboardLowStockAlerts.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alerts'**
  String get dashboardLowStockAlerts;

  /// No description provided for @dashboardAllStocksHealthy.
  ///
  /// In en, this message translates to:
  /// **'All stocks are healthy'**
  String get dashboardAllStocksHealthy;

  /// No description provided for @dashboardSessionLogs.
  ///
  /// In en, this message translates to:
  /// **'Session Logs'**
  String get dashboardSessionLogs;

  /// No description provided for @dashboardNoSessionLogs.
  ///
  /// In en, this message translates to:
  /// **'No session logs'**
  String get dashboardNoSessionLogs;

  /// No description provided for @dashboardRecentStockMovements.
  ///
  /// In en, this message translates to:
  /// **'Recent Stock Movements'**
  String get dashboardRecentStockMovements;

  /// No description provided for @dashboardNoStockMovements.
  ///
  /// In en, this message translates to:
  /// **'No stock movements'**
  String get dashboardNoStockMovements;

  /// No description provided for @dashboardStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get dashboardStock;

  /// No description provided for @dashboardUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get dashboardUnknown;

  /// No description provided for @dashboardComponent.
  ///
  /// In en, this message translates to:
  /// **'Component'**
  String get dashboardComponent;

  /// No description provided for @dashboardProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get dashboardProduct;

  /// No description provided for @dashboardQuantityChange.
  ///
  /// In en, this message translates to:
  /// **'Quantity Change'**
  String get dashboardQuantityChange;

  /// No description provided for @dashboardTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get dashboardTime;

  /// No description provided for @dashboardActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get dashboardActivity;

  /// No description provided for @dashboardActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get dashboardActive;

  /// No description provided for @dashboardInvalidDate.
  ///
  /// In en, this message translates to:
  /// **'Invalid date'**
  String get dashboardInvalidDate;

  /// No description provided for @dashboardLoginDate.
  ///
  /// In en, this message translates to:
  /// **'Login date'**
  String get dashboardLoginDate;

  /// No description provided for @dashboardUserID.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get dashboardUserID;

  /// No description provided for @dashboardComponents.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get dashboardComponents;

  /// No description provided for @dashboardProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get dashboardProducts;

  /// No description provided for @dashboardAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get dashboardAccount;

  /// No description provided for @dashboardLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dashboardLogout;

  /// No description provided for @dashboardAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get dashboardAdmin;

  /// No description provided for @dashboardUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get dashboardUser;

  /// No description provided for @sessionLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Logs'**
  String get sessionLogsTitle;

  /// No description provided for @sessionLogsNoLogs.
  ///
  /// In en, this message translates to:
  /// **'No session logs available'**
  String get sessionLogsNoLogs;

  /// No description provided for @sessionLogsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading session logs'**
  String get sessionLogsErrorLoading;

  /// No description provided for @sessionLogsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get sessionLogsRefresh;

  /// No description provided for @lowStockTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alerts'**
  String get lowStockTitle;

  /// No description provided for @lowStockNoAlerts.
  ///
  /// In en, this message translates to:
  /// **'All stocks are healthy'**
  String get lowStockNoAlerts;

  /// No description provided for @lowStockErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading low stock data'**
  String get lowStockErrorLoading;

  /// No description provided for @lowStockRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get lowStockRefresh;

  /// No description provided for @lowStockThreshold.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Threshold'**
  String get lowStockThreshold;

  /// No description provided for @lowStockCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical Stock Level'**
  String get lowStockCritical;

  /// No description provided for @stockMovementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock Movements'**
  String get stockMovementsTitle;

  /// No description provided for @stockMovementsSideMenu.
  ///
  /// In en, this message translates to:
  /// **'Stock Movements'**
  String get stockMovementsSideMenu;

  /// No description provided for @stockMovementsRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get stockMovementsRefreshTooltip;

  /// No description provided for @stockMovementsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name or ID...'**
  String get stockMovementsSearchHint;

  /// No description provided for @stockMovementsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get stockMovementsFilterAll;

  /// No description provided for @stockMovementsFilterComponents.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get stockMovementsFilterComponents;

  /// No description provided for @stockMovementsFilterProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get stockMovementsFilterProducts;

  /// No description provided for @stockMovementsFilterIncreases.
  ///
  /// In en, this message translates to:
  /// **'Increases'**
  String get stockMovementsFilterIncreases;

  /// No description provided for @stockMovementsFilterDecreases.
  ///
  /// In en, this message translates to:
  /// **'Decreases'**
  String get stockMovementsFilterDecreases;

  /// Label for a component card showing its ID
  ///
  /// In en, this message translates to:
  /// **'Component: {id}'**
  String stockMovementsCardComponentLabel(String id);

  /// Label for a product card showing its ID
  ///
  /// In en, this message translates to:
  /// **'Product: {id}'**
  String stockMovementsCardProductLabel(String id);

  /// No description provided for @stockMovementsErrorUnexpectedFormat.
  ///
  /// In en, this message translates to:
  /// **'Unexpected format received for stock movements.'**
  String get stockMovementsErrorUnexpectedFormat;

  /// Error message when the server returns a non-200 status code.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch stock movements. Status code: {statusCode}'**
  String stockMovementsErrorFetchFailed(int statusCode);

  /// No description provided for @stockMovementsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while loading stock movements.'**
  String get stockMovementsErrorLoading;

  /// No description provided for @stockMovementsNoResults.
  ///
  /// In en, this message translates to:
  /// **'No stock movements found.'**
  String get stockMovementsNoResults;

  /// No description provided for @dashboardSystemOverview.
  ///
  /// In en, this message translates to:
  /// **'System Overview'**
  String get dashboardSystemOverview;

  /// No description provided for @dashboardLowStockAlertsTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alerts'**
  String get dashboardLowStockAlertsTitle;

  /// No description provided for @dashboardItemsNeedAttention.
  ///
  /// In en, this message translates to:
  /// **'Items need attention'**
  String get dashboardItemsNeedAttention;

  /// No description provided for @dashboardActiveSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get dashboardActiveSessionsTitle;

  /// No description provided for @dashboardUsersOnlineNow.
  ///
  /// In en, this message translates to:
  /// **'Users online now'**
  String get dashboardUsersOnlineNow;

  /// No description provided for @dashboardTotalComponentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Components'**
  String get dashboardTotalComponentsTitle;

  /// No description provided for @dashboardInInventory.
  ///
  /// In en, this message translates to:
  /// **'In inventory'**
  String get dashboardInInventory;

  /// No description provided for @dashboardTotalProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get dashboardTotalProductsTitle;

  /// No description provided for @dashboardAvailableProducts.
  ///
  /// In en, this message translates to:
  /// **'Available products'**
  String get dashboardAvailableProducts;

  /// No description provided for @dashboardStockMovementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock Movements'**
  String get dashboardStockMovementsTitle;

  /// No description provided for @dashboardToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dashboardToday;

  /// No description provided for @dashboardSystemStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'System Status'**
  String get dashboardSystemStatusTitle;

  /// No description provided for @dashboardOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get dashboardOnline;

  /// No description provided for @dashboardAllServicesRunning.
  ///
  /// In en, this message translates to:
  /// **'All services running'**
  String get dashboardAllServicesRunning;

  /// No description provided for @dashboardAnalyticsInsights.
  ///
  /// In en, this message translates to:
  /// **'Analytics & Insights'**
  String get dashboardAnalyticsInsights;

  /// No description provided for @dashboardComponentsByType.
  ///
  /// In en, this message translates to:
  /// **'Components by Type'**
  String get dashboardComponentsByType;

  /// No description provided for @dashboardNoComponentData.
  ///
  /// In en, this message translates to:
  /// **'No component data available'**
  String get dashboardNoComponentData;

  /// No description provided for @dashboardTopActiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Top Active Users'**
  String get dashboardTopActiveUsers;

  /// No description provided for @dashboardLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get dashboardLast30Days;

  /// No description provided for @dashboardNoUserActivityData.
  ///
  /// In en, this message translates to:
  /// **'No user activity data available'**
  String get dashboardNoUserActivityData;

  /// No description provided for @dashboardSessions.
  ///
  /// In en, this message translates to:
  /// **'sessions'**
  String get dashboardSessions;

  /// No description provided for @dashboardMinAvg.
  ///
  /// In en, this message translates to:
  /// **'min avg'**
  String get dashboardMinAvg;

  /// No description provided for @dashboardProductionInsights.
  ///
  /// In en, this message translates to:
  /// **'Production Insights'**
  String get dashboardProductionInsights;

  /// No description provided for @dashboardAllTimeChampion.
  ///
  /// In en, this message translates to:
  /// **'All-Time Champion'**
  String get dashboardAllTimeChampion;

  /// No description provided for @dashboardUnitsProduced.
  ///
  /// In en, this message translates to:
  /// **'units produced'**
  String get dashboardUnitsProduced;

  /// No description provided for @dashboardRecentProductionMonth.
  ///
  /// In en, this message translates to:
  /// **'Recent Production (This Month)'**
  String get dashboardRecentProductionMonth;

  /// No description provided for @dashboardWelcomeToDashboard.
  ///
  /// In en, this message translates to:
  /// **'Welcome to your Dashboard'**
  String get dashboardWelcomeToDashboard;

  /// No description provided for @dashboardManageInventory.
  ///
  /// In en, this message translates to:
  /// **'Manage your inventory efficiently'**
  String get dashboardManageInventory;

  /// No description provided for @dashboardNavigationHelp.
  ///
  /// In en, this message translates to:
  /// **'Use the navigation menu to access different sections of your inventory management system. The overview cards above provide quick access to key areas and real-time statistics about your system.'**
  String get dashboardNavigationHelp;

  /// No description provided for @dashboardItems.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get dashboardItems;

  /// No description provided for @accountSettingsChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get accountSettingsChangePassword;

  /// No description provided for @accountSettingsCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get accountSettingsCurrentPassword;

  /// No description provided for @accountSettingsNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get accountSettingsNewPassword;

  /// No description provided for @accountSettingsConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get accountSettingsConfirmPassword;

  /// No description provided for @accountSettingsCurrentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get accountSettingsCurrentPasswordRequired;

  /// No description provided for @accountSettingsNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get accountSettingsNewPasswordRequired;

  /// No description provided for @accountSettingsPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get accountSettingsPasswordsDoNotMatch;

  /// No description provided for @accountSettingsWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters with letters and numbers'**
  String get accountSettingsWeakPassword;

  /// No description provided for @accountSettingsRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get accountSettingsRequired;

  /// No description provided for @accountSettingsInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone must be 8 digits'**
  String get accountSettingsInvalidPhone;

  /// No description provided for @accountSettingsUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get accountSettingsUpdateTitle;

  /// No description provided for @accountSettingsUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account updated successfully'**
  String get accountSettingsUpdateSuccess;

  /// No description provided for @accountSettingsUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update account'**
  String get accountSettingsUpdateFailed;

  /// No description provided for @accountSettingsUnexpectedFormat.
  ///
  /// In en, this message translates to:
  /// **'Unexpected data format'**
  String get accountSettingsUnexpectedFormat;

  /// No description provided for @accountSettingsFailedToFetch.
  ///
  /// In en, this message translates to:
  /// **'Failed to fetch user info'**
  String get accountSettingsFailedToFetch;

  /// No description provided for @accountSettingsErrorFetching.
  ///
  /// In en, this message translates to:
  /// **'Error fetching user info'**
  String get accountSettingsErrorFetching;

  /// No description provided for @accountSettingsErrorUpdating.
  ///
  /// In en, this message translates to:
  /// **'Error updating account'**
  String get accountSettingsErrorUpdating;

  /// No description provided for @accountSettingsErrorPickingImage.
  ///
  /// In en, this message translates to:
  /// **'Error picking profile image'**
  String get accountSettingsErrorPickingImage;
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
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
