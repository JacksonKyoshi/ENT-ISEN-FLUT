import 'package:ent/main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


void main() => runApp(LoginApp());

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Add your login logic here
                String username = _usernameController.text;
                String password = _passwordController.text;
                const url = 'https://api.isen-cyber.ovh/v1/token';

                final Map<String, String> data = {
                  'username': username,
                  'password': password,
                };

                // Conversion des données en JSON
                final jsonData = json.encode(data);

                try {
                  // Envoi de la requête POST
                  final response = await http.post(
                    Uri.parse(url),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonData,
                  );
                  // Vérification du code de statut de la réponse
                  if (response.statusCode == 200) {
                    final String token = response.body;
                    print("token : $token");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp(token,username)),
                    );

                    /*
                    final Map<String, dynamic> jsonResponse = json.decode(response.body);
                    final token = jsonResponse['token'];

                    // Utilisation du token comme nécessaire
                    print('Token: $token');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );*/


                  } else {
                    print('Erreur lors de la requête. Code de statut: ${response.statusCode}');
                  }
                } catch (e) {
                  print('Erreur lors de la requête: $e');
                }
              }
              ,
              child: Text('login'),
            ),
          ],
        ),
      ),
    );
  }
}
