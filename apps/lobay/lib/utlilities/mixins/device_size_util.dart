import 'package:get/get.dart';

mixin DeviceSizeUtil {
  double getDeviceHeight() {
    return Get.height;
  }

  double getDeviceWidth() {
    return Get.width;
  }

  double getDeviceHeightWithoutAppBar() {
    return Get.height - 56;
  }

  double getDeviceAppBarHeight() {
    return 56;
  }
}