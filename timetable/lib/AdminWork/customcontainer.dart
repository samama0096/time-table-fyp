import 'package:flutter/material.dart';

// ignore: camel_case_types, must_be_immutable
class customContainer extends StatelessWidget {
  customContainer({
    required this.subtitle,
    required this.text,
    required this.iimage,
    Key? key,
  }) : super(key: key);

  String text;
  String subtitle;
  final String iimage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 150,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 31, 85),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 4.0,
          ),
          Image.asset(
            iimage, // replace with your own Lottie animation file
            height: 90,
            width: 90,
          ),
          const SizedBox(
            height: 0.0,
          ),
          Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 3.0,
          ),
          FittedBox(
            child: Text(
              subtitle,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
