// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Gym Inventory';

  @override
  String get welcome => 'Welcome';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get inventory => 'Inventory';

  @override
  String get machines => 'Machines';

  @override
  String get addMachine => 'Add machine';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get search => 'Search';

  @override
  String get noData => 'No data available';

  @override
  String get confirmDeleteTitle => 'Confirm delete';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this item?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get username => 'Username';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone';

  @override
  String get phoneHelperText => '8 digits only';

  @override
  String get password => 'Password';

  @override
  String get passwordHelperText =>
      'Minimum 8 characters, must include letters & numbers';

  @override
  String get adminCodeOptional => 'Admin Code (optional)';

  @override
  String get requiredField => 'Required';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get invalidPhone => 'Invalid phone';

  @override
  String get passwordTooWeak => 'Password too weak';

  @override
  String get errorSigningUp => 'Error signing up';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get loginHere => 'Login here';

  @override
  String get ok => 'OK';

  @override
  String get creating => 'Creating...';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get theme => 'Theme';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get usernameOrEmail => 'Username or Email';

  @override
  String get fieldCannotBeEmpty => 'This field cannot be empty.';

  @override
  String get passwordCannotBeEmpty => 'Password cannot be empty.';

  @override
  String get errorConnectingServer => 'Error connecting to server.';

  @override
  String get loginFailed => 'Login failed.';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get enterRegisteredEmail => 'Enter your registered email';

  @override
  String get send => 'Send';

  @override
  String get passwordResetInitiated =>
      'Password reset initiated. Please check your email.';

  @override
  String get errorPasswordReset => 'Error initiating password reset.';

  @override
  String get errorSendingResetRequest =>
      'Error sending reset request. Please try again later.';

  @override
  String get checkYourEmail => 'Check your email';

  @override
  String get passwordResetEmailInstructions =>
      'A reset token has been sent to your registered email. Once you have it, click \'Enter Token\' to reset your password.';

  @override
  String get enterToken => 'Enter token';

  @override
  String get close => 'Close';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get enterTokenAndNewPassword =>
      'Please enter the token received via email and your new password.';

  @override
  String get resetTokenFromEmail => 'Reset token from email';

  @override
  String get newPassword => 'New password';

  @override
  String get passwordRequirements =>
      'Password must be at least 8 characters with letters and numbers.';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match.';

  @override
  String get passwordResetSuccess => 'Password reset successfully!';

  @override
  String get passwordResetFailed => 'Password reset failed.';

  @override
  String get inventoryLogin => 'Inventory Login';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get signUpHere => 'Sign up here';

  @override
  String get products => 'Products';

  @override
  String get productsRefresh => 'Refresh Products';

  @override
  String get productsAddNew => 'Add New Product';

  @override
  String get productsSearchByName => 'Search Products by Name';

  @override
  String get productsEnterName => 'Enter product name...';

  @override
  String get productsNoProductsFound => 'No products found';

  @override
  String get productsUnexpectedDataFormat => 'Unexpected data format received';

  @override
  String get productsErrorFetching => 'Error fetching products';

  @override
  String get productsErrorOpeningDetails => 'Error opening product details';

  @override
  String get confirmDeleteProductMessage =>
      'Are you sure you want to delete this product?';

  @override
  String get productsDeleteSuccess => 'Product deleted successfully';

  @override
  String get productsDeleteFailed => 'Failed to delete product';

  @override
  String get productsErrorDeleting => 'Error deleting product';

  @override
  String get productsStock => 'Stock';

  @override
  String get details => 'Details';

  @override
  String get productDetailsUnexpectedComponentsFormat =>
      'Unexpected components format';

  @override
  String get productDetailsFailedToLoadComponents =>
      'Failed to load components';

  @override
  String get productDetailsErrorFetchingComponents =>
      'Error fetching components';

  @override
  String get productDetailsUnexpectedProductFormat =>
      'Unexpected product format';

  @override
  String get productDetailsFailedToLoadProduct => 'Failed to load product';

  @override
  String get productDetailsErrorFetchingProduct => 'Error fetching product';

  @override
  String get productDetailsErrorPickingImage => 'Error picking image';

  @override
  String get productDetailsAddRequiredComponent => 'Add Required Component';

  @override
  String get productDetailsSearchComponentByReference =>
      'Search Component by Reference';

  @override
  String get productDetailsEnterReference => 'Enter reference...';

  @override
  String get productDetailsComponent => 'Component';

  @override
  String get productDetailsUnknown => 'Unknown';

  @override
  String get productDetailsNoRef => 'No Ref';

  @override
  String get productDetailsQuantityRequired => 'Quantity Required';

  @override
  String get productDetailsAdd => 'Add';

  @override
  String get productDetailsNameRequired => 'Product name is required';

  @override
  String get productDetailsStockRequired => 'Stock quantity is required';

  @override
  String get productDetailsStockValidNumber => 'Stock must be a valid number';

  @override
  String get productDetailsStockCannotBeNegative => 'Stock cannot be negative';

  @override
  String get productDetailsCreateSuccess => 'Product created successfully!';

  @override
  String get productDetailsUpdateSuccess => 'Product updated successfully!';

  @override
  String get productDetailsUnexpectedResponseFormat =>
      'Unexpected response format';

  @override
  String get unknownErrorOccurred => 'Unknown error occurred';

  @override
  String get productDetailsFailedTo => 'Failed to';

  @override
  String get productDetailsProduct => 'product';

  @override
  String get productDetailsError => 'Error';

  @override
  String get productDetailsCreating => 'creating';

  @override
  String get productDetailsSaving => 'saving';

  @override
  String get productDetailsConfirmDeleteMessage =>
      'Are you sure you want to delete this product? This action cannot be undone.';

  @override
  String get productDetailsDeleteSuccess => 'Product deleted successfully';

  @override
  String get productDetailsFailedToDeleteProduct => 'Failed to delete product';

  @override
  String get productDetailsErrorDeletingProduct => 'Error deleting product';

  @override
  String get productDetailsProduceSuccess => 'Product produced successfully';

  @override
  String get productDetailsFailedToProduce => 'Failed to produce';

  @override
  String get productDetailsErrorProducingProduct => 'Error producing product';

  @override
  String get productDetailsKey => 'Key';

  @override
  String get productDetailsValue => 'Value';

  @override
  String get productDetailsUnknownComponent => 'Unknown Component';

  @override
  String get productDetailsAddProduct => 'Add Product';

  @override
  String get productDetailsDetails => 'Product Details';

  @override
  String get productDetailsChooseImage => 'Choose Image';

  @override
  String get productDetailsName => 'Name';

  @override
  String get productDetailsEnterProductName => 'Enter product name';

  @override
  String get productDetailsCategory => 'Category';

  @override
  String get productDetailsEnterProductCategory => 'Enter product category';

  @override
  String get productDetailsDescription => 'Description';

  @override
  String get productDetailsEnterProductDescription =>
      'Enter product description';

  @override
  String get productDetailsStock => 'Stock';

  @override
  String get productDetailsEnterStockQuantity => 'Enter stock quantity';

  @override
  String get productDetailsDecreaseStock => 'Decrease stock';

  @override
  String get productDetailsIncreaseStock => 'Increase stock';

  @override
  String get productDetailsProduce => 'Produce';

  @override
  String get productDetailsAdditionalInfo => 'Additional Info';

  @override
  String get productDetailsAddInfo => 'Add Info';

  @override
  String get productDetailsRequiredComponents => 'Required Components';

  @override
  String get productDetailsAddComponent => 'Add Component';

  @override
  String get productDetailsPleaseSelectComponent =>
      'Please select a component.';

  @override
  String get productDetailsQuantityPositive =>
      'Quantity required must be a positive number.';

  @override
  String get productDetailsNoComponentsFound => 'No components found.';

  @override
  String get productDetailsProductionFailed => 'Production Failed';

  @override
  String get productDetailsInsufficientStockMessage =>
      'Cannot produce this product due to insufficient stock of required components:';

  @override
  String get productDetailsMissingComponents => 'Missing Components:';

  @override
  String productDetailsRequiredQuantity(String quantity) {
    return 'Required: $quantity';
  }

  @override
  String productDetailsAvailableQuantity(String quantity) {
    return 'Available: $quantity';
  }

  @override
  String productDetailsShortage(String quantity) {
    return 'Shortage: $quantity';
  }

  @override
  String get productDetailsClose => 'Close';

  @override
  String get productDetailsNoStockToSell => 'No stock available to sell';

  @override
  String get productDetailsConfirmSell => 'Confirm Sale';

  @override
  String get productDetailsConfirmSellMessage =>
      'Are you sure you want to mark one unit as sold? This will decrease the stock by 1.';

  @override
  String get productDetailsConfirm => 'Confirm';

  @override
  String get productDetailsSell => 'Sell';

  @override
  String get productDetailsSellSuccess => 'Product sold successfully';

  @override
  String get productDetailsFailedToSell => 'Failed to sell product';

  @override
  String get productDetailsErrorSelling => 'Error selling product';

  @override
  String get create => 'Create';

  @override
  String get filterSearchHint => 'Search by name or reference...';

  @override
  String get filterAdvanced => 'Advanced Filters';

  @override
  String get filterClear => 'Clear Filters';

  @override
  String get filterType => 'Type';

  @override
  String get filterAll => 'All';

  @override
  String get filterReference => 'Reference';

  @override
  String get filterReferenceHint => 'Filter by reference...';

  @override
  String get filterDimensions => 'Dimensions';

  @override
  String get filterDimensionsHint => 'Filter by dimensions...';

  @override
  String get filterLength => 'Length';

  @override
  String get filterWeight => 'Weight';

  @override
  String get filterHeight => 'Height';

  @override
  String get filterStock => 'Stock';

  @override
  String get filterMin => 'Min';

  @override
  String get filterMax => 'Max';

  @override
  String get componentsTitle => 'Components';

  @override
  String get componentsRefresh => 'Refresh';

  @override
  String get componentsAddComponent => 'Add Component';

  @override
  String get componentsNoComponentsFound => 'No components found';

  @override
  String get componentsNoMatchingFilters => 'No components match your filters';

  @override
  String get componentsUnexpectedDataFormat =>
      'Unexpected data format received';

  @override
  String get componentsErrorFetching => 'Error fetching components';

  @override
  String get componentsErrorOpeningDetails => 'Error opening component details';

  @override
  String get componentsConfirmDeleteTitle => 'Confirm Delete';

  @override
  String get componentsConfirmDeleteMessage =>
      'Are you sure you want to delete this component?';

  @override
  String get componentsDeleteSuccess => 'Component deleted successfully';

  @override
  String get componentsCreateSuccess => 'Component created successfully';

  @override
  String get componentsUpdateSuccess => 'Component updated successfully';

  @override
  String get componentsDeleteFailed => 'Failed to delete component';

  @override
  String get componentsErrorDeleting => 'Error deleting component';

  @override
  String get componentDetailsTitle => 'Component Details';

  @override
  String get componentDetailsAdd => 'Add Component';

  @override
  String get componentDetailsRefresh => 'Refresh';

  @override
  String get componentDetailsChooseImage => 'Choose Image';

  @override
  String get componentDetailsName => 'Name';

  @override
  String get componentDetailsType => 'Type';

  @override
  String get componentDetailsLength => 'Length';

  @override
  String get componentDetailsWeight => 'Weight';

  @override
  String get componentDetailsDimensions => 'Dimensions';

  @override
  String get componentDetailsHeight => 'Height';

  @override
  String get componentDetailsReference => 'Reference';

  @override
  String get componentDetailsStock => 'Stock';

  @override
  String get componentDetailsDescription => 'Description';

  @override
  String get componentDetailsAdditionalInfo => 'Additional Info';

  @override
  String get componentDetailsKey => 'Key';

  @override
  String get componentDetailsValue => 'Value';

  @override
  String get componentDetailsAddInfo => 'Add Info';

  @override
  String get componentDetailsSave => 'Save';

  @override
  String get componentDetailsDelete => 'Delete';

  @override
  String get componentDetailsNameRequired => 'Name is required';

  @override
  String get componentDetailsTypeRequired => 'Type is required';

  @override
  String get componentDetailsUnexpectedFormat => 'Unexpected component format';

  @override
  String get componentDetailsFailedToLoad => 'Failed to load component';

  @override
  String get componentDetailsErrorFetching => 'Error fetching component';

  @override
  String get componentDetailsErrorPicking => 'Error picking image';

  @override
  String get componentDetailsCreatedSuccess => 'Component created successfully';

  @override
  String get componentDetailsUpdatedSuccess => 'Component updated successfully';

  @override
  String get componentDetailsUnexpectedResponse => 'Unexpected response format';

  @override
  String get componentDetailsFailedToSave => 'Failed to save component';

  @override
  String get componentDetailsErrorSaving => 'Error saving component';

  @override
  String get componentDetailsConfirmDeleteTitle => 'Confirm Delete';

  @override
  String get componentDetailsConfirmDeleteMessage =>
      'Are you sure you want to delete this component? This action cannot be undone.';

  @override
  String get componentDetailsDeletedSuccess => 'Component deleted successfully';

  @override
  String get componentDetailsFailedToDelete => 'Failed to delete component';

  @override
  String get componentDetailsErrorDeleting => 'Error deleting component';

  @override
  String get componentDetailsUnsavedChanges => 'Unsaved Changes';

  @override
  String get componentDetailsUnsavedMessage =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get componentDetailsStay => 'Stay';

  @override
  String get componentDetailsLeave => 'Leave';

  @override
  String get componentDetailsDiameter => 'diameter';

  @override
  String get componentTypePrimeMaterial => 'Prime Material';

  @override
  String get componentTypeConsumablePieces => 'Consumable Pieces';

  @override
  String get componentTypeStandardPieces => 'Standard Pieces';

  @override
  String get componentTypeFurniture => 'Furniture';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardRefresh => 'Refresh';

  @override
  String get dashboardWelcomeAdmin => 'Welcome Admin';

  @override
  String get dashboardWelcomeUser => 'Welcome User';

  @override
  String get dashboardWelcomeMessage =>
      'Here\'s a quick overview of your system. Review alerts, monitor stock movements, and check session activity—all in one place.';

  @override
  String get dashboardGotIt => 'Got it';

  @override
  String get dashboardLowStockAlerts => 'Low Stock Alerts';

  @override
  String get dashboardAllStocksHealthy => 'All stocks are healthy';

  @override
  String get dashboardSessionLogs => 'Session Logs';

  @override
  String get dashboardNoSessionLogs => 'No session logs';

  @override
  String get dashboardRecentStockMovements => 'Recent Stock Movements';

  @override
  String get dashboardNoStockMovements => 'No stock movements';

  @override
  String get dashboardStock => 'Stock';

  @override
  String get dashboardUnknown => 'Unknown';

  @override
  String get dashboardComponent => 'Component';

  @override
  String get dashboardProduct => 'Product';

  @override
  String get dashboardQuantityChange => 'Quantity Change';

  @override
  String get dashboardTime => 'Time';

  @override
  String get dashboardActivity => 'Activity';

  @override
  String get dashboardActive => 'Active';

  @override
  String get dashboardInvalidDate => 'Invalid date';

  @override
  String get dashboardLoginDate => 'Login date';

  @override
  String get dashboardUserID => 'User ID';

  @override
  String get dashboardComponents => 'Components';

  @override
  String get dashboardProducts => 'Products';

  @override
  String get dashboardAccount => 'Account';

  @override
  String get dashboardLogout => 'Logout';

  @override
  String get dashboardAdmin => 'Admin';

  @override
  String get dashboardUser => 'User';

  @override
  String get sessionLogsTitle => 'Session Logs';

  @override
  String get sessionLogsNoLogs => 'No session logs available';

  @override
  String get sessionLogsErrorLoading => 'Error loading session logs';

  @override
  String get sessionLogsRefresh => 'Refresh';

  @override
  String get lowStockTitle => 'Low Stock Alerts';

  @override
  String get lowStockNoAlerts => 'All stocks are healthy';

  @override
  String get lowStockErrorLoading => 'Error loading low stock data';

  @override
  String get lowStockRefresh => 'Refresh';

  @override
  String get lowStockThreshold => 'Low Stock Threshold';

  @override
  String get lowStockCritical => 'Critical Stock Level';

  @override
  String get stockMovementsTitle => 'Stock Movements';

  @override
  String get stockMovementsSideMenu => 'Stock Movements';

  @override
  String get stockMovementsRefreshTooltip => 'Refresh';

  @override
  String get stockMovementsSearchHint => 'Search by name or ID...';

  @override
  String get stockMovementsFilterAll => 'All';

  @override
  String get stockMovementsFilterComponents => 'Components';

  @override
  String get stockMovementsFilterProducts => 'Products';

  @override
  String get stockMovementsFilterIncreases => 'Increases';

  @override
  String get stockMovementsFilterDecreases => 'Decreases';

  @override
  String stockMovementsCardComponentLabel(String id) {
    return 'Component: $id';
  }

  @override
  String stockMovementsCardProductLabel(String id) {
    return 'Product: $id';
  }

  @override
  String get stockMovementsErrorUnexpectedFormat =>
      'Unexpected format received for stock movements.';

  @override
  String stockMovementsErrorFetchFailed(int statusCode) {
    return 'Failed to fetch stock movements. Status code: $statusCode';
  }

  @override
  String get stockMovementsErrorLoading =>
      'An error occurred while loading stock movements.';

  @override
  String get stockMovementsNoResults => 'No stock movements found.';

  @override
  String get dashboardSystemOverview => 'System Overview';

  @override
  String get dashboardLowStockAlertsTitle => 'Low Stock Alerts';

  @override
  String get dashboardItemsNeedAttention => 'Items need attention';

  @override
  String get dashboardActiveSessionsTitle => 'Active Sessions';

  @override
  String get dashboardUsersOnlineNow => 'Users online now';

  @override
  String get dashboardTotalComponentsTitle => 'Total Components';

  @override
  String get dashboardInInventory => 'In inventory';

  @override
  String get dashboardTotalProductsTitle => 'Total Products';

  @override
  String get dashboardAvailableProducts => 'Available products';

  @override
  String get dashboardStockMovementsTitle => 'Stock Movements';

  @override
  String get dashboardToday => 'Today';

  @override
  String get dashboardSystemStatusTitle => 'System Status';

  @override
  String get dashboardOnline => 'Online';

  @override
  String get dashboardAllServicesRunning => 'All services running';

  @override
  String get dashboardAnalyticsInsights => 'Analytics & Insights';

  @override
  String get dashboardComponentsByType => 'Components by Type';

  @override
  String get dashboardNoComponentData => 'No component data available';

  @override
  String get dashboardTopActiveUsers => 'Top Active Users';

  @override
  String get dashboardLast30Days => 'Last 30 Days';

  @override
  String get dashboardNoUserActivityData => 'No user activity data available';

  @override
  String get dashboardSessions => 'sessions';

  @override
  String get dashboardMinAvg => 'min avg';

  @override
  String get dashboardProductionInsights => 'Production Insights';

  @override
  String get dashboardAllTimeChampion => 'All-Time Champion';

  @override
  String get dashboardUnitsProduced => 'units produced';

  @override
  String get dashboardRecentProductionMonth => 'Recent Production (This Month)';

  @override
  String get dashboardWelcomeToDashboard => 'Welcome to your Dashboard';

  @override
  String get dashboardManageInventory => 'Manage your inventory efficiently';

  @override
  String get dashboardNavigationHelp =>
      'Use the navigation menu to access different sections of your inventory management system. The overview cards above provide quick access to key areas and real-time statistics about your system.';

  @override
  String get dashboardItems => 'items';

  @override
  String get accountSettingsChangePassword => 'Change Password';

  @override
  String get accountSettingsCurrentPassword => 'Current Password';

  @override
  String get accountSettingsNewPassword => 'New Password';

  @override
  String get accountSettingsConfirmPassword => 'Confirm New Password';

  @override
  String get accountSettingsCurrentPasswordRequired =>
      'Current password is required';

  @override
  String get accountSettingsNewPasswordRequired => 'New password is required';

  @override
  String get accountSettingsPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get accountSettingsWeakPassword =>
      'Password must be at least 8 characters with letters and numbers';

  @override
  String get accountSettingsRequired => 'Required';

  @override
  String get accountSettingsInvalidPhone => 'Phone must be 8 digits';

  @override
  String get accountSettingsUpdateTitle => 'Update';

  @override
  String get accountSettingsUpdateSuccess => 'Account updated successfully';

  @override
  String get accountSettingsUpdateFailed => 'Failed to update account';

  @override
  String get accountSettingsUnexpectedFormat => 'Unexpected data format';

  @override
  String get accountSettingsFailedToFetch => 'Failed to fetch user info';

  @override
  String get accountSettingsErrorFetching => 'Error fetching user info';

  @override
  String get accountSettingsErrorUpdating => 'Error updating account';

  @override
  String get accountSettingsErrorPickingImage => 'Error picking profile image';
}
