import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';
import 'package:income/pages/homePage.dart';
import 'package:income/pages/signInPage.dart';
import 'package:income/utils/bigText.dart';

import 'package:income/utils/smallText.dart';
import 'package:lottie/lottie.dart';

import '../utils/generateTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  myController controller = Get.put(myController());
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.indigo.withOpacity(0.6),
                        Colors.indigoAccent.withOpacity(0.3),
                        Colors.transparent
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  height: constraints().getHeight(context) * 0.3,
                  width: constraints().getWidth(context),
                  child: Lottie.asset("asset/lottie/animation2.json"),
                  // child:
                  //     SvgPicture.asset("asset/undraw_secure_login_pdn4.svg")
                ),
                const SizedBox(
                  height: 50,
                ),
                const BigText(
                  text: "Welcome Back",
                  family: 'Poopins',
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SmallText(
                      text: "Already have an Accout?",
                      size: 20,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(const SignInPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        child: SmallText(
                          text: "Sign Up",
                          size: 22,
                          family: "Poppins",
                          color: constraints.primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GenerateTextField(
                    controller: controller.emailController,
                    regex: constraints.emailRegExp,
                    label: "Email",
                    icon: Icons.email),
                GetBuilder<myController>(builder: (builder) {
                  return GenerateTextField(
                      controller: controller.passwordController,
                      regex: constraints.passwordRegex,
                      label: "Password",
                      icon: Icons.lock,
                      isPassword: true);
                }),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.login();
                        Get.to( HomePage());
                      } else {
                        debugPrint("Login failed");
                      }
                    },
                    child: SmallText(
                      text: "Login",
                      color: constraints.secondaryColor,
                    )),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 0),
                    onPressed: () {},
                    child: SmallText(
                      text: "Login up with Google",
                      color: constraints.primaryColor,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
