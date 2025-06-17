import 'package:get/get.dart';

//views
import '../presentation/views/welcome_view.dart';
import '../presentation/main_layout.dart';

//routes
class Routes {
  static final List<GetPage> pages = [
    //welcome
    GetPage(name: '/', page: () => const WelcomeView()),
    //main app (maneja home y profile internamente)
    GetPage(name: '/home', page: () => const MainLayout(initialIndex: 0)),
    GetPage(name: '/profile', page: () => const MainLayout(initialIndex: 1)),
  ];
}
