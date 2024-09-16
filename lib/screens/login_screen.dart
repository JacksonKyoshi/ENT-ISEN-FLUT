import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import '../services/User_service.dart';
import '../services/token_service.dart';
import '../services/Cache.dart';

void fetchJson(String username, String password, BuildContext context) async {
  // Faire la requête
  const url = 'https://api-ent.isenengineering.fr/v1/token';

  final Map<String, String> data = {
    'username': username,
    'password': password,
  };
  final jsonData = json.encode(data);
  debugPrint("data : $jsonData");
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonData,
  );

  if (response.statusCode == 200) {
    TokenManager.getInstance().setToken(response.body);
    UserManager.getInstance().setUsername(username);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  } else {
    debugPrint('Erreur lors de la requête. Code de statut: ${response.statusCode}\n${response.reasonPhrase}');
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

    // Lecture du cache
    readFromCache('cacheIsenFlut.txt').then((content) {
      if (content != null) {
        debugPrint('\n\n\n\n\n\n\n\nContenu lu du cache : $content\n\n\n\n');
        Map<String, dynamic> jsonMap = json.decode(content);
        String username = jsonMap['username'];
        String password = jsonMap['password'];
        fetchJson(username, password, context);
      } else {
        debugPrint('Aucun contenu trouvé.');
      }
    });
  }

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _remindOfMe = false;

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
                                    if (_remindOfMe) {
                                      // Écrire dans le cache
                                      String username = _usernameController.text;
                                      String password = _passwordController.text;
                                      final data = json.encode({
                                        'username': username,
                                        'password': password,
                                      });
                                      writeToCache('cacheIsenFlut.txt', data);
                                    }
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

                            final Map<String, String> data = {
                              'username': username,
                              'password': password,
                            };

                            try {
                              final jsonData = json.encode(data);
                              if (_remindOfMe) {
                                await writeToCache('cacheIsenFlut.txt', jsonData);
                              }
                              final response = await http.post(
                                Uri.parse('https://api-ent.isenengineering.fr/v1/token'),
                                headers: {'Content-Type': 'application/json'},
                                body: jsonData,
                              );

                              if (response.statusCode == 200) {
                                TokenManager.getInstance().setToken(response.body);
                                UserManager.getInstance().setUsername(username);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyApp()),
                                );
                              } else {
                                debugPrint('Erreur lors de la requête. Code de statut: ${response.statusCode}\n${response.reasonPhrase}');
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
                            } catch (e) {
                              debugPrint('Erreur lors de la requête: $e');
                            }
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
              // TODO: add Mentions légales screen
              debugPrint("Mentions légales pressed");
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
