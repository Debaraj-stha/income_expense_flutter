import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:income/model/constraints.dart';
import 'package:income/model/controller.dart';
import 'package:income/pages/loginPage.dart';

import 'package:income/utils/smallText.dart';

import '../utils/generateTextField.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  myController controller = Get.find();
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
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.indigo.withOpacity(0.2),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.indigo.withOpacity(0.1),
                          Colors.indigoAccent.withOpacity(0.2),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    height: constraints().getHeight(context) * 0.3,
                    child: SvgPicture.asset(
                        "asset/undraw_access_account_re_8spm.svg")),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SmallText(
                      text: "Do not have an Accout?",
                      size: 20,
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(const LoginPage());
                      },
                      child: SmallText(
                        text: "Login",
                        size: 20,
                        color: constraints.primaryColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                GenerateTextField(
                    controller: controller.nameController,
                    regex: constraints.nameRegExp,
                    label: "Username",
                    icon: Icons.person),
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
                        controller.signup();
                      } else {
                        debugPrint("Signup failed");
                      }
                    },
                    child: SmallText(
                      text: "Sign Up",
                      color: constraints.secondaryColor,
                    )),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 0),
                    onPressed: () {
                      controller.signinWithGoogle();
                    },
                    child: SmallText(
                      text: "Sign up with Google",
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
