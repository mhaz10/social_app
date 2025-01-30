import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/image_2.png'),
        SizedBox(height: 10,),
        Text('Connect with your friends \n from all over the world',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 255, 199, 59),
                fontWeight: FontWeight.bold))
      ],
    );
  }
}



