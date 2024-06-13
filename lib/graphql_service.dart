
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GraphQLService {
  static final HttpLink httpLink = HttpLink(
    'http://34.174.244.94:8080/graphql/',  // Reemplaza con tu endpoint GraphQL
  );

  static final AuthLink authLink = AuthLink(
    getToken: () async {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      return authToken != null ? 'Bearer $authToken' : null;
    },
  );

  static final Link link = authLink.concat(httpLink);

  static final GraphQLClient client = GraphQLClient(
    link: link,
    cache: GraphQLCache(),
  );
}
