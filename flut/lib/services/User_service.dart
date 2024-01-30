
//Classe qui va gérer le username
class UserManager {
  static UserManager _instance = UserManager._internal();
  late String _username;
  UserManager._internal();


  static UserManager getInstance() {
    return _instance;
  }

  void setToken(String token) { //setter
    _username = token;
  }


  String getToken() { //getter
    return _username;
  }
}

