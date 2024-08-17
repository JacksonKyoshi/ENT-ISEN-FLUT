import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';
import '../services/User_service.dart';
import '../services/token_service.dart';

void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0x00000000)
        )
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
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _remindOfMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              Text(
                  "Flut",
                  style: TextStyle(
                      fontSize: 42
                  )
              ),
              Text(
                  "ENT ISEN",
                  style: TextStyle(
                      fontSize: 42
                  )
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              Container( // form container
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 16, right: MediaQuery.of(context).size.width / 16
                    ),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _usernameController,
                          autocorrect: false,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person, size: 32),
                              labelText: "Identifiant",
                              labelStyle: TextStyle(color: Colors.grey),
                              floatingLabelStyle: TextStyle(color: Colors.purple, fontSize: 16),
                              hintText: "prenom.nom",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.purple
                                  )
                              )
                          ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 32),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _isPasswordHidden,
                        obscuringCharacter: "●",
                        autocorrect: false,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, size: 32),
                            suffixIcon: IconButton(
                                icon: Icon(_isPasswordHidden ? Icons.visibility : Icons.visibility_off, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordHidden = !_isPasswordHidden;
                                  });
                                },
                            ),
                            labelText: "Mot de passe",
                            labelStyle: TextStyle(color: Colors.grey),
                            floatingLabelStyle: TextStyle(color: Colors.purple, fontSize: 16),
                            hintText: "●●●●●●",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.purple
                                )
                            )
                        ),
                      ),
                      Row(
                        children: [
                          Text("Se souvenir de moi"),
                          Checkbox(value: _remindOfMe, onChanged: (changedState) {
                            setState(() {
                              _remindOfMe = changedState!;
                            });
                          })
                        ]
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            String username = _usernameController.text;
                            String password = _passwordController.text;
                            const url = 'https://api-ent.isenengineering.fr/v1/token';

                            final Map<String, String> data = {
                              'username': username,
                              'password': password,
                            };

                            try {
                              final jsonData = json.encode(data);
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
                                return showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    icon: Icon(Icons.error, color: Colors.red),
                                    title: Text("Erreur ${response.statusCode}\n${response.reasonPhrase}"),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text("Le serveur a rencontré une erreur et a renvoyé le message suivant :"),
                                          Text(response.body)
                                        ],
                                      )
                                    )
                                  );
                                });
                              }
                            } catch (e) {
                              debugPrint('Erreur lors de la requête: $e');
                            }
                        },
                        child: Text("Se connecter"))
                    ],
                  )
                )
              )
            ],
          )
        )
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,

        children: <Widget>[
          Icon(Icons.lightbulb, size: 64),
          const Text(
              "Mentions légales",
              style: TextStyle(
                decoration: TextDecoration.underline
              )),
          Icon(Icons.hardware, size: 64)
        ],
      ),
    );
  }
}
