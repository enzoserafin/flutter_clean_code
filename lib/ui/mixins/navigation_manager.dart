import 'package:get/get.dart';

mixin NavigationManager {
  void handleNavigation(Stream<String> stream, {bool clear = false}) {
    stream.listen((page) {
      if (page?.isNotEmpty == true) {
        clear == true ? Get.offAllNamed(page) : Get.toNamed(page);
      }
    });
  }
}
