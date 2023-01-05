import 'package:get/get.dart';

mixin NavigationManager {
  void handleNavigation(Stream<String?> stream, {bool clear = false}) {
    stream.listen((page) {
      if (page != null && page.isNotEmpty) {
        clear == true ? Get.offAllNamed(page) : Get.toNamed(page);
      }
    });
  }
}
