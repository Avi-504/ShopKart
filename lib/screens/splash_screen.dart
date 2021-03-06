import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image.network(
            'https://i.ibb.co/gt7Bctk/sk.jpg',
            height: 200,
            width: 200,
            fit: BoxFit.cover,
          ),
          Text('Loading....'),
        ],
      ),
    ));
  }
}
