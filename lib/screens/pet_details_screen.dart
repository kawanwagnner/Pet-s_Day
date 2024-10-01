import 'package:flutter/material.dart';

class PetDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Details'),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset('assets/images/lucky_dog.png'),
            Text(
              'Lucky',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Male, 2 Years, 7kg'),
            Text('Owner: Hana'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Adopt Lucky'),
            ),
          ],
        ),
      ),
    );
  }
}
