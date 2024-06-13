import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/album_cover_page.dart';
import 'screens/submit_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'graphql_service.dart'; // Asegúrate de importar GraphQLService

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtener el authToken desde SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final authToken = prefs.getString('authToken');

  runApp(MyApp(authToken: authToken));
}


class MyApp extends StatelessWidget {
  final String? authToken;

  const MyApp({Key? key, this.authToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = ValueNotifier<GraphQLClient>(GraphQLService.client);

    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Album Cover App',
          theme: ThemeData(primarySwatch: Colors.grey),
          home: MyHomePage(authToken: authToken),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String? authToken;

  const MyHomePage({Key? key, this.authToken}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("CoverCapture"),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Submit'),
              Tab(text: 'Album Covers'),
              Tab(text: 'Login'),
              Tab(text: 'Register'),
            ],
          ),
          actions: [
            if (authToken != null)
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('authToken');
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
          ],
        ),
        body: TabBarView(
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
