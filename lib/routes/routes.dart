import 'package:get/get.dart';

//views
import '../presentation/views/welcome_view.dart';
import '../presentation/main_layout.dart';
import '../presentation/views/login/login.dart';
import '../presentation/views/login/sign_in.dart';
import '../presentation/views/login/forgot.dart';


//routes
class Routes {
  static final List<GetPage> pages = [
    //welcome (ruta pública)
    GetPage(name: '/', page: () => const WelcomeView()),
    //main app (rutas protegidas)
    GetPage(
      name: '/home',
      page: () => const MainLayout(initialIndex: 0),
    ),
    GetPage(
      name: '/profile',
      page: () => const MainLayout(initialIndex: 1),
    ),
    //login (rutas públicas)
    GetPage(
      name: '/login',
      page: () => const LoginView(),
    ),
    GetPage(
      name: '/sign_in',
      page: () => const SignInView(),
    ),
    GetPage(name: '/forgot', page: () => const ForgotPasswordView()),
  ];
}
