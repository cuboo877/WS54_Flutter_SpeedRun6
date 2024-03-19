import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun6/page/details.dart';
import 'package:ws54_flutter_speedrun6/service/utilites.dart';

import '../constant/style_guide.dart';
import '../widget/custom_text.dart';
import '../widget/text_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController account_controller;
  late TextEditingController password_contoller;
  late TextEditingController confirm_contoller;
  bool isAccountValid = false;
  bool isPasswordValid = false;
  bool isConfirmValid = false;
  @override
  void initState() {
    super.initState();
    account_controller = TextEditingController();
    password_contoller = TextEditingController();
    confirm_contoller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_contoller.dispose();
    confirm_contoller.dispose();
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
                customText("註冊", 30, AppColor.black, true),
                const SizedBox(height: 20),
                customText("帳號", 20, AppColor.black, false),
                const SizedBox(height: 20),
                accountTextForm(),
                const SizedBox(height: 20),
                customText("密碼", 20, AppColor.black, false),
                const SizedBox(height: 20),
                passwordTextForm(),
                const SizedBox(height: 20),
                confirmTextForm(),
                const SizedBox(height: 20),
                registerAuthButton(),
                const SizedBox(height: 20),
                RegisterToLogin()
              ],
            )),
      ),
    );
  }

  Widget RegisterToLogin() {
    return Column(
      children: [
        customText("已經擁有帳號?", 20, AppColor.black, false),
        InkWell(
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RegisterPage())),
          child: customText("登入", 30, AppColor.darkBlue, true),
        )
      ],
    );
  }

  Widget registerAuthButton() {
    return appTextButton("註冊", AppColor.black, 35, () async {
      if (isAccountValid && isConfirmValid && isPasswordValid) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailsPage(
                  account: account_controller.text,
                  password: password_contoller.text,
                )));
      } else {
        Utilites.showSnackBar(context, "你他媽有沒有輸入 糙");
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
          if (value == null || value.trim().isEmpty) {
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
          if (value == null || value.trim().isEmpty) {
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

  bool obscure2 = true;
  Widget confirmTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        obscureText: obscure2,
        controller: confirm_contoller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value != password_contoller.text) {
            isConfirmValid = false;
            return "請重新確認密碼";
          } else if (value == null || value.trim().isEmpty) {
            isConfirmValid = false;
            return "請輸入";
          } else {
            isConfirmValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            suffixIcon: IconButton(
                onPressed: () => setState(() {
                      obscure2 = !obscure2;
                    }),
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility)),
            hintText: "Confirm Password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(45))),
      ),
    );
  }
}
