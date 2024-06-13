import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../widgets/album_cover_list.dart';

class AlbumCoverPage extends StatelessWidget {
  const AlbumCoverPage({super.key});

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
              return AlbumCoverList(
                Artist: artist,
                Album: albumName,
                ImageUrl: coverUrl,
                postedBy: postedBy,
                votes: votes,
              );
            },
          );
        },
      ),
    );
  }
}
