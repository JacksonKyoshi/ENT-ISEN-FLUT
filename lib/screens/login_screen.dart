import 'package:ent/screens/mentions_legales_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import '../services/User_service.dart';
import '../services/token_service.dart';
import '../services/cache.dart';

void fetchJson(String username, String password, BuildContext context, TextEditingController usernameController, TextEditingController passwordController, bool remindOfMe) async {
  // Faire la requête
  const url = 'https://api-ent.isenengineering.fr/v1/token';

  final Map<String, String> data = {
    'username': username,
    'password': password,
  };
  final jsonData = json.encode(data);
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonData,
  );


  if (response.statusCode == 200) {
    TokenManager.getInstance().setToken(response.body);
    UserManager.getInstance().setUsername(username);

    if (context.mounted) { // Vérifiez si le widget est monté avant de naviguer
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  } else {
    debugPrint('Erreur lors de la requête. Code de statut: ${response.statusCode}\n${response.reasonPhrase}');

    usernameController.text = username;
    passwordController.text = password;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Icon(Icons.error, color: Colors.red),
          title: Text("Erreur ${response.statusCode}\n${response.reasonPhrase}"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Le serveur a rencontré une erreur et a renvoyé le message suivant :"),
                Text(response.body),
              ],
            ),
          ),
        );
      },
    );
  }
}




void main() async {

  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0x00000000),
        ),
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {



  @override
  void initState() {
    super.initState();

    readFromCache('login.cache').then((content) {
      if (content != null) {
        Map<String, dynamic> jsonMap = json.decode(content);
        String username = jsonMap['username'];
        String password = jsonMap['password'];
        setState(() {
          _remindOfMe = true; // Cocher automatiquement si des infos sont dans le cache
        });
        fetchJson(username, password, context, _usernameController, _passwordController, _remindOfMe);
      }
    });
  }
  bool _isPasswordHidden = true;
  bool _remindOfMe = false;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Flut\nENT ISEN",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
              ),
            ),
            Container(
              // form container
              child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 16,
                  right: MediaQuery.of(context).size.width / 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextFormField(
                      controller: _usernameController,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person, size: 48),
                        labelText: "Identifiant",
                        labelStyle: TextStyle(color: Colors.grey),
                        floatingLabelStyle: TextStyle(color: Colors.purple, fontSize: 20),
                        hintText: "prenom.nom",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 128),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isPasswordHidden,
                      obscuringCharacter: "●",
                      autocorrect: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock, size: 48),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordHidden ? Icons.visibility : Icons.visibility_off,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                        ),
                        labelText: "Mot de passe",
                        labelStyle: TextStyle(color: Colors.grey),
                        floatingLabelStyle: TextStyle(color: Colors.purple, fontSize: 20),
                        hintText: "●●●●●●",
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 128),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              const Text(
                                "Se souvenir de moi",
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 16,
                                ),
                              ),
                              Checkbox(
                                value: _remindOfMe,
                                activeColor: Colors.purple,
                                onChanged: (changedState) {
                                  setState(() {
                                    _remindOfMe = changedState!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String username = _usernameController.text;
                            String password = _passwordController.text;

                            if (_remindOfMe) {
                              final Map<String, String> data = {
                                'username': username,
                                'password': password,
                              };
                              final jsonData = json.encode(data);
                              await writeToCache('login.cache', jsonData);
                            } else {
                              deleteCacheFile('login.cache');
                            }

                            fetchJson(username, password, context, _usernameController, _passwordController, _remindOfMe);
                          },
                          child: Text(
                            "Se connecter",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 64),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          const Image(
            image: AssetImage('lib/assets/ISEN-Engineering-logo.png'),
            width: 72,
            height: 72,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MentionsLegalesScreen()));
            },
            child: const Text(
              "Mentions légales",
              style: TextStyle(
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const Image(
            image: AssetImage('lib/assets/ISEN-Repair-logo.png'),
            width: 64,
            height: 64,
          ),
        ],
      ),
    );
  }
}
