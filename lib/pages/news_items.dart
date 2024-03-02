//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewsItems extends StatefulWidget {
  final String name;
  final String detail;
  final String news_public;
  final String news_key;
  final String news_cover;

  const NewsItems(
      {Key? key,
      required this.name,
      required this.detail,
      required this.news_public,
      required this.news_key,
      required this.news_cover})
      : super(key: key);

  @override
  State<NewsItems> createState() => _NewsItemsState();
}

class _NewsItemsState extends State<NewsItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage((widget.news_cover)),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
