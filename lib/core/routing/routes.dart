/// Ù…Ø³Ø§Ø±Ø§Øª Ø§Ù„ØªØ·Ø¨ÙŠÙ‚ (paths) â€” ØªÙØ³ØªØ®Ø¯Ù… Ù„Ù„Ù€ GoRouter
class Routes {
  Routes._();

  static const String splash = '/';
  static const String login = '/login';

  // â”€â”€â”€ Main app â”€â”€â”€
  static const String home = '/home';

  // â”€â”€â”€ Sub screens (inside AppLayout) â”€â”€â”€
  static const String dashboard = '/home/dashboard';
  static const String users = '/home/users';
  static const String stores = '/home/stores';
  static const String agents = '/home/agents';
  static const String plans = '/home/plans';
  static const String sliders = '/home/sliders';
  static const String dashboardOrders = '/home/dashboard-orders';

  /// ÙŠÙØ±Ø¬Ø¹ Ø§Ù„Ù€ path Ø§Ù„Ù…Ù‚Ø§Ø¨Ù„ Ù„Ø§Ø³Ù… Ø§Ù„Ù€ route
  /// ÙŠÙØ³ØªØ®Ø¯Ù… ÙÙŠ Ø§Ù„Ù€ drawer Ù„ØªØ­Ø¯ÙŠØ¯ Ø§Ù„Ø¹Ù†ØµØ± Ø§Ù„Ù†Ø´Ø· Ø¨Ù†Ø§Ø¡Ù‹ Ø¹Ù„Ù‰ Ø§Ù„Ù€ URL Ø§Ù„Ø­Ø§Ù„ÙŠ
  static String routeForName(String routeName) {
    switch (routeName) {
      case RouteNames.dashboard:
        return dashboard;
      case RouteNames.users:
        return users;
      case RouteNames.stores:
        return stores;
      case RouteNames.agents:
        return agents;
      case RouteNames.plans:
        return plans;
      case RouteNames.sliders:
        return sliders;
      default:
        return home;
    }
  }
}

/// Ø£Ø³Ù…Ø§Ø¡ Ø§Ù„Ù€ routes â€” ØªÙØ³ØªØ®Ø¯Ù… Ù„Ù„Ù€ named navigation ÙˆÙ„ØªØºÙŠÙŠØ± Ø§Ù„Ù€ URL ÙÙŠ Ø§Ù„ÙˆÙŠØ¨
/// Ù…Ø«Ø§Ù„: context.goNamed(RouteNames.dashboard)
class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String login = 'login';
  static const String home = 'home';

  // â”€â”€â”€ Sub screens â”€â”€â”€
  static const String dashboard = 'dashboard';
  static const String users = 'users';
  static const String stores = 'stores';
  static const String agents = 'agents';
  static const String plans = 'plans';
  static const String sliders = 'sliders';
  static const String userDetails = 'userDetails';
  static const String storeDetails = 'storeDetails';
  static const String agentDetails = 'agentDetails';
  static const String planDetails = 'planDetails';
  static const String dashboardOrders = 'dashboardOrders';
}

