import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun6/service/sql_service.dart';
import 'package:ws54_flutter_speedrun6/widget/text_button.dart';

import '../constant/style_guide.dart';
import '../service/auth.dart';
import '../service/sharedPref.dart';
import '../service/utilites.dart';
import '../widget/custom_text.dart';
import 'home.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late TextEditingController account_controller;
  late TextEditingController password_contoller;
  late TextEditingController username_controller;
  late TextEditingController birthday_contoller;
  UserData userData = UserData('', '', '', '', '');
  bool isAccountValid = true;
  bool isPasswordValid = true;
  bool isUsernameValid = true;
  bool isBirthdayValid = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCurrentUserData();
    });
    super.initState();
    account_controller = TextEditingController();
    password_contoller = TextEditingController();
    username_controller = TextEditingController();
    birthday_contoller = TextEditingController();
  }

  @override
  void dispose() {
    account_controller.dispose();
    password_contoller.dispose();
    username_controller.dispose();
    birthday_contoller.dispose();
    super.dispose();
  }

  void getCurrentUserData() async {
    UserData data = await UserDAO.getUserDataByUserID(widget.userID);
    setState(() {
      userData = data;
      account_controller.text = data.account;
      password_contoller.text = data.password;
      username_controller.text = data.username;
      birthday_contoller.text = data.birthday;
    });
  }

  UserData packUserData() {
    return UserData(
        widget.userID,
        username_controller.text,
        account_controller.text,
        password_contoller.text,
        birthday_contoller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                customText("帳號", 20, AppColor.black, false),
                const SizedBox(height: 20),
                accountTextForm(),
                const SizedBox(height: 20),
                customText("密碼", 20, AppColor.black, false),
                const SizedBox(height: 20),
                passwordTextForm(),
                const SizedBox(height: 20),
                customText("使用者名稱", 20, AppColor.black, false),
                const SizedBox(height: 20),
                usernameTextForm(),
                const SizedBox(height: 20),
                customText("生日", 20, AppColor.black, false),
                const SizedBox(height: 20),
                birthdayTextForm(),
                const SizedBox(height: 20),
                submitEditButton()
              ],
            )),
      ),
    );
  }

  Widget submitEditButton() {
    return appTextButton("完成編輯", AppColor.black, 30, () async {
      if (isAccountValid &&
          isBirthdayValid &&
          isPasswordValid &&
          isUsernameValid) {
        await UserDAO.updateUserData(packUserData());
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.userID)));
        }
      } else {
        Utilites.showSnackBar(context, "瞎了嗎");
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

  Widget usernameTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: username_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isUsernameValid = false;
            return "請輸入";
          } else {
            isUsernameValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "User Name",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(45))),
      ),
    );
  }

  Widget birthdayTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: birthday_contoller,
        onTap: () async {
          DateTime? _picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2026));
          if (_picked != null) {
            isBirthdayValid = true;
            setState(() {
              birthday_contoller.text = _picked.toString().split(" ")[0];
            });
          } else {
            isBirthdayValid = false;
          }
        },
        readOnly: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            isBirthdayValid = false;
            return "i want to sleep :(((";
          } else {
            isBirthdayValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "i hate ws54",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(45))),
      ),
    );
  }

  Widget topBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "編輯使用者資料",
        style: TextStyle(color: AppColor.black),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColor.black,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
