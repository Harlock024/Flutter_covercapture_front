// lib/screens/submit_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SubmitPage extends StatelessWidget {
  final TextEditingController _artistController = TextEditingController();
  final TextEditingController _albumNameController = TextEditingController();

  SubmitPage({super.key});

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<void> _sendMutationWithFetch() async {
    final authToken = await _getAuthToken();
    if (authToken != null) {
      const  url = 'http://34.174.244.94:8080/graphql/';
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'JWT $authToken',
      };
      final body = jsonEncode({
        'query': '''
          mutation CreateAlbumCover(\$artist: String!, \$albumName: String!) {
            createAlbumCover(Artist: \$artist, albumName: \$albumName) {
              id
              Artist
              albumName
            }
          }
        ''',
        'variables': {
          'artist': _artistController.text,
          'albumName': _albumNameController.text,
        },
      });

      final response = await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // ignore: avoid_print
        print('Mutation response: $jsonResponse');
        // Maneja la respuesta como necesites
      } else {
        // ignore: avoid_print
        print('Request failed with status: ${response.statusCode}');
        // ignore: avoid_print
        print('Error message: ${response.body}');
        // Maneja el error como necesites
      }
    } else {
      // Manejar caso donde no se puede obtener el authToken
      // ignore: avoid_print
      print('Error: No authToken available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Album'),
      ),
      body: Padding(
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
              onPressed: _sendMutationWithFetch,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

