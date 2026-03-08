import 'package:dspapp/owner.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class OwnerHome extends StatefulWidget {
  @override
  _OwnerHomeState createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  User? user;
  Map<String, dynamic>? sportsComplexData;

  @override
  void initState() {
    super.initState();
    fetchSportsComplexData();
  }

  Future<void> fetchSportsComplexData() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('sport complexes')
          .doc(user!.uid)
          .get();
      if (docSnapshot.exists) {
        setState(() {
          sportsComplexData = docSnapshot.data() as Map<String, dynamic>?;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Sport Complex details'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                color: const Color.fromARGB(212, 47, 110, 217),
              ),
            ),
            ListTile(
              title: Text('Update Sport Complex details'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Owner()),
                );
              },
            ),
            ListTile(
              title: Text('Current Sport Complex details'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: sportsComplexData == null
          ? Center(child: Text('Register your sports complex'))
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 400.0, // specify the height
                width: 400.0, // specify the width
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(212, 47, 110, 217)
                          .withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      ' ${sportsComplexData!['name']}',
                      style: GoogleFonts.lato(
                        // replace 'lato' with your preferred font
                        fontSize: 50.0,
                        // replace with your preferred font size
                        color:
                            Colors.black, // replace with your preferred color
                        fontWeight: FontWeight.bold,
                        // replace with your preferred font weight
                      ),
                    ),
                    Text(
                      ' ${sportsComplexData!['location']}',
                      style: GoogleFonts.lato(
                        // replace 'lato' with your preferred font
                        fontSize: 30.0, // replace with your preferred font size
                        color:
                            Colors.black, // replace with your preferred color
                        fontWeight: FontWeight
                            .bold, // replace with your preferred font weight
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    ...(sportsComplexData!['amenities']
                            ?.entries
                            .where((entry) => entry.value == true)
                            .map((entry) => Text(
                                  ' ${entry.key}',
                                  style: GoogleFonts.lato(
                                    // replace 'lato' with your preferred font
                                    fontSize:
                                        20.0, // replace with your preferred font size
                                    color: Colors
                                        .black, // replace with your preferred color
                                    fontWeight: FontWeight
                                        .bold, // replace with your preferred font weight
                                  ),
                                ))
                            .toList() ??
                        []),
                  ],
                ),
              ),
            ),
    );
  }
}
