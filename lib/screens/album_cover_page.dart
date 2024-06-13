import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AlbumCoverPage extends StatelessWidget {
  const AlbumCoverPage({Key? key}) : super(key: key);

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> createVote(int albumCoverId) async {
    final authToken = await _getAuthToken();
    if (authToken != null) {
      const  url = 'http://127.0.0.1:8000/graphql/';
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'JWT $authToken',
      };
      final body = jsonEncode({
        'query': '''
          mutation CreateVote(\$albumCoverId: Int!) {
            createVote(albumCoverId: \$albumCoverId) {
              id
            }
          }
        ''',
        'variables': {
          'albumCoverId': albumCoverId,
        },
      });

      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // ignore: avoid_print
        print('Mutation response: $jsonResponse');
        // Handle the response as needed
      } else {
        // ignore: avoid_print
        print('Request failed with status: ${response.statusCode}');
                // ignore: avoid_print
        print('Error message: ${response.body}');
        // Handle the error as needed
      }
    } else {
              // ignore: avoid_print
      print('Error: No authToken available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Album Covers"),
      ),
      body: Query(
        options: QueryOptions(
          document: gql("""
            query {
              albumCovers {
                id
                Artist
                albumName
                coverUrl
                postedBy {
                  username
                }
                votes {
                  id
                }
              }
            }
          """),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (result.data == null) {
            return const Center(
              child: Text("No album covers found!"),
            );
          }
          final albumCovers = result.data!['albumCovers'];
          return ListView.builder(
            itemCount: albumCovers.length,
            itemBuilder: (context, index) {
              final album = albumCovers[index];
              final artist = album['Artist'];
              final albumName = album['albumName'];
              final coverUrl = album['coverUrl'];
              final postedBy = album['postedBy']['username'];
              final votes = album['votes'].length;
              final albumCoverId = album['id']; // Obtén el ID del álbum para la votación

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(coverUrl),
                  title: Text(albumName),
                  subtitle: Text('By $artist\nPosted by: $postedBy\nVotes: $votes'),
                  trailing: ElevatedButton(
                    onPressed: () => createVote(albumCoverId),
                    child: const Text('Vote'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
