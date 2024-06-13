import 'package:flutter/material.dart';
  // ignore: non_constant_identifier_names

class AlbumCoverList extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final String Artist;
  // ignore: non_constant_identifier_names
  final String Album;
  // ignore: non_constant_identifier_names
  final String ImageUrl;
  final String postedBy;
  final int votes;

  const AlbumCoverList({
    Key? key,
     // ignore: non_constant_identifier_names
    required this.Artist,
      // ignore: non_constant_identifier_names
    required this.Album,  
    // ignore: non_constant_identifier_names
    required this.ImageUrl,
    required this.postedBy,
    required this.votes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
          ImageUrl,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
        Text(Artist),
        Text(Album),
        Text(postedBy),
        Text(votes.toString()),
      ],
    );
  }
}
