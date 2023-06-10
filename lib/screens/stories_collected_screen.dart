import 'package:app_tfg_mlr/models/place.dart';
import 'package:app_tfg_mlr/screens/details_screen.dart';
import 'package:flutter/material.dart';

import '../models/story.dart';
import '../services/mysql.dart';
import 'details_screen_story.dart';

class StoriesCollectedScreen extends StatefulWidget {
  const StoriesCollectedScreen({super.key});

  @override
  State<StoriesCollectedScreen> createState() => _StoriesCollectedScreenState();
}

class _StoriesCollectedScreenState extends State<StoriesCollectedScreen> {
  var db = Mysql();
  List<Story> storyList = [];

  _getStoryInfo() {
    List<Story> storiesList = [];
    db.getConnection().then((conn) {
      String sql = 'select * from stories;';
      conn.query(sql).then((results){
        for(var row in results){
          storiesList.add(
            Story(id: row[0], latitude: row[1], longitude: row[2], radius: row[3], title: row[4], detail: row[5], body: row[6].toString(), views: row[7], likes: row[8], username: row[9])
          );
          setState(() {
            storyList = storiesList;
          });
          print(storiesList[0].body);
        }
      });
      conn.close();
    });
  }
  


  @override
  Widget build(BuildContext context) {
    _getStoryInfo();
    return Container(
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        child: ListView.builder(
          itemCount: storyList.length,
          itemBuilder: (BuildContext context, int index){
            final story = storyList[index];
            return Container(
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Ink.image(
                          image: AssetImage('assets/story_background.jpg'),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreenStory(story: story)));
                            },
                          ),
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          story.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
      
    );
  }
}


