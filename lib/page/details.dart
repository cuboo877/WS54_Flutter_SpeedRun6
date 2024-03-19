import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun6/page/home.dart';
import 'package:ws54_flutter_speedrun6/service/auth.dart';
import 'package:ws54_flutter_speedrun6/service/sql_service.dart';
import 'package:ws54_flutter_speedrun6/service/utilites.dart';
import 'package:ws54_flutter_speedrun6/widget/custom_text.dart';
import 'package:ws54_flutter_speedrun6/widget/text_button.dart';

import '../constant/style_guide.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.account, required this.password});
  final String account;
  final String password;
  @override
  State<StatefulWidget> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController username_controller;
  late TextEditingController birthday_controller;
  bool isUsernameValid = false;
  bool isBirthdayValid = false;
  @override
  void initState() {
    super.initState();
    username_controller = TextEditingController();
    birthday_controller = TextEditingController();
  }

  @override
  void dispose() {
    username_controller.dispose();
    birthday_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                customText("基本資料拉", 30, AppColor.black, true),
                const SizedBox(height: 20),
                customText("使用者名稱", 20, AppColor.black, false),
                const SizedBox(height: 20),
                usernameTextForm(),
                customText("生日", 20, AppColor.black, false),
                const SizedBox(height: 20),
                birthdayTextForm(),
                const SizedBox(height: 20),
                startButton()
              ],
            )),
      ),
    );
  }

  Widget startButton() {
    return appTextButton("開始", AppColor.black, 30, () async {
      if (isUsernameValid && isBirthdayValid) {
        String id = Utilites.randomID();
        await Auth.registerAuth(UserData(id, username_controller.text,
            widget.account, widget.password, birthday_controller.text));
        if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage(userID: id)));
        }
      } else {
        Utilites.showSnackBar(context, "我想睡覺:(");
      }
    });
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
        controller: birthday_controller,
        onTap: () async {
          DateTime? _picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2026));
          if (_picked != null) {
            isBirthdayValid = true;
            setState(() {
              birthday_controller.text = _picked.toString().split(" ")[0];
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
      title: const Text("即將完成註冊"),
      backgroundColor: AppColor.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
