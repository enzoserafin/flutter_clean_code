import 'package:get/get.dart';

//O Getx da dispose nas stream automaticamente. Porém, para que isso ocorra a
//classe precisa extender GetxController. Por isso colocamos no mixin esse
//on GetxController para somene poder usar esse mixin em classes que extendem
//do get
mixin FormManager on GetxController {
  var _isFormValid = false.obs;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  set isFormValid(bool value) => _isFormValid.value = value;
}
