import 'package:flutter/material.dart';

class AlbumCoverList extends StatelessWidget {
  final String Artist;
  final String Album;
  final String ImageUrl;
  final String postedBy;
  final int votes;

  const AlbumCoverList({
    Key? key,
    required this.Artist,
    required this.Album,
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
