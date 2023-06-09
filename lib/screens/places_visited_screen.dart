import 'package:flutter/material.dart';

class PlacesVisitedScreen extends StatelessWidget {
  const PlacesVisitedScreen({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index){
            //final place = places[index]; // TODO: Change the variable to the list of places retrieved from the database
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
                          image: NetworkImage(
                            'https://www.hotelgranadaarabeluj.com/wp-content/uploads/2018/08/visitar-la-alhambra.jpg'
                          ),
                          child: InkWell(
                            onTap: () {},
                          ),
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          'Alhambra de Granada',
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
