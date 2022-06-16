import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String img;
  final String title;
  final Function()? onPress;
  final String hint;
  final bool visible;
  const HomeCard(
      {Key? key,
      required this.img,
      required this.title,
      required this.onPress,
      required this.hint,
      required this.visible})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    Color r = const Color(0xffd01f25);
    // Color bg = Color(0xfff6f6f6);
    Color gr = const Color(0xff606060);
    return InkWell(
      onTap: onPress,
      child: SizedBox(
        width: w * 0.9,
        height: h * 0.083,
        child: Card(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // if you need this
            side: BorderSide(
              color: r,
              width: 1,
            ),
          ),
          child: Row(children: [
            SizedBox(
              width: w * 0.03,
            ),
            Image(
              image: AssetImage('assets/images/$img.png'),
              width: w * 0.08,
              height: h * 0.08,
            ),
            SizedBox(
              width: w * 0.04,
            ),
            Text(
              title,
              style: TextStyle(color: gr, fontSize: w * 0.05),
            ),
            SizedBox(width: w * 0.2),
            if (visible)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      hint,
                      style: TextStyle(color: r, fontSize: w * 0.03),
                    ),
                    Text(
                      "جديد",
                      style: TextStyle(color: r, fontSize: w * 0.03),
                    ),
                  ],
                ),
              )
          ]),
        ),
      ),
    );
  }
}
