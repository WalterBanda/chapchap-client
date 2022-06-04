import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/routes/router.dart';
import '../../core/routes/routes.dart';
import '../../styles/ui/colors.dart';
import 'onboarding.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  static const String id = "login";

  void _userAuth({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((credential) => GlobalNavigator.router.currentState!
              .pushReplacementNamed(GlobalRoutes.switchRoles));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          alertSnackBar(
            message:
                "You dont Currently have an Account, Create one or check your credentials",
            errorLabel: 'Go to Email Login',
            errorCallback: () {
              AuthRouter.router.currentState!
                  .pushReplacementNamed(AuthRoutes.login);
            },
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          alertSnackBar(
            message: "Your entered a wrong password, try again",
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          alertSnackBar(
            message: e.code,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => AuthRouter.router.currentState!
              .popAndPushNamed(AuthRoutes.onboarding),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildBranding(context),
              const SizedBox(height: 40),
              authInput(
                hint: "Enter your Email",
                inputType: TextInputType.emailAddress,
                prefix: const Icon(
                  Icons.email_rounded,
                  size: 15,
                ),
              ),
              const SizedBox(height: 14),
              authInput(
                hint: "Enter your Password",
                inputType: TextInputType.visiblePassword,
                private: true,
                prefix: const Icon(
                  Icons.lock_rounded,
                  size: 15,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _userAuth,
                style: ElevatedButton.styleFrom(
                  primary: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 17, horizontal: 124),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              createAccountShortcut()
            ],
          ),
        ),
      ),
    );
  }
}

Widget authInput({
  required String hint,
  TextEditingController? controller,
  String? errorMessage,
  TextInputType? inputType,
  bool private = false,
  Widget? prefix,
  Widget? suffix,
}) {
  return SizedBox(
    width: 300,
    child: TextField(
      controller: controller,
      textAlignVertical: TextAlignVertical.center,
      obscureText: private,
      keyboardType: inputType,
      style: const TextStyle(
        fontFamily: "SF Pro Rounded",
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
      //TODO Implement Input Checking
      decoration: InputDecoration(
        filled: true,
        isCollapsed: true,
        prefixIcon: prefix,
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.fromLTRB(30, 17, 0, 17),
        fillColor: AppColors.input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        helperText: errorMessage,
        helperStyle: const TextStyle(
          fontFamily: "SF Pro Rounded",
          fontSize: 10,
          color: AppColors.error,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    ),
  );
}
