import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/album_cover_page.dart';
import 'screens/submit_page.dart';
 import 'screens/login_page.dart';
import 'screens/register_page.dart';


ValueNotifier<GraphQLClient>? client;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


 
  final HttpLink httpLink = HttpLink(
    "http://127.0.0.1:8000/graphql/",
  );

   final AuthLink authLink = AuthLink(getToken: () async {
    // Obtener el authToken de SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    return  authToken !=null ?'JWT $authToken':null;
  });

  final Link link = authLink.concat(httpLink);

  client = ValueNotifier<GraphQLClient>(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client!,
      child: MaterialApp(
        title: 'Album Cover App',
        theme: ThemeData(primarySwatch: Colors.grey),
        home: const MyHomePage(),
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
            const AlbumCoverPage(),
            const LoginPage(),
           const RegisterPage(),
          ],
        ),
      ),
    );
  }
}
