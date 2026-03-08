import 'package:dspapp/timeslots.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  List<String> titles = [];
  List<String> locations = [];
  List<String> amenities = [];

  @override
  void initState() {
    super.initState();
    fetchSportComplexes(); // Fetch data when state is initialized
  }

  Future<void> fetchSportComplexes() async {
    // Fetch data from Firestore
    await FirebaseFirestore.instance
        .collection('sport complexes')
        .get()
        .then((QuerySnapshot querySnapshot) {
      print('Fetched ${querySnapshot.docs.length} documents.'); // Add this line
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('Document data: $data'); // Add this line
        setState(() {
          titles.add(data['name']);
          locations.add(data['location']); // Add location to the locations list
          Map<String, bool> amenitiesMap = Map.from(data['amenities']);
          amenities.add(amenitiesMap.entries
              .where((entry) => entry.value)
              .map((entry) => entry.key)
              .join(', '));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> cards = List.generate(titles.length, (index) {
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(212, 47, 110, 217).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  '' + titles[index], // Display the complex name
                  style: TextStyle(
                      color: const Color.fromARGB(246, 10, 0, 0), fontSize: 30),
                ),
              ),
              ListTile(
                title: Text(
                  'Location: ' + locations[index], // Display the location
                  style: TextStyle(
                      color: const Color.fromARGB(246, 10, 0, 0), fontSize: 30),
                ),
              ),
              ListTile(
                title: Text(
                  'Amenities:',
                  style: TextStyle(
                      color: Color.fromARGB(246, 10, 0, 0), fontSize: 30),
                ),
              ),
              ...amenities[index].split(', ').map((amenities) {
                return ListTile(
                  title: InkWell(
                    onTap: () {
                      // Navigate to a new page that shows the available time slots for the amenity
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TimeSlotsPage(
                                name: titles[index], amenities: amenities)),
                      );
                    },
                    child: Text(
                      amenities,
                      style: TextStyle(
                          color: const Color.fromARGB(246, 10, 0, 0),
                          fontSize: 20),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sport complexes available',
          style: TextStyle(color: Color.fromARGB(246, 10, 0, 0)),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: cards,
        ),
      ),
    );
  }
}
