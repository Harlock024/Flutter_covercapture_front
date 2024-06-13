// lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String loginMutation = """
    mutation TokenAuth(\$username: String!, \$password: String!) {
      tokenAuth(username: \$username, password: \$password) {
        token
      }
    }
  """;

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: gql(loginMutation),
        onCompleted: (dynamic resultData) async {
          if (resultData != null) {
            final token = resultData['tokenAuth']['token'];
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('authToken', token);

            // Redirigir al usuario a la página principal
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          }
        },
      ),
      builder: (RunMutation runMutation, QueryResult? result) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  runMutation({
                    'username': _usernameController.text,
                    'password': _passwordController.text,
                  });
                },
                child: const Text('Login'),
              ),
              if (result?.hasException ?? false) ...[
                Text(result!.exception.toString()),
              ] else if (result?.isLoading ?? false) ...[
                const CircularProgressIndicator(),
              ] else if (result?.data != null) ...[
                const Text("Login successful!"),
              ],
            ],
          ),
        );
      },
    );
  }
}
