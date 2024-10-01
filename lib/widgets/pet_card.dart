import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String petName;

  PetCard({required this.petName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/petDetails');
      },
      child: Card(
        child: ListTile(
          leading: Image.asset('assets/images/pet_placeholder.png'),
          title: Text(petName),
          subtitle: Text('2 Years, 7kg'),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
