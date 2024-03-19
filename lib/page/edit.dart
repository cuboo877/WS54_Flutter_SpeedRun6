import 'package:flutter/material.dart';
import 'package:ws54_flutter_speedrun6/service/sql_service.dart';

import '../constant/style_guide.dart';
import '../service/utilites.dart';
import '../widget/custom_text.dart';
import '../widget/text_button.dart';
import 'home.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key, required this.data});
  final PasswordData data;
  @override
  State<StatefulWidget> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  late TextEditingController custom_controller;
  bool hasLower = true;
  bool hasUpper = true;
  bool hasNumber = true;
  bool hasSymbol = true;
  int length = 16;

  bool tagValid = true;
  bool urlValid = true;
  bool loginValid = true;
  bool passwordValid = true;
  @override
  void initState() {
    super.initState();
    tag_controller = TextEditingController(text: widget.data.tag);
    url_controller = TextEditingController(text: widget.data.url);
    login_controller = TextEditingController(text: widget.data.login);
    custom_controller = TextEditingController();
    password_controller = TextEditingController(text: widget.data.password);
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    custom_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  void setRandomPassword() {
    String result = Utilites.randomPassword(hasLower, hasUpper, hasSymbol,
        hasNumber, custom_controller.text, length);
    setState(() {
      password_controller.text = result;
    });
  }

  PasswordData packPasswordData() {
    return PasswordData(
        widget.data.id,
        widget.data.userID,
        tag_controller.text,
        url_controller.text,
        login_controller.text,
        password_controller.text,
        widget.data.isFav);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: topBar(context),
      ),
      body: SingleChildScrollView(
          child: SizedBox(
        width: double.infinity,
        child: Column(children: [
          const SizedBox(height: 20),
          customText("tag", 20, AppColor.black, false),
          const SizedBox(height: 20),
          tagTextForm(),
          const SizedBox(height: 20),
          customText("url", 20, AppColor.black, false),
          const SizedBox(height: 20),
          urlTextForm(),
          const SizedBox(height: 20),
          customText("login", 20, AppColor.black, false),
          const SizedBox(height: 20),
          loginTextForm(),
          const SizedBox(height: 20),
          customText("password", 20, AppColor.black, false),
          const SizedBox(height: 20),
          passwordTextForm(),
          const SizedBox(height: 20),
          randomPasswordSettingButton(context),
          const SizedBox(height: 20),
          favButton(),
          const SizedBox(height: 20),
          submitCreateButton(context)
        ]),
      )),
    );
  }

  Widget randomPasswordSettingButton(BuildContext context) {
    return appTextButton("隨機密碼設定", AppColor.black, 25, () async {
      showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(builder: ((context, setState) {
              return AlertDialog(
                title: Text("隨機密碼設定"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: custom_controller,
                    ),
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("包含小寫"),
                        value: (hasLower),
                        onChanged: (value) => setState(() {
                              hasLower = !hasLower;
                            })),
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("包含大寫"),
                        value: (hasUpper),
                        onChanged: (value) => setState(() {
                              hasUpper = !hasUpper;
                            })),
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("包含符號"),
                        value: (hasSymbol),
                        onChanged: (value) => setState(() {
                              hasSymbol = !hasSymbol;
                            })),
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text("包含數字"),
                        value: (hasNumber),
                        onChanged: (value) => setState(() {
                              hasNumber = !hasNumber;
                            })),
                    Row(
                      children: [
                        Slider(
                            min: 1,
                            max: 20,
                            divisions: 19,
                            value: (length.toDouble()),
                            onChanged: (value) => setState(() {
                                  length = value.toInt();
                                })),
                        Text(length.toString())
                      ],
                    )
                  ],
                ),
              );
            }));
          });
    });
  }

  Widget favButton() {
    return TextButton(
        style: TextButton.styleFrom(
            shape: const CircleBorder(
                side: BorderSide(color: AppColor.red, width: 3.0)),
            iconColor: widget.data.isFav == 0 ? AppColor.red : AppColor.white,
            backgroundColor:
                widget.data.isFav == 1 ? AppColor.red : AppColor.white),
        onPressed: () => setState(() {
              widget.data.isFav = widget.data.isFav == 0 ? 1 : 0;
            }),
        child: const Icon(Icons.favorite));
  }

  Widget submitCreateButton(BuildContext context) {
    return appTextButton("編輯完成", AppColor.black, 30, () async {
      if (tagValid && urlValid && loginValid && passwordValid) {
        await PasswordDAO.addPasswordData(packPasswordData());
        if (mounted) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(userID: widget.data.userID)));
          Utilites.showSnackBar(context, "已編輯");
        }
      } else {
        Utilites.showSnackBar(context, "瞎了嗎");
      }
    });
  }

  Widget tagTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: tag_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            tagValid = false;
            return "請輸入";
          } else {
            tagValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "tag",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(45))),
      ),
    );
  }

  Widget urlTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: url_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            urlValid = false;
            return "請輸入";
          } else {
            urlValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "url",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(45))),
      ),
    );
  }

  Widget loginTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: login_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            loginValid = false;
            return "請輸入";
          } else {
            loginValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: "login",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(45))),
      ),
    );
  }

  Widget passwordTextForm() {
    return SizedBox(
      width: 320,
      child: TextFormField(
        controller: password_controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            passwordValid = false;
            return "請輸入";
          } else {
            passwordValid = true;
            return null;
          }
        },
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(Icons.casino),
              onPressed: () => setRandomPassword(),
            ),
            hintText: "password",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(45))),
      ),
    );
  }

  Widget topBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        "編輯你他媽的密碼",
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
