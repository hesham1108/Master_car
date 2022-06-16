import 'package:flutter/material.dart';

class AppointCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final void Function()? onPress;
  const AppointCard(
      {Key? key,
      required this.title,
      required this.value,
      required this.icon,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Container(
      width: w * 0.96,
      height: h * 0.11,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xffd01f25),
          Color(0xff606060),
        ], begin: Alignment.topRight, end: Alignment.bottomLeft),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(value,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
            IconButton(
              onPressed: onPress,
              icon: Icon(icon, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
