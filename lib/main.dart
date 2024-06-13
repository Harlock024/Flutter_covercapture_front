import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'screens/album_cover_page.dart';
import 'screens/submit_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'graphql_service.dart';  // Importa GraphQLService

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa el cliente GraphQL
  final client = ValueNotifier<GraphQLClient>(GraphQLService.client);

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Album Cover App',
          theme: ThemeData(primarySwatch: Colors.grey),
          home: const MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter App"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Submit'),
              Tab(text: 'Album Covers'),
              Tab(text: 'Login'),
              Tab(text: 'Register'),
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            SubmitPage(),
          const  AlbumCoverPage(),
          const LoginPage(),
          const  RegisterPage(),
          ],
        ),
      ),
    );
  }
}
