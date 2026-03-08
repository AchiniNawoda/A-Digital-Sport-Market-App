import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Owner extends StatefulWidget {
  @override
  _OwnerState createState() => _OwnerState();
}

class _OwnerState extends State<Owner> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  Map<String, bool> _amenities = {
    'Gym': false,
    'Swimming Pool': false,
    'Basketball': false,
    'Badminton': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Sports Complex'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              ..._amenities.keys.map((String key) {
                return CheckboxListTile(
                  title: Text(key),
                  value: _amenities[key],
                  onChanged: (bool? value) {
                    setState(() {
                      _amenities[key] = value!;
                    });
                  },
                );
              }).toList(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(212, 47, 110, 217),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Save the data
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance
                          .collection('sport complexes')
                          .doc(user.uid)
                          .set({
                        'name': _nameController.text,
                        'location': _locationController.text,
                        'amenities': _amenities,
                      });

                      // Create time slots for each amenity
                      _amenities.forEach((amenity, selected) async {
                        if (selected) {
                          for (int i = 8; i < 22; i += 2) {
                            String start = i < 10 ? '0$i:00' : '$i:00';
                            String end =
                                (i + 2) < 10 ? '0${i + 2}:00' : '${i + 2}:00';
                            String timeSlot = '$start - $end';
                            await FirebaseFirestore.instance
                                .collection('time slots')
                                .doc('k9wRwhYhziHIgHBGXZcA')
                                .collection(_nameController.text)
                                .doc(amenity)
                                .collection('slots')
                                .doc(timeSlot)
                                .set({'isAvailable': true});
                          }
                        }
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Submitted successfully!')),
                      );
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
