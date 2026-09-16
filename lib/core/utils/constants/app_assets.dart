import '../../../config/app_config.dart';

abstract class AppAssets {
  AppAssets._();

  //? ===== Paths =====//
  static const String _imagePath = "assets/images/";
  static const String _iconPath = "assets/icons/";
  static const String _animationPath = "assets/animations/";

  static const String empty = "${_animationPath}empty.json";
  static const String empty22 = "${_animationPath}empty22.json";
  static const String error = "${_animationPath}error.json";
  static const String loading = "${_animationPath}loading.json";
  static const String paymentSuccess = "${_animationPath}payment_success.json";
  static const String success = "${_animationPath}success.json";
  static const String support = "${_animationPath}support.json";

  //? ===== App Images (من مجلد images) =====//
  static const String splash = AppConfig.splashLogo;
  static const String appLogo = AppConfig.appLogo;
  static const String logoPngIcon = "${_imagePath}icon.png";
  static const String logoSvgIcon = "${_imagePath}icon.svg";
  static const String emptyCuate = "${_imagePath}empty-cuate.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== Navigation Menu Icons =====//
  // ─────────────────────────────────────────────────────────────────────────

  static const String menu = "${_iconPath}menu.svg";
  static const String menuDashboard = "${_iconPath}ic-menu-dashboard.svg";
  static const String menuUsers = "${_iconPath}ic-menu-users.svg";
  static const String menuStores = "${_iconPath}ic-menu-stores.svg";
  static const String menuBriefcase = "${_iconPath}ic-menu-briefcase.svg";
  static const String menuPackages = "${_iconPath}ic-menu-packages.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== User & Account Icons =====//
  // ─────────────────────────────────────────────────────────────────────────
  static const String icUser = "${_iconPath}ic-user.svg";
  static const String icUserName = "${_iconPath}ic-user-name.svg";
  static const String userGroup = "${_iconPath}user-group.svg";
  static const String user03 = "${_iconPath}user-03.svg";
  static const String icUsers01 = "${_iconPath}ic-users-01.svg";
  static const String icAddUser = "${_iconPath}ic-add-user.svg";
  static const String userName = "${_iconPath}user_name.svg";
  static const String icRepresentative = "${_iconPath}ic-representative-01.svg";
  static const String icRepresentative2 =
      "${_iconPath}ic-representative-02.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== Store Icons =====//
  // ─────────────────────────────────────────────────────────────────────────
  static const String icStore01 = "${_iconPath}ic-store-01.svg";
  static const String isStoreAdd01 = "${_iconPath}is-store-add-01.svg";
  static const String storeAdd02 = "${_iconPath}store-add-02.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== Package & Subscription Icons =====//
  // ─────────────────────────────────────────────────────────────────────────
  static const String icPackage02 = "${_iconPath}ic-package-02.svg";
  static const String icActiveSubscriptions01 =
      "${_iconPath}ic-active-subscriptions-01.svg";
  static const String icAddSubscriptions =
      "${_iconPath}ic-adda-subscriptions.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== Financial Icons =====//
  // ─────────────────────────────────────────────────────────────────────────
  static const String icCash = "${_iconPath}ic-cash.svg";
  static const String icCredit = "${_iconPath}ic-credit.svg";
  static const String icDolar = "${_iconPath}ic-dolar.svg";
  static const String icMoneyBag01 = "${_iconPath}ic-money-bag-01.svg";
  static const String icMoneyBag02 = "${_iconPath}ic-money-bag-02.svg";
  static const String icMony02 = "${_iconPath}ic-mony-02.svg";
  static const String icPrice = "${_iconPath}ic-price.svg";
  static const String saveMoneyDollar = "${_iconPath}save-money-dollar.svg";
  static const String discount = "${_iconPath}discount.svg";
  static const String icDiscount01 = "${_iconPath}ic-discount-01.svg";
  static const String icHash = "${_iconPath}ic-#.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== Actions Icons =====//
  // ─────────────────────────────────────────────────────────────────────────
  static const String icEdit = "${_iconPath}ic-edit.svg";
  static const String edit02 = "${_iconPath}edit-02.svg";
  static const String icDelete = "${_iconPath}ic-delete.svg";
  static const String icEye = "${_iconPath}ic-eye.svg";
  static const String icAddImage = "${_iconPath}ic-add-image.svg";
  static const String icAddStars = "${_iconPath}ic-add-stars.svg";
  static const String more = "${_iconPath}more.svg";
  static const String doneCircle = "${_iconPath}done-circle.svg";
  static const String cancelCircle = "${_iconPath}cancel-circle.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== Date & Time Icons =====//
  // ─────────────────────────────────────────────────────────────────────────
  static const String icDate = "${_iconPath}ic-date.svg";
  static const String icDateAndTime = "${_iconPath}ic-date-and-time.svg";
  static const String icDateComing = "${_iconPath}ic-date-coming.svg";
  static const String icTime = "${_iconPath}ic-time.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== Status & Indicators Icons =====//
  // ─────────────────────────────────────────────────────────────────────────
  static const String icStatus = "${_iconPath}ic-status.svg";
  static const String toggleOn = "${_iconPath}toggle-on.svg";
  static const String toggleOff = "${_iconPath}toggle-off.svg";
  static const String starFilled = "${_iconPath}star_filled.svg";
  static const String starOutlined = "${_iconPath}star_outlined.svg";
  static const String starBorder = "${_iconPath}star_border.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== Contact & Info Icons =====//
  // ─────────────────────────────────────────────────────────────────────────
  static const String icPhone = "${_iconPath}ic-phone.svg";
  static const String icLocation = "${_iconPath}ic-location.svg";
  static const String icNotification = "${_iconPath}ic-notification.svg";
  static const String icQr = "${_iconPath}ic-qr.svg";
  static const String icQrOutlined = "${_iconPath}ic-qr-outlined.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== Security Icons =====//
  // ─────────────────────────────────────────────────────────────────────────
  static const String lockPassword = "${_iconPath}lock_password.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== System Icons =====//
  // ─────────────────────────────────────────────────────────────────────────
  static const String logout = "${_iconPath}logout.svg";
  static const String control = "${_iconPath}Control.svg";
  static const String catalogue = "${_iconPath}catalogue.svg";

  // ─────────────────────────────────────────────────────────────────────────
  //? ===== app info Icons =====//
  // ─────────────────────────────────────────────────────────────────────────
  static const String contactUs = "${_iconPath}contact_us.svg";
  static const String location = "${_iconPath}location.svg";
  static const String whatsApp = "${_iconPath}whats_app.svg";
  static const String email = "${_iconPath}email.svg";
  static const String home = "${_iconPath}home.svg";
  static const String icExcel = "${_iconPath}ic-excel.svg";

  
  static const String sliders = "${_iconPath}sliders.svg";
  static const String mdiMultimedia = "${_iconPath}mdi_multimedia.svg";
  static const String sort = "${_iconPath}sort.svg";
  static const String map = "${_iconPath}map.svg";
}
