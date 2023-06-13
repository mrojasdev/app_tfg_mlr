import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/mysql.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key, required this.user});

  final User user;

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  var db = Mysql();
  int totalPlacesGranada = 0;
  int userTotalPlacesGranada = 0;
  int userLorcaStories = 0;

  @override
  void initState() {
    super.initState();
    _fetchAchievementData();
  }

  Future<void> _fetchAchievementData() async {
    var conn = await db.getConnection();
    String sql = 'SELECT COUNT(city) FROM places WHERE city = "Granada";';
    var results = await conn.query(sql);
    for (var row in results) {
      int number = row[0];
      setState(() {
        totalPlacesGranada = number;
        print(number);
      });
    }
    conn.close();

    conn = await db.getConnection();
    sql =
        'SELECT COUNT(*) AS count FROM user_place up JOIN places p ON up.place_id = p.id JOIN users u ON up.username = u.username WHERE u.username = ? AND p.city = "Granada";';
    results = await conn.query(sql, [widget.user.username]);
    for (var row in results) {
      int number = row[0];
      setState(() {
        userTotalPlacesGranada = number;
        print(number);
      });
    }
    conn.close();
  }

  Future<void> _refreshAchievementData() async {
    await _fetchAchievementData();
  }

  double calculatePercentage() {
    if(totalPlacesGranada == 0){
      return 0.0;
    }else{
      return (userTotalPlacesGranada / totalPlacesGranada);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        onRefresh: _refreshAchievementData,
        color: Colors.black87,
        child: ListView(
          children: [
            _AchievementCard(
              title: "Cicerone de Granada",
              requirement: "Has descubierto todos los lugares de interés de Granada",
              image: 'assets/achievement1.png',
              userCompletion: userTotalPlacesGranada,
              completionNumber: totalPlacesGranada,
              completionPercentage: calculatePercentage(),
            ),
            _AchievementCard(
              title: "Ruta de Lorca",
              requirement: "Has descubierto los siete poemas de Lorca ocultos por Granada",
              image: 'assets/achievement2.png',
              userCompletion: userLorcaStories,
              completionNumber: 7,
              completionPercentage: 0,
            ),
          ],
        ),
      ),
    );
  }
}



class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    super.key, required this.title, required this.requirement, required this.image, required this.userCompletion, required this.completionNumber, required this.completionPercentage,
  });
  final String title;
  final String requirement;
  final String image;
  final int userCompletion;
  final int completionNumber;
  final double completionPercentage;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(
                  image,
                  width: 130,
                  height: 130,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      requirement,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      userCompletion.toString()+' / '+completionNumber.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: completionPercentage, // Set the value of the progress bar
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}