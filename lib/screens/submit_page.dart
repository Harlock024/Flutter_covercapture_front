import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql_service.dart';

class SubmitPage extends StatelessWidget {
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _albumNameController = TextEditingController();

  final String addAlbumMutation = """
    mutation CreateAlbumCover(\$Artist: String!, \$albumName: String!) {
      createAlbumCover(Artist: \$Artist, albumName: \$albumName) {
        id
        Artist
        albumName
      }
    }
  """;

  SubmitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Mutation(
      options: MutationOptions(
        document: gql(addAlbumMutation),
      ),
      builder: (RunMutation runMutation, QueryResult? result) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _artistController,
                decoration: const InputDecoration(labelText: 'Artist'),
              ),
              TextField(
                controller: _albumNameController,
                decoration: const InputDecoration(labelText: 'Album Name'),
              ),
           const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  runMutation({
                    'Artist': _artistController.text,
                    'albumName': _albumNameController.text,
                  });
                },
                child:const Text('Submit'),
              ),
              if (result?.hasException ?? false) ...[
                Text(result!.exception.toString()),
              ] else if (result?.isLoading ?? false) ...[
               const CircularProgressIndicator(),
              ] else if (result?.data != null) ...[
               const Text("Album submitted successfully!"),
              ],
            ],
          ),
        );
      },
    );
  }
}

