
//Classe qui va gérer le token
class TokenManager {
  static TokenManager _instance = TokenManager._internal();
  late String _token;
  TokenManager._internal();


  static TokenManager getInstance() {
    return _instance;
  }

  void setToken(String token) { //setter
    _token = token;
  }


  String getToken() { //getter
    return _token;
  }
}

