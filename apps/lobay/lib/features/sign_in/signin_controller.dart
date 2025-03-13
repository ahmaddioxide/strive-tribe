import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // form key
  final formKey = GlobalKey<FormState>();

  RxBool rememberMe = false.obs;



}
