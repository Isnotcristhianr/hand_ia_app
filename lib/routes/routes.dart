import 'package:get/get.dart';

//navigation
import '../presentation/home/nav_bar.dart';

//views
import '../presentation/views/welcome_view.dart';
import '../presentation/home/home_view.dart';

//routes
class Routes {
  static final List<GetPage> pages = [
    //nav bar
    GetPage(name: '/nav_bar', page: () => NavBar.buildNavBar()),
    //welcome
    GetPage(name: '/', page: () => const WelcomeView()),
    //home
    GetPage(name: '/home', page: () => const HomeView()),
  ];
}
