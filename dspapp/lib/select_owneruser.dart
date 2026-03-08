import 'package:dspapp/User.dart';
import 'package:dspapp/owner.dart';
import 'package:dspapp/owner_home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectUserType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background2.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Spacer(), // Takes up remaining space at the top
              Text(
                'Select User Type',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 200), // You can adjust this value as needed
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(
                      212, 47, 110, 217), // This sets the color of the text
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OwnerHome()),
                  );
                },
                child: Text('Continue as Sport Complex Owner'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(
                      212, 47, 110, 217), // This sets the color of the text
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => User()),
                  );
                },
                child: Text('Continue as Normal User'),
              ),

              Spacer(), // Takes up remaining space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
