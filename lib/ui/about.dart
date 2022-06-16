import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:master_car_project/controller/about_controller.dart';
import 'package:master_car_project/helper_widgets/custom_screen.dart';
import 'package:master_car_project/ui/splash.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  const About({
    Key? key,
  }) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  Color r = const Color(0xffd01f25);
  Color bl = const Color(0xff2a2a2a);
  Color wh = const Color(0xfffcfcfc);
  Color gr = const Color(0xff606060);
  bool _isLoading = true;

  _lunchFacebook() async {
    var url = content[0]['facebook'];
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _lunchTwitter() async {
    var url = content[0]['twitter'];
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _lunchInstagram() async {
    var url = content[0]['instegram'];

    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _lunchLocation() async {
    var url = content[0]['location'];
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _lunchPhone() async {
    // var url = widget.content[0]['phone_num'];
    var url = 'tel:${content[0]['phone_num']}';
    var uri = Uri.parse(url);
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  dynamic content = [];
  Future<void> getContent() async {
    AboutController ab = AboutController();
    await ab.getAboutContent();
    if (ab.success) {
      content = ab.content;
      _isLoading = false;
      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: "حدث خطأ أثناء التحميل",
          backgroundColor: r,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);

      /// here
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    getContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return _isLoading
        ? const SafeArea(child: Splash())
        : CustomScreen(
            showNavigatorBar: true,
            img: "Logo",
            title: '',
            showAppBar: true,
            positionFromTop: h * 0.05,
            sizedBoxHeight: h * 0.05,
            heightOfRedPart: h * 0.15,
            appBarTitle: "من نحن",
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('معلومات عن المركز',
                                style: TextStyle(
                                    color: r,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            Html(data: content[0]['content'], style: {
                              'span': Style(
                                fontSize: const FontSize(20.0),
                              ),
                            })
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              _lunchPhone();
                            },
                            child: Row(children: [
                              Icon(Icons.phone_android_outlined,
                                  color: r, size: w * 0.1),
                              Text(
                                content[0]['phone'],
                                style: TextStyle(color: gr, fontSize: w * 0.05),
                              ),
                            ]),
                          ),
                          InkWell(
                            onTap: () {
                              _lunchLocation();
                            },
                            child: Row(children: [
                              Icon(Icons.location_on_outlined,
                                  color: r, size: w * 0.1),
                              Text(
                                content[0]['address'],
                                style: TextStyle(color: gr, fontSize: w * 0.05),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Row(
                    children: [
                      InkWell(
                        child: Image(
                            image:
                                const AssetImage('assets/images/Twitter.png'),
                            height: w * 0.12,
                            width: w * 0.12),
                        onTap: () {
                          _lunchTwitter();
                        },
                      ),
                      InkWell(
                        child: Image(
                            image:
                                const AssetImage('assets/images/Facebook.png'),
                            height: w * 0.12,
                            width: w * 0.12),
                        onTap: () {
                          _lunchFacebook();
                        },
                      ),
                      InkWell(
                        child: Image(
                            image:
                                const AssetImage('assets/images/instgram.png'),
                            height: w * 0.12,
                            width: w * 0.12),
                        onTap: () {
                          _lunchInstagram();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
