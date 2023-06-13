import 'package:app_tfg_mlr/models/story.dart';
import 'package:flutter/material.dart';

class DetailsScreenStory extends StatelessWidget {

  final Story story;

  const DetailsScreenStory({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(story: story,),
          SliverList(
            delegate: SliverChildListDelegate([
              _StoryInfo(story: story,)
            ])
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar({super.key, required this.story});
  final Story story;

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
            story.title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87
            ),
          )
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading-gif.gif'),
          image: AssetImage('assets/story_background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _StoryInfo extends StatelessWidget {
  final Story story;
  const _StoryInfo({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            story.body.toString()
            ,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Autor: '+story.username
            ,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Encontrado en: '+story.latitude.toString()+', '+story.longitude.toString()
            ,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ],
    );
  }
}