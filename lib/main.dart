import 'package:flutter/material.dart';
import 'album_cover_list.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final HttpLink httpLink = HttpLink("http://127.0.0.1:8000/graphql/");

final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
  GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  ),
);

const String query = r'''
query{
  albumCovers{
    id
    Artist
    albumName
    coverUrl
    postedBy{
      username
    }
    votes{
      id
    }
  } 
}
''';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        title: 'Album Cover List',
        theme: ThemeData(primarySwatch: Colors.green

            /// Color.fromARGB(255, 4, 177, 82),

            ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text("Album Cover"),
            ),
            body: Query(
                options: QueryOptions(
                    document: gql(query),
                    variables: const <String, dynamic>{
                      "VariableName": "Value"
                    }),
                builder: ((result, {fetchMore, refetch}) {
                  if (result.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (result.data == null) {
                    return const Center(
                      child: Text("No data found"),
                    );
                  }
                  final albumCover = result.data!['albumCovers'];
                  return ListView.builder(
                    itemCount: albumCover.length,
                    itemBuilder: (context, index) {
                      final album = albumCover[index];
                      final artist = album['Artist'];
                      final albumName = album['albumName'];
                      final coverUrl = album['coverUrl'];
                      final postedBy = album['postedBy']['username'];
                      final votes = album['votes'].length;
                      return AlbumCoverList(
                        Artist: artist,
                        Album: albumName,
                        ImageUrl: coverUrl,
                        postedBy: postedBy,
                        votes: votes,
                      );
                    },
                  );
                }))),
      ),
    );
  }
}
