import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class sql {
  static Database? database;
  static Future<Database> _initDatabase() async {
    database = await openDatabase(join(await getDatabasesPath(), "ws54.db"),
        onCreate: (db, version) async {
      await db.execute(
          "create table users (id text primary key, username text, account text, password text, birthday text)");
      await db.execute(
          "create table passwords (id text primary key, userID text, tag text, url text, login text, password, text, isFav integer, foreign key (userID) references users (id))");
    }, version: 1);
    return database!;
  }

  static Future<Database> _getDBConnect() async {
    if (database != null) {
      return database!;
    } else {
      return await _initDatabase();
    }
  }
}

class UserDAO {
  static Future<UserData> getUserDataByUserID(String userID) async {
    final Database database = await sql._getDBConnect();
    List<Map<String, dynamic>> maps =
        await database.query("users", where: "id = ?", whereArgs: [userID]);
    Map<String, dynamic> result = maps.first;
    return UserData(result["id"], result["username"], result["account"],
        result["password"], result["birthday"]);
  }

  static Future<UserData> getUserDataByAccount(String account) async {
    final Database database = await sql._getDBConnect();
    List<Map<String, dynamic>> maps = await database
        .query("users", where: "account = ?", whereArgs: [account]);
    Map<String, dynamic> result = maps.first;
    return UserData(result["id"], result["username"], result["account"],
        result["password"], result["birthday"]);
  }

  static Future<UserData> getUserDataByAccontAndPassword(
      String account, String password) async {
    final Database database = await sql._getDBConnect();
    List<Map<String, dynamic>> maps = await database.query("users",
        where: "account = ? AND password = ?", whereArgs: [account, password]);
    Map<String, dynamic> result = maps.first;
    return UserData(result["id"], result["username"], result["account"],
        result["password"], result["birthday"]);
  }

  static Future<void> addUserData(UserData userData) async {
    final Database database = await sql._getDBConnect();
    await database.insert("users", userData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updateUserData(UserData userData) async {
    final Database database = await sql._getDBConnect();
    await database.update("users", userData.toJson(),
        where: "id = ?",
        whereArgs: [userData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> removeUserData(String userID) async {
    final Database database = await sql._getDBConnect();
    await database.delete(
      "users",
      where: "id = ?",
      whereArgs: [userID],
    );
  }
}

class PasswordDAO {
  static Future<List<PasswordData>> getPasswordDataListByUserID(
      String userID) async {
    final Database database = await sql._getDBConnect();
    List<Map<String, dynamic>> maps = await database
        .query("passwords", where: "userID = ?", whereArgs: [userID]);
    return List.generate(maps.length, (index) {
      return PasswordData(
          maps[index]["id"],
          maps[index]["userID"],
          maps[index]["tag"],
          maps[index]["url"],
          maps[index]["login"],
          maps[index]["password"],
          maps[index]["isFav"]);
    });
  }

  static Future<List<PasswordData>> getPasswordDataListByCondition(
      String userID,
      String tag,
      String url,
      String login,
      String password,
      String id,
      bool hasFav,
      int isFav) async {
    final Database database = await sql._getDBConnect();

    String whereCondition = "userID = ?";
    List whereArgs = [userID];

    if (tag.trim().isNotEmpty) {
      whereCondition += "AND tag LIKE ?";
      whereArgs.add("%$tag%");
    }
    if (url.trim().isNotEmpty) {
      whereCondition += "AND url LIKE ?";
      whereArgs.add("%$url%");
    }
    if (login.trim().isNotEmpty) {
      whereCondition += "AND login LIKE ?";
      whereArgs.add("%$login%");
    }
    if (password.trim().isNotEmpty) {
      whereCondition += "AND password LIKE ?";
      whereArgs.add("%$password%");
    }
    if (id.trim().isNotEmpty) {
      whereCondition += "AND id LIKE ?";
      whereArgs.add("%$id%");
    }
    if (hasFav) {
      whereCondition += "AND isFav = ?";
      whereArgs.add(isFav);
    }

    List<Map<String, dynamic>> maps = await database.query("passwords",
        where: whereCondition, whereArgs: whereArgs);
    return List.generate(maps.length, (index) {
      return PasswordData(
          maps[index]["id"],
          maps[index]["userID"],
          maps[index]["tag"],
          maps[index]["url"],
          maps[index]["login"],
          maps[index]["password"],
          maps[index]["isFav"]);
    });
  }

  static Future<void> addPasswordData(PasswordData passwordData) async {
    final Database database = await sql._getDBConnect();
    await database.insert("passwords", passwordData.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> updatePasswordData(PasswordData passwordData) async {
    final Database database = await sql._getDBConnect();
    await database.update("passwords", passwordData.toJson(),
        where: "id = ?",
        whereArgs: [passwordData.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> removePasswordData(String passwordID) async {
    final Database database = await sql._getDBConnect();
    await database.delete(
      "passwords",
      where: "id = ?",
      whereArgs: [passwordID],
    );
  }
}

class UserData {
  final String id;
  late String username;
  late String account;
  late String password;
  late String birthday;

  UserData(this.id, this.username, this.account, this.password, this.birthday);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "account": account,
      "password": password,
      "birthday": birthday,
    };
  }
}

class PasswordData {
  final String id;
  final String userID;
  late String tag;
  late String url;
  late String login;
  late String password;
  late int isFav;
  PasswordData(
    this.id,
    this.userID,
    this.tag,
    this.url,
    this.login,
    this.password,
    this.isFav,
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userID": userID,
      "tag": tag,
      "url": url,
      "login": login,
      "password": password,
      "isFav": isFav
    };
  }
}
