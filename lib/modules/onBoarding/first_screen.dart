import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/image_1.png'),
        SizedBox(height: 10,),
        Text('Enjoy every moment \n with your friends',
            textAlign: TextAlign.center,
            style: TextStyle(
            fontSize: 25,
            color: Color.fromARGB(255, 255, 199, 59),
            fontWeight: FontWeight.bold))
      ],
    );
  }
}



