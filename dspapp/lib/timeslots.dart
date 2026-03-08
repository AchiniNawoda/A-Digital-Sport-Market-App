import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeSlotsPage extends StatefulWidget {
  final String name;
  final String amenities;

  TimeSlotsPage({required this.name, required this.amenities});

  @override
  _TimeSlotsPageState createState() => _TimeSlotsPageState();
}

class _TimeSlotsPageState extends State<TimeSlotsPage> {
  late Stream<QuerySnapshot> timeSlots;

  @override
  void initState() {
    super.initState();
    timeSlots = FirebaseFirestore.instance
        .collection('time slots')
        .doc('k9wRwhYhziHIgHBGXZcA')
        .collection(widget.name)
        .doc(widget.amenities)
        .collection('slots')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.amenities} at ${widget.name}'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: timeSlots,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              // Check if the data is null before using it
              bool isAvailable = data['isAvailable'] ?? false;
              return ListTile(
                tileColor: isAvailable
                    ? Color.fromARGB(255, 255, 255, 255)
                    : Color.fromARGB(
                        212, 47, 110, 217), // Set color based on availability
                title: Text(isAvailable
                    ? 'Available: ' + document.id
                    : 'Unavailable: ' + document.id),
                onTap: isAvailable
                    ? () async {
                        await document.reference.update({'isAvailable': false});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'You booked the time slot successfully!')),
                        );
                      }
                    : null,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
