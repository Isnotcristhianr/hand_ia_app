import 'package:get/get.dart';

//views
import '../presentation/views/welcome_view.dart';

class Routes {
  static final List<GetPage> pages = [
    GetPage(name: '/', page: () => const WelcomeView()),
  ];
}
