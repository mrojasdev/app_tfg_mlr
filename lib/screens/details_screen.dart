import 'package:flutter/material.dart';

import '../models/place.dart';

class DetailsScreen extends StatelessWidget {

  final Place place;

  const DetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(place: place,),
          SliverList(
            delegate: SliverChildListDelegate([
              _PlaceInfo(place: place,)
            ])
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({super.key, required this.place});
  final Place place;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      snap: false,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          color: Colors.black26,
          child: Text(
            place.title
            ,
            style: TextStyle(fontSize: 16),
          )
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading-gif.gif'),
          image: NetworkImage(place.image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PlaceInfo extends StatelessWidget {
  final Place place;
  const _PlaceInfo({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        place.body.toString()
        ,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}