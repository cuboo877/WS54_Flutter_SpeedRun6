import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun6/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun6/page/home.dart';
import 'package:ws54_flutter_speedrun6/page/register.dart';
import 'package:ws54_flutter_speedrun6/service/auth.dart';
import 'package:ws54_flutter_speedrun6/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun6/service/utilites.dart';
import 'package:ws54_flutter_speedrun6/widget/text_button.dart';

import '../widget/custom_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController account_controller;
  late TextEditingController password_contoller;

  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool doAuthWarning = false;
  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_contoller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_contoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                customText("54全國技能", 40, AppColor.black, true),
                const SizedBox(height: 20),
                customText("登入", 30, AppColor.black, true),
                const SizedBox(height: 20),
                customText("帳號", 20, AppColor.black, false),
                const SizedBox(height: 20),
                accountTextForm(),
                const SizedBox(height: 20),
                customText("密碼", 20, AppColor.black, false),
                const SizedBox(height: 20),
                passwordTextForm(),
                const SizedBox(height: 20),
                loginAuthButton(),
                const SizedBox(height: 20),
                loginToRegister()
              ],
            )),
      ),
    );
  }

  Widget loginToRegister() {
    return Column(
      children: [
        customText("尚未擁有帳號?", 20, AppColor.black, false),
        InkWell(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterPage())),
          child: customText("註冊", 30, AppColor.darkBlue, true),
        )
      ],
    );
  }

  Widget loginAuthButton() {
    return appTextButton("登入", AppColor.black, 35, () async {
      if (isAccountValid && isPasswordValid) {
        bool result = await Auth.loginAuth(
            account_controller.text, password_contoller.text);

        if (result) {
          String userID = await SharedPref.getLoggedUserID();
          if (mounted) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(userID: userID)));
          }
        }
      } else {
        if (mounted) {
          Utilites.showSnackBar(context, "我想要睡覺:(");
        }
      }
    });
  }

  Widget accountTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: account_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (doAuthWarning) {
            isAccountValid = false;
            return "";
          } else if (value == null || value.trim().isEmpty) {
            isAccountValid = false;
            return "請輸入";
          } else if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
              .hasMatch(value)) {
            isAccountValid = false;
            return "請輸入正確的帳號格式";
          } else {
            isAccountValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "Account",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(45))),
      ),
    );
  }

  bool obscure = true;
  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        obscureText: obscure,
        controller: password_contoller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (doAuthWarning) {
            isPasswordValid = false;
            return "錯誤的帳號或密碼";
          } else if (value == null || value.trim().isEmpty) {
            isPasswordValid = false;
            return "請輸入";
          } else {
            isPasswordValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () => setState(() {
                      obscure = !obscure;
                    }),
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility)),
            hintText: "Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(45))),
      ),
    );
  }
}
