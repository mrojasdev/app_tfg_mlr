import 'package:app_tfg_mlr/models/place.dart';
import 'package:app_tfg_mlr/screens/details_screen.dart';
import 'package:flutter/material.dart';

import '../models/story.dart';
import '../models/user.dart';
import '../services/mysql.dart';
import 'details_screen_story.dart';

class StoriesCollectedScreen extends StatefulWidget {
  const StoriesCollectedScreen({super.key, required this.user});

  final User user;

  @override
  State<StoriesCollectedScreen> createState() => _StoriesCollectedScreenState();
}

class _StoriesCollectedScreenState extends State<StoriesCollectedScreen> {
  var db = Mysql();
  List<Story> storyList = [];

  _getStoryInfo() {
    List<Story> storiesList = [];
    db.getConnection().then((conn) {
      String sql = 'SELECT s.* FROM stories s INNER JOIN user_story us ON s.id = us.story_id INNER JOIN users u ON us.username = u.username WHERE u.username = ?;';
      conn.query(sql, [widget.user.username]).then((results){
        for(var row in results){
          storiesList.add(
            Story(id: row[0], latitude: row[1], longitude: row[2], radius: row[3], title: row[4], detail: row[5], body: row[6].toString(), views: row[7], likes: row[8], username: row[9])
          );
          setState(() {
            storyList = storiesList;
          });
        }
      }).whenComplete(() => conn.close());
    });
  }

  Future<void> _refreshStoryInfo() async{
    List<Story> storiesList = [];
    db.getConnection().then((conn) {
      String sql = 'SELECT s.* FROM stories s INNER JOIN user_story us ON s.id = us.story_id INNER JOIN users u ON us.username = u.username WHERE u.username = ?;';
      conn.query(sql, [widget.user.username]).then((results){
        for(var row in results){
          storiesList.add(
            Story(id: row[0], latitude: row[1], longitude: row[2], radius: row[3], title: row[4], detail: row[5], body: row[6].toString(), views: row[7], likes: row[8], username: row[9])
          );
          setState(() {
            storyList = storiesList;
          });
        }
      }).whenComplete(() => conn.close());
    });
  }
  


  @override
  Widget build(BuildContext context) {
    _getStoryInfo();
    return Container(
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        child: RefreshIndicator(
          color: Colors.black87,
          onRefresh: () => _refreshStoryInfo(),
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
                            Text(
                            story.title,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black87,
                              fontSize: 24,
                              fontFamily: 'KaushanScript',
                            ),
                          ),
                          Ink.image(
                            image: AssetImage('assets/story_background.jpg'),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreenStory(story: story)));
                              },
                            ),
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          ),
        ),
      ),
      
    );
  }
}


