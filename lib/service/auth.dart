import 'package:ws54_flutter_speedrun6/service/sharedPref.dart';
import 'package:ws54_flutter_speedrun6/service/sql_service.dart';

class Auth {
  static Future<bool> loginAuth(String account, String password) async {
    try {
      UserData userData =
          await UserDAO.getUserDataByAccontAndPassword(account, password);
      await SharedPref.setLoggedUserID(userData.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> hasAccountBeenRegistered(String account) async {
    try {
      UserData userData = await UserDAO.getUserDataByAccount(account);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> registerAuth(UserData userData) async {
    await UserDAO.addUserData(userData);
    await SharedPref.setLoggedUserID(userData.id);
  }

  static Future<void> logOut() async {
    await SharedPref.removeLoggedUserID();
  }
}
