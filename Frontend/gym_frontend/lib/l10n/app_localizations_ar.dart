// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'جرد الصالة الرياضية';

  @override
  String get welcome => 'مرحباً';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get inventory => 'المخزون';

  @override
  String get machines => 'الآلات';

  @override
  String get addMachine => 'إضافة آلة';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get search => 'بحث';

  @override
  String get noData => 'لا توجد بيانات متاحة';

  @override
  String get confirmDeleteTitle => 'تأكيد الحذف';

  @override
  String get confirmDeleteMessage => 'هل أنت متأكد أنك تريد حذف هذا العنصر؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get phone => 'الهاتف';

  @override
  String get phoneHelperText => '8 أرقام فقط';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHelperText =>
      '8 أحرف على الأقل، يجب أن تتضمن أحرفًا وأرقامًا';

  @override
  String get adminCodeOptional => 'رمز المسؤول (اختياري)';

  @override
  String get requiredField => 'مطلوب';

  @override
  String get invalidEmail => 'بريد إلكتروني غير صالح';

  @override
  String get invalidPhone => 'رقم هاتف غير صالح';

  @override
  String get passwordTooWeak => 'كلمة المرور ضعيفة جداً';

  @override
  String get errorSigningUp => 'خطأ أثناء التسجيل';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get loginHere => 'سجل الدخول هنا';

  @override
  String get ok => 'موافق';

  @override
  String get creating => 'جاري الإنشاء...';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get theme => 'السمة';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get usernameOrEmail => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get fieldCannotBeEmpty => 'لا يمكن ترك هذا الحقل فارغاً.';

  @override
  String get passwordCannotBeEmpty => 'لا يمكن ترك كلمة المرور فارغة.';

  @override
  String get errorConnectingServer => 'خطأ في الاتصال بالخادم.';

  @override
  String get loginFailed => 'فشل تسجيل الدخول.';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get enterRegisteredEmail => 'أدخل بريدك الإلكتروني المسجل';

  @override
  String get send => 'إرسال';

  @override
  String get passwordResetInitiated =>
      'تم بدء إعادة تعيين كلمة المرور. يرجى التحقق من بريدك الإلكتروني.';

  @override
  String get errorPasswordReset => 'خطأ في بدء إعادة تعيين كلمة المرور.';

  @override
  String get errorSendingResetRequest =>
      'خطأ في إرسال طلب إعادة التعيين. يرجى المحاولة مرة أخرى لاحقاً.';

  @override
  String get checkYourEmail => 'تحقق من بريدك الإلكتروني';

  @override
  String get passwordResetEmailInstructions =>
      'تم إرسال رمز إعادة تعيين إلى بريدك الإلكتروني المسجل. بمجرد استلامه، انقر على \'أدخل الرمز\' لإعادة تعيين كلمة المرور الخاصة بك.';

  @override
  String get enterToken => 'أدخل الرمز';

  @override
  String get close => 'إغلاق';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get enterTokenAndNewPassword =>
      'الرجاء إدخال الرمز المستلم عبر البريد الإلكتروني وكلمة المرور الجديدة.';

  @override
  String get resetTokenFromEmail => 'رمز إعادة التعيين من البريد الإلكتروني';

  @override
  String get newPassword => 'كلمة مرور جديدة';

  @override
  String get passwordRequirements =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل مع أحرف وأرقام.';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة.';

  @override
  String get passwordResetSuccess => 'تم إعادة تعيين كلمة المرور بنجاح!';

  @override
  String get passwordResetFailed => 'فشل إعادة تعيين كلمة المرور.';

  @override
  String get inventoryLogin => 'تسجيل الدخول للمخزون';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get loggingIn => 'جاري تسجيل الدخول...';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get signUpHere => 'سجل هنا';

  @override
  String get products => 'المنتجات';

  @override
  String get productsRefresh => 'تحديث المنتجات';

  @override
  String get productsAddNew => 'إضافة منتج جديد';

  @override
  String get productsSearchByName => 'البحث عن المنتجات بالاسم';

  @override
  String get productsEnterName => 'أدخل اسم المنتج...';

  @override
  String get productsNoProductsFound => 'لم يتم العثور على منتجات';

  @override
  String get productsUnexpectedDataFormat => 'تم استلام تنسيق بيانات غير متوقع';

  @override
  String get productsErrorFetching => 'خطأ في جلب المنتجات';

  @override
  String get productsErrorOpeningDetails => 'خطأ في فتح تفاصيل المنتج';

  @override
  String get confirmDeleteProductMessage =>
      'هل أنت متأكد أنك تريد حذف هذا المنتج؟';

  @override
  String get productsDeleteSuccess => 'تم حذف المنتج بنجاح';

  @override
  String get productsDeleteFailed => 'فشل حذف المنتج';

  @override
  String get productsErrorDeleting => 'خطأ في حذف المنتج';

  @override
  String get productsStock => 'المخزون';

  @override
  String get details => 'التفاصيل';

  @override
  String get productDetailsUnexpectedComponentsFormat =>
      'تنسيق مكونات غير متوقع';

  @override
  String get productDetailsFailedToLoadComponents => 'فشل تحميل المكونات';

  @override
  String get productDetailsErrorFetchingComponents => 'خطأ في جلب المكونات';

  @override
  String get productDetailsUnexpectedProductFormat => 'تنسيق منتج غير متوقع';

  @override
  String get productDetailsFailedToLoadProduct => 'فشل تحميل المنتج';

  @override
  String get productDetailsErrorFetchingProduct => 'خطأ في جلب المنتج';

  @override
  String get productDetailsErrorPickingImage => 'خطأ في اختيار الصورة';

  @override
  String get productDetailsAddRequiredComponent => 'إضافة مكون مطلوب';

  @override
  String get productDetailsSearchComponentByReference =>
      'البحث عن مكون بالمرجع';

  @override
  String get productDetailsEnterReference => 'أدخل المرجع...';

  @override
  String get productDetailsComponent => 'مكون';

  @override
  String get productDetailsUnknown => 'غير معروف';

  @override
  String get productDetailsNoRef => 'لا يوجد مرجع';

  @override
  String get productDetailsQuantityRequired => 'الكمية مطلوبة';

  @override
  String get productDetailsAdd => 'إضافة';

  @override
  String get productDetailsNameRequired => 'اسم المنتج مطلوب';

  @override
  String get productDetailsStockRequired => 'كمية المخزون مطلوبة';

  @override
  String get productDetailsStockValidNumber =>
      'المخزون يجب أن يكون رقمًا صالحًا';

  @override
  String get productDetailsStockCannotBeNegative =>
      'المخزون لا يمكن أن يكون سلبيًا';

  @override
  String get productDetailsCreateSuccess => 'تم إنشاء المنتج بنجاح!';

  @override
  String get productDetailsUpdateSuccess => 'تم تحديث المنتج بنجاح!';

  @override
  String get productDetailsUnexpectedResponseFormat =>
      'تنسيق استجابة غير متوقع';

  @override
  String get unknownErrorOccurred => 'حدث خطأ غير معروف';

  @override
  String get productDetailsFailedTo => 'فشل في';

  @override
  String get productDetailsProduct => 'منتج';

  @override
  String get productDetailsError => 'خطأ';

  @override
  String get productDetailsCreating => 'إنشاء';

  @override
  String get productDetailsSaving => 'حفظ';

  @override
  String get productDetailsConfirmDeleteMessage =>
      'هل أنت متأكد من رغبتك في حذف هذا المنتج؟ هذا الإجراء لا رجعة فيه.';

  @override
  String get productDetailsDeleteSuccess => 'تم حذف المنتج بنجاح';

  @override
  String get productDetailsFailedToDeleteProduct => 'فشل في حذف المنتج';

  @override
  String get productDetailsErrorDeletingProduct => 'خطأ أثناء حذف المنتج';

  @override
  String get productDetailsProduceSuccess => 'تم تصنيع المنتج بنجاح';

  @override
  String get productDetailsFailedToProduce => 'فشل في التصنيع';

  @override
  String get productDetailsErrorProducingProduct => 'خطأ أثناء تصنيع المنتج';

  @override
  String get productDetailsKey => 'مفتاح';

  @override
  String get productDetailsValue => 'قيمة';

  @override
  String get productDetailsUnknownComponent => 'مكون غير معروف';

  @override
  String get productDetailsAddProduct => 'إضافة منتج';

  @override
  String get productDetailsDetails => 'تفاصيل المنتج';

  @override
  String get productDetailsChooseImage => 'اختر صورة';

  @override
  String get productDetailsName => 'الاسم';

  @override
  String get productDetailsEnterProductName => 'أدخل اسم المنتج';

  @override
  String get productDetailsCategory => 'الفئة';

  @override
  String get productDetailsEnterProductCategory => 'أدخل فئة المنتج';

  @override
  String get productDetailsDescription => 'الوصف';

  @override
  String get productDetailsEnterProductDescription => 'أدخل وصف المنتج';

  @override
  String get productDetailsStock => 'المخزون';

  @override
  String get productDetailsEnterStockQuantity => 'أدخل كمية المخزون';

  @override
  String get productDetailsDecreaseStock => 'تقليل المخزون';

  @override
  String get productDetailsIncreaseStock => 'زيادة المخزون';

  @override
  String get productDetailsProduce => 'تصنيع';

  @override
  String get productDetailsAdditionalInfo => 'معلومات إضافية';

  @override
  String get productDetailsAddInfo => 'إضافة معلومات';

  @override
  String get productDetailsRequiredComponents => 'المكونات المطلوبة';

  @override
  String get productDetailsAddComponent => 'إضافة مكون';

  @override
  String get productDetailsPleaseSelectComponent => 'الرجاء تحديد مكون.';

  @override
  String get productDetailsQuantityPositive =>
      'الكمية المطلوبة يجب أن تكون رقماً موجباً.';

  @override
  String get productDetailsNoComponentsFound => 'لم يتم العثور على مكونات.';

  @override
  String get productDetailsProductionFailed => 'فشل الإنتاج';

  @override
  String get productDetailsInsufficientStockMessage =>
      'لا يمكن إنتاج هذا المنتج بسبب عدم كفاية المخزون من المكونات المطلوبة:';

  @override
  String get productDetailsMissingComponents => 'المكونات الناقصة:';

  @override
  String productDetailsRequiredQuantity(String quantity) {
    return 'المطلوب: $quantity';
  }

  @override
  String productDetailsAvailableQuantity(String quantity) {
    return 'المتوفر: $quantity';
  }

  @override
  String productDetailsShortage(String quantity) {
    return 'النقص: $quantity';
  }

  @override
  String get productDetailsClose => 'إغلاق';

  @override
  String get productDetailsNoStockToSell => 'لا يوجد مخزون متاح للبيع';

  @override
  String get productDetailsConfirmSell => 'تأكيد البيع';

  @override
  String get productDetailsConfirmSellMessage =>
      'هل أنت متأكد أنك تريد وضع علامة على وحدة واحدة كمباعة؟ سيؤدي هذا إلى تقليل المخزون بمقدار 1.';

  @override
  String get productDetailsConfirm => 'تأكيد';

  @override
  String get productDetailsSell => 'بيع';

  @override
  String get productDetailsSellSuccess => 'تم بيع المنتج بنجاح';

  @override
  String get productDetailsFailedToSell => 'فشل بيع المنتج';

  @override
  String get productDetailsErrorSelling => 'خطأ في بيع المنتج';

  @override
  String get create => 'يصنع';

  @override
  String get filterSearchHint => 'ابحث بالاسم أو المرجع...';

  @override
  String get filterAdvanced => 'فلاتر متقدمة';

  @override
  String get filterClear => 'مسح الفلاتر';

  @override
  String get filterType => 'النوع';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterReference => 'المرجع';

  @override
  String get filterReferenceHint => 'تصفية حسب المرجع...';

  @override
  String get filterDimensions => 'الأبعاد';

  @override
  String get filterDimensionsHint => 'تصفية حسب الأبعاد...';

  @override
  String get filterLength => 'الطول';

  @override
  String get filterWeight => 'الوزن';

  @override
  String get filterHeight => 'الارتفاع';

  @override
  String get filterStock => 'المخزون';

  @override
  String get filterMin => 'الحد الأدنى';

  @override
  String get filterMax => 'الحد الأقصى';

  @override
  String get componentsTitle => 'المكونات';

  @override
  String get componentsRefresh => 'تحديث';

  @override
  String get componentsAddComponent => 'إضافة مكون';

  @override
  String get componentsNoComponentsFound => 'لم يتم العثور على مكونات';

  @override
  String get componentsNoMatchingFilters =>
      'لا توجد مكونات تطابق المرشحات الخاصة بك';

  @override
  String get componentsUnexpectedDataFormat =>
      'تم استلام تنسيق بيانات غير متوقع';

  @override
  String get componentsErrorFetching => 'خطأ في جلب المكونات';

  @override
  String get componentsErrorOpeningDetails => 'خطأ في فتح تفاصيل المكون';

  @override
  String get componentsConfirmDeleteTitle => 'تأكيد الحذف';

  @override
  String get componentsConfirmDeleteMessage =>
      'هل أنت متأكد من أنك تريد حذف هذا المكون؟';

  @override
  String get componentsDeleteSuccess => 'تم حذف المكون بنجاح';

  @override
  String get componentsCreateSuccess => 'تم إنشاء المكون بنجاح';

  @override
  String get componentsUpdateSuccess => 'تم تحديث المكون بنجاح';

  @override
  String get componentsDeleteFailed => 'فشل في حذف المكون';

  @override
  String get componentsErrorDeleting => 'خطأ في حذف المكون';

  @override
  String get componentDetailsTitle => 'تفاصيل المكون';

  @override
  String get componentDetailsAdd => 'إضافة مكون';

  @override
  String get componentDetailsRefresh => 'تحديث';

  @override
  String get componentDetailsChooseImage => 'اختيار صورة';

  @override
  String get componentDetailsName => 'الاسم';

  @override
  String get componentDetailsType => 'النوع';

  @override
  String get componentDetailsLength => 'الطول';

  @override
  String get componentDetailsWeight => 'الوزن';

  @override
  String get componentDetailsDimensions => 'الأبعاد';

  @override
  String get componentDetailsHeight => 'الارتفاع';

  @override
  String get componentDetailsReference => 'المرجع';

  @override
  String get componentDetailsStock => 'المخزون';

  @override
  String get componentDetailsDescription => 'الوصف';

  @override
  String get componentDetailsAdditionalInfo => 'معلومات إضافية';

  @override
  String get componentDetailsKey => 'المفتاح';

  @override
  String get componentDetailsValue => 'القيمة';

  @override
  String get componentDetailsAddInfo => 'إضافة معلومة';

  @override
  String get componentDetailsSave => 'حفظ';

  @override
  String get componentDetailsDelete => 'حذف';

  @override
  String get componentDetailsNameRequired => 'الاسم مطلوب';

  @override
  String get componentDetailsTypeRequired => 'النوع مطلوب';

  @override
  String get componentDetailsUnexpectedFormat => 'تنسيق مكون غير متوقع';

  @override
  String get componentDetailsFailedToLoad => 'فشل في تحميل المكون';

  @override
  String get componentDetailsErrorFetching => 'خطأ في جلب المكون';

  @override
  String get componentDetailsErrorPicking => 'خطأ في اختيار الصورة';

  @override
  String get componentDetailsCreatedSuccess => 'تم إنشاء المكون بنجاح';

  @override
  String get componentDetailsUpdatedSuccess => 'تم تحديث المكون بنجاح';

  @override
  String get componentDetailsUnexpectedResponse =>
      'استجابة غير متوقعة من الخادم';

  @override
  String get componentDetailsFailedToSave => 'فشل في حفظ المكون';

  @override
  String get componentDetailsErrorSaving => 'خطأ في حفظ المكون';

  @override
  String get componentDetailsConfirmDeleteTitle => 'تأكيد الحذف';

  @override
  String get componentDetailsConfirmDeleteMessage =>
      'هل أنت متأكد من أنك تريد حذف هذا المكون؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get componentDetailsDeletedSuccess => 'تم حذف المكون بنجاح';

  @override
  String get componentDetailsFailedToDelete => 'فشل في حذف المكون';

  @override
  String get componentDetailsErrorDeleting => 'خطأ في حذف المكون';

  @override
  String get componentDetailsUnsavedChanges => 'تغييرات غير محفوظة';

  @override
  String get componentDetailsUnsavedMessage =>
      'لديك تغييرات غير محفوظة. هل أنت متأكد من أنك تريد المغادرة؟';

  @override
  String get componentDetailsStay => 'البقاء';

  @override
  String get componentDetailsLeave => 'المغادرة';

  @override
  String get componentDetailsDiameter => 'قطر ';

  @override
  String get componentTypePrimeMaterial => 'المواد الأولية';

  @override
  String get componentTypeConsumablePieces => 'القطع الاستهلاكية';

  @override
  String get componentTypeStandardPieces => 'القطع القياسية';

  @override
  String get componentTypeFurniture => 'الأثاث';

  @override
  String get dashboardTitle => 'لوحة التحكم';

  @override
  String get dashboardRefresh => 'تحديث';

  @override
  String get dashboardWelcomeAdmin => 'مرحباً بالمشرف';

  @override
  String get dashboardWelcomeUser => 'مرحباً بالمستخدم';

  @override
  String get dashboardWelcomeMessage =>
      'إليك نظرة سريعة على نظامك. راجع التنبيهات، وراقب حركة المخزون، وتحقق من نشاط الجلسات—كل ذلك في مكان واحد.';

  @override
  String get dashboardGotIt => 'فهمت';

  @override
  String get dashboardLowStockAlerts => 'تنبيهات المخزون المنخفض';

  @override
  String get dashboardAllStocksHealthy => 'جميع المخزونات سليمة';

  @override
  String get dashboardSessionLogs => 'سجلات الجلسات';

  @override
  String get dashboardNoSessionLogs => 'لا توجد سجلات جلسات';

  @override
  String get dashboardRecentStockMovements => 'حركات المخزون الحديثة';

  @override
  String get dashboardNoStockMovements => 'لا توجد حركات مخزون';

  @override
  String get dashboardStock => 'المخزون';

  @override
  String get dashboardUnknown => 'غير معروف';

  @override
  String get dashboardComponent => 'مكون';

  @override
  String get dashboardProduct => 'منتج';

  @override
  String get dashboardQuantityChange => 'تغيير الكمية';

  @override
  String get dashboardTime => 'الوقت';

  @override
  String get dashboardActivity => 'النشاط';

  @override
  String get dashboardActive => 'نشط';

  @override
  String get dashboardInvalidDate => 'تاريخ غير صالح';

  @override
  String get dashboardLoginDate => 'تاريخ تسجيل الدخول';

  @override
  String get dashboardUserID => 'معرف المستخدم';

  @override
  String get dashboardComponents => 'المكونات';

  @override
  String get dashboardProducts => 'المنتجات';

  @override
  String get dashboardAccount => 'الحساب';

  @override
  String get dashboardLogout => 'تسجيل الخروج';

  @override
  String get dashboardAdmin => 'مشرف';

  @override
  String get dashboardUser => 'مستخدم';

  @override
  String get sessionLogsTitle => 'سجلات الجلسات';

  @override
  String get sessionLogsNoLogs => 'لا توجد سجلات جلسات متاحة';

  @override
  String get sessionLogsErrorLoading => 'خطأ في تحميل سجلات الجلسات';

  @override
  String get sessionLogsRefresh => 'تحديث';

  @override
  String get lowStockTitle => 'تنبيهات المخزون المنخفض';

  @override
  String get lowStockNoAlerts => 'جميع المخزونات سليمة';

  @override
  String get lowStockErrorLoading => 'خطأ في تحميل بيانات المخزون المنخفض';

  @override
  String get lowStockRefresh => 'تحديث';

  @override
  String get lowStockThreshold => 'عتبة المخزون المنخفض';

  @override
  String get lowStockCritical => 'مستوى المخزون الحرج';

  @override
  String get stockMovementsTitle => 'حركات المخزون';

  @override
  String get stockMovementsSideMenu => 'حركات المخزون';

  @override
  String get stockMovementsRefreshTooltip => 'تحديث';

  @override
  String get stockMovementsSearchHint => 'البحث بالاسم أو المعرف...';

  @override
  String get stockMovementsFilterAll => 'الكل';

  @override
  String get stockMovementsFilterComponents => 'المكونات';

  @override
  String get stockMovementsFilterProducts => 'المنتجات';

  @override
  String get stockMovementsFilterIncreases => 'زيادات';

  @override
  String get stockMovementsFilterDecreases => 'نقصان';

  @override
  String stockMovementsCardComponentLabel(String id) {
    return 'مكون: $id';
  }

  @override
  String stockMovementsCardProductLabel(String id) {
    return 'منتج: $id';
  }

  @override
  String get stockMovementsErrorUnexpectedFormat =>
      'تم استلام تنسيق غير متوقع لحركات المخزون.';

  @override
  String stockMovementsErrorFetchFailed(int statusCode) {
    return 'فشل في جلب حركات المخزون. رمز الحالة: $statusCode';
  }

  @override
  String get stockMovementsErrorLoading => 'حدث خطأ أثناء تحميل حركات المخزون.';

  @override
  String get stockMovementsNoResults => 'لم يتم العثور على حركات للمخزون.';

  @override
  String get dashboardSystemOverview => 'نظرة عامة على النظام';

  @override
  String get dashboardLowStockAlertsTitle => 'تنبيهات المخزون المنخفض';

  @override
  String get dashboardItemsNeedAttention => 'عناصر تحتاج انتباه';

  @override
  String get dashboardActiveSessionsTitle => 'الجلسات النشطة';

  @override
  String get dashboardUsersOnlineNow => 'المستخدمون متصلون الآن';

  @override
  String get dashboardTotalComponentsTitle => 'إجمالي المكونات';

  @override
  String get dashboardInInventory => 'في المخزون';

  @override
  String get dashboardTotalProductsTitle => 'إجمالي المنتجات';

  @override
  String get dashboardAvailableProducts => 'المنتجات المتاحة';

  @override
  String get dashboardStockMovementsTitle => 'حركات المخزون';

  @override
  String get dashboardToday => 'اليوم';

  @override
  String get dashboardSystemStatusTitle => 'حالة النظام';

  @override
  String get dashboardOnline => 'متصل';

  @override
  String get dashboardAllServicesRunning => 'جميع الخدمات تعمل';

  @override
  String get dashboardAnalyticsInsights => 'التحليلات والرؤى';

  @override
  String get dashboardComponentsByType => 'المكونات حسب النوع';

  @override
  String get dashboardNoComponentData => 'لا توجد بيانات مكونات متاحة';

  @override
  String get dashboardTopActiveUsers => 'أكثر المستخدمين نشاطاً';

  @override
  String get dashboardLast30Days => 'آخر 30 يوماً';

  @override
  String get dashboardNoUserActivityData =>
      'لا توجد بيانات نشاط المستخدم متاحة';

  @override
  String get dashboardSessions => 'جلسات';

  @override
  String get dashboardMinAvg => 'دقيقة متوسط';

  @override
  String get dashboardProductionInsights => 'رؤى الإنتاج';

  @override
  String get dashboardAllTimeChampion => 'بطل كل الأوقات';

  @override
  String get dashboardUnitsProduced => 'وحدات مُنتجة';

  @override
  String get dashboardRecentProductionMonth => 'الإنتاج الحديث (هذا الشهر)';

  @override
  String get dashboardWelcomeToDashboard => 'مرحباً بك في لوحة التحكم';

  @override
  String get dashboardManageInventory => 'إدارة المخزون بكفاءة';

  @override
  String get dashboardNavigationHelp =>
      'استخدم قائمة التنقل للوصول إلى أقسام مختلفة من نظام إدارة المخزون الخاص بك. توفر بطاقات النظرة العامة أعلاه وصولاً سريعاً للمناطق الرئيسية وإحصائيات في الوقت الفعلي عن نظامك.';

  @override
  String get dashboardItems => 'عناصر';

  @override
  String get accountSettingsChangePassword => 'تغيير كلمة المرور';

  @override
  String get accountSettingsCurrentPassword => 'كلمة المرور الحالية';

  @override
  String get accountSettingsNewPassword => 'كلمة المرور الجديدة';

  @override
  String get accountSettingsConfirmPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get accountSettingsCurrentPasswordRequired =>
      'كلمة المرور الحالية مطلوبة';

  @override
  String get accountSettingsNewPasswordRequired => 'كلمة المرور الجديدة مطلوبة';

  @override
  String get accountSettingsPasswordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get accountSettingsWeakPassword =>
      'يجب أن تكون كلمة المرور 8 أحرف على الأقل مع أحرف وأرقام';

  @override
  String get accountSettingsRequired => 'مطلوب';

  @override
  String get accountSettingsInvalidPhone => 'يجب أن يكون الهاتف 8 أرقام';

  @override
  String get accountSettingsUpdateTitle => 'تحديث';

  @override
  String get accountSettingsUpdateSuccess => 'تم تحديث الحساب بنجاح';

  @override
  String get accountSettingsUpdateFailed => 'فشل تحديث الحساب';

  @override
  String get accountSettingsUnexpectedFormat => 'تنسيق بيانات غير متوقع';

  @override
  String get accountSettingsFailedToFetch => 'فشل في جلب معلومات المستخدم';

  @override
  String get accountSettingsErrorFetching => 'خطأ في جلب معلومات المستخدم';

  @override
  String get accountSettingsErrorUpdating => 'خطأ في تحديث الحساب';

  @override
  String get accountSettingsErrorPickingImage =>
      'خطأ في اختيار صورة الملف الشخصي';
}
