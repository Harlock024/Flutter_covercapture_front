import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String registerMutation = """
    mutation CreateUser(\$username: String!, \$email: String!, \$password: String!) {
      createUser(username: \$username, email: \$email, password: \$password) {
        user {
          id
          username
          email
        }
      }
    }
  """;
  
  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: gql(registerMutation),
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
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
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
                    'email': _emailController.text,
                    'password': _passwordController.text,
                  });
                },
                child: const Text('Register'),
              ),
              if (result?.hasException ?? false) ...[
                Text(result!.exception.toString()),
              ] else if (result?.isLoading ?? false) ...[
               const CircularProgressIndicator(),
              ] else if (result?.data != null) ...[
              const  Text("User registered successfully!"),
                FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 2), () {
                    Navigator.pop(context);
                  }),
                  builder: (context, snapshot) {
                    return const Text("Redirecting...");
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}