import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:ws54_flutter_speedrun6/constant/style_guide.dart';
import 'package:ws54_flutter_speedrun6/page/edit.dart';
import 'package:ws54_flutter_speedrun6/page/login.dart';
import 'package:ws54_flutter_speedrun6/page/user.dart';
import 'package:ws54_flutter_speedrun6/service/auth.dart';
import 'package:ws54_flutter_speedrun6/service/sql_service.dart';
import 'package:ws54_flutter_speedrun6/widget/text_button.dart';

import 'add.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userID});
  final String userID;
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List passwordList = [];
  late TextEditingController tag_controller;
  late TextEditingController url_controller;
  late TextEditingController login_controller;
  late TextEditingController password_controller;
  late TextEditingController id_controller;
  bool hasFav = false;
  int isFav = 1;
  bool isSearching = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setCurrentAllPasswordList();
    });
    super.initState();

    tag_controller = TextEditingController();
    url_controller = TextEditingController();
    login_controller = TextEditingController();
    password_controller = TextEditingController();
    id_controller = TextEditingController();
  }

  @override
  void dispose() {
    tag_controller.dispose();
    url_controller.dispose();
    login_controller.dispose();
    password_controller.dispose();
    id_controller.dispose();
    super.dispose();
  }

  Future<void> setCurrentAllPasswordList() async {
    List<PasswordData> datalist =
        await PasswordDAO.getPasswordDataListByUserID(widget.userID);
    setState(() {
      passwordList = datalist;
    });
    print("set all passwordlist :${passwordList.length}");
    isSearching = false;
  }

  Future<void> setPasswordListByCondition() async {
    isSearching = true;
    List<PasswordData> datalist =
        await PasswordDAO.getPasswordDataListByCondition(
            widget.userID,
            tag_controller.text,
            url_controller.text,
            login_controller.text,
            password_controller.text,
            id_controller.text,
            hasFav,
            isFav);
    setState(() {
      passwordList = datalist;
    });
    print("set all passwordlist by condition:${passwordList.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.black,
          child: const Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPage(userID: widget.userID)))),
      drawer: drawer(context),
      backgroundColor: AppColor.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60), child: topBar()),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: searchArea(),
                ),
                dataListViewBuilder(),
              ],
            )),
      ),
    );
  }

  Widget searchArea() {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.black, width: 2.0),
          borderRadius: BorderRadius.circular(45)),
      child: Column(
        children: [
          TextFormField(
            controller: tag_controller,
          ),
          TextFormField(
            controller: url_controller,
          ),
          TextFormField(
            controller: login_controller,
          ),
          TextFormField(
            controller: password_controller,
          ),
          TextFormField(
            controller: id_controller,
          ),
          Row(
            children: [
              Expanded(
                  child: CheckboxListTile(
                title: const Text("包含我的最愛"),
                value: (hasFav),
                onChanged: (value) => setState(() {
                  hasFav = !hasFav;
                }),
              )),
              Expanded(
                  child: CheckboxListTile(
                enabled: hasFav,
                title: const Text("我的最愛"),
                value: (isFav == 0 ? false : true),
                onChanged: (value) => setState(() {
                  isFav = isFav == 0 ? 1 : 0;
                }),
              ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              appTextButton(
                  "搜尋", AppColor.black, 20, () => setPasswordListByCondition()),
              appTextButton("清除設定", AppColor.black, 20, () {
                tag_controller.text = "";
                url_controller.text = "";
                login_controller.text = "";
                password_controller.text = "";
                id_controller.text = "";
                hasFav = false;
                isFav = 1;
              }),
              appTextButton("取消搜尋", AppColor.black, 20,
                  () => setCurrentAllPasswordList()),
            ],
          )
        ],
      ),
    );
  }

  Widget dataListViewBuilder() {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: passwordList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: dataContainer(context, passwordList[index]),
          );
        });
  }

  Widget dataContainer(BuildContext context, PasswordData data) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.black, width: 2.0),
        borderRadius: BorderRadius.circular(45),
      ),
      child: Column(children: [
        Text(data.tag),
        Text(data.url),
        Text(data.login),
        Text(data.password),
        Text(data.id),
        Row(
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    shape: const CircleBorder(
                        side: BorderSide(color: AppColor.red, width: 3.0)),
                    iconColor: data.isFav == 0 ? AppColor.red : AppColor.white,
                    backgroundColor:
                        data.isFav == 1 ? AppColor.red : AppColor.white),
                onPressed: () async {
                  setState(() {
                    data.isFav = data.isFav == 0 ? 1 : 0;
                  });
                  await PasswordDAO.updatePasswordData(data);
                },
                child: const Icon(Icons.favorite)),
            TextButton(
                style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    iconColor: AppColor.white,
                    backgroundColor: AppColor.green),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditPage(data: data)));
                },
                child: const Icon(Icons.edit)),
            TextButton(
                style: TextButton.styleFrom(
                    shape: const CircleBorder(),
                    iconColor: AppColor.white,
                    backgroundColor: AppColor.red),
                onPressed: () async {
                  await PasswordDAO.removePasswordData(data.id);
                  if (isSearching == false) {
                    setCurrentAllPasswordList();
                  } else {
                    setPasswordListByCondition();
                  }
                },
                child: const Icon(Icons.delete)),
          ],
        )
      ]),
    );
  }

  Widget drawer(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                  )),
              Image.asset(
                "assets/icon.png",
                width: 23,
                height: 23,
              )
            ],
          ),
          ListTile(
            title: const Text("主畫面"),
            leading: const Icon(Icons.home),
            onTap: () => Navigator.of(context).pop(),
          ),
          ListTile(
            title: const Text("帳號設置"),
            leading: const Icon(Icons.person),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => UserPage(userID: widget.userID)),
            ),
          ),
          logOutButton(context)
        ]),
      ),
    );
  }

  Widget logOutButton(BuildContext context) {
    return appTextButton("logout", AppColor.black, 25, () async {
      await Auth.logOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }

  Widget topBar() {
    return AppBar(
      title: const Text(
        "主畫面",
        style: TextStyle(color: AppColor.white),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColor.black,
    );
  }
}
