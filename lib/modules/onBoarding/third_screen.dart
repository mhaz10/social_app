import 'package:flutter/material.dart';

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/image_3.png'),
        SizedBox(height: 10,),
        Text('Login now to communicate with your friends',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 255, 199, 59),
                fontWeight: FontWeight.bold))
      ],
    );
  }
}



