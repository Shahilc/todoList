import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Builduserimage extends StatelessWidget {
  const Builduserimage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            child: const Image(
              image: AssetImage('assets/images/userImage.png'),
            ),
          ),
        ],
      ),
    );
  }
}
