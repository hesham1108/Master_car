import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:master_car_project/controller/offers_controller.dart';
import 'package:master_car_project/helper_widgets/home/home_card.dart';
import 'package:master_car_project/ui/about.dart';
import 'package:master_car_project/ui/appointment.dart';

import 'package:master_car_project/ui/fixing_history.dart';
import 'package:master_car_project/ui/next_maintenance.dart';
import 'package:master_car_project/ui/notification_screen.dart';
import 'package:master_car_project/ui/splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controller/account_controller.dart';
import '../controller/all_app_controller.dart';
import '../controller/get_notification_controller.dart';

import '../controller/reservation_controller.dart';

import '../helper_widgets/home/timer.dart';
import 'offers.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color r = const Color(0xffd01f25);
  Color bg = const Color(0xfff6f6f6);
  Color gr = const Color(0xff606060);
  Color bl = const Color(0xff2a2a2a);
  bool _isLoading = false;
  dynamic userName, password;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic reservations = [];
  getReservations() async {
    ReservationsController r = ReservationsController();
    await r.getReservations(33);

    if (r.reservationProcess) {
      if (r.hasReservations) {
        setState(() {
          _isLoading = false;
          reservations = r.reservations;
        });
      }
    }
  }

  _lunchPhone() async {
    // var url = widget.content[0]['phone_num'];
    var url = 'tel:01099889394';
    var uri = Uri.parse(url);
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  // new
  _lunchWhats() async {
    String url;
    if (Platform.isAndroid) {
      // add the [https]
      url = "https://wa.me/+201096196217/?text=${Uri.parse('')}"; // new line
    } else {
      // add the [https]
      url =
          "https://api.whatsapp.com/send?phone=+201096196217=${Uri.parse('')}"; // new line
    }
    var uri = Uri.parse(url);
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  loginAlert(String nextPage) {
    AlertDialog alert = AlertDialog(
      title: Center(
        child: Text(
          'تسجيل الدخول',
          style: TextStyle(
            color: r,
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                controller: _usernameController,
                validator: (input) {
                  if (input!.isEmpty) {
                    return "من فضلك ادخل اسم المستخدم";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'اسم المستخدم',
                  border: OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: gr),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(
                    Icons.person,
                    color: r,
                  ),
                  prefixIconColor: r,
                ),
                cursorColor: gr,
                style: TextStyle(
                  color: gr,
                ),
              ),
              TextFormField(
                controller: _passwordController,
                validator: (input) {
                  if (input!.isEmpty) {
                    return "من فضلك ادخل كلمة المرور";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'كلمة المرور',
                  border: OutlineInputBorder(
                    // borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: gr),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: r,
                  ),
                  prefixIconColor: r,
                ),
                obscureText: true,
                cursorColor: gr,
                style: TextStyle(
                  color: gr,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.06),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        userName = _usernameController.text;
                        password = _passwordController.text;
                      });
                      Navigator.pop(context);
                      _usernameController.clear();
                      _passwordController.clear();

                      login(userName, password, nextPage);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: gr,
                  ),
                  child: const Text(
                    'دخول',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              // const SizedBox(
              //   width: 30,
              // ),

              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: r,
                  ),
                  child: const Text(
                    'الغاء',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  dynamic profileContent = [];
  login(String us, String pass, String nextPage) async {
    // setState(() {
    //   _isLoading = true;
    // });
    AccountController ac = AccountController();

    await ac.login(us, pass);

    if (ac.success) {
      profileContent = ac.content;

      SharedPreferences p = await SharedPreferences.getInstance();
      p.setString('master_car_username', us);
      p.setString('master_car_password', pass);

      /// here
      if (!mounted) return;
      context.read<LoggedController>().login();

      // setState(() {
      //   _isLoading = false;
      // });
      getReservations();
      switch (nextPage) {
        case ('appointment'):
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const Appointment()));
          break;
        case ('offers'):
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const Offers()));
          break;
        case ('fixing'):
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const FixingHistory()));
          break;

        case ('nextM'):
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const NextMaintenance()));
          break;
      }
    } else {
      Fluttertoast.showToast(
          msg: "  خطأ في اسم المستخدم او كلمة المرور اعد المحاولة مرة اخري",
          backgroundColor: r,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      _isLoading = false;
    });
  }

  bool visible = false;
  dynamic numberOfOffers;
  getCount() async {
    OffersController a = OffersController();
    await a.getCountOffers();
    if (a.offersNumSuccess) {
      visible = true;

      numberOfOffers = a.offersNum;
      setState(() {});
    } else {
      visible = false;
    }
  }

  logoutAlert() {
    AlertDialog alert = AlertDialog(
      title: Center(
          child: Text(
        "هل تريد تسجيل خروج؟",
        style: TextStyle(color: r),
      )),
      actions: [
        Padding(
          padding:
              EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.06),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  Navigator.pop(context);
                  var s = await SharedPreferences.getInstance();
                  Timer(const Duration(seconds: 2), () {
                    s.remove('master_car_username');
                    s.remove('master_car_password');
                  });

                  /// here
                  if (!mounted) return;
                  context.read<LoggedController>().logout();
                  // context.read<UserReservationController>().removeReservations();
                  setState(() {
                    reservations = [];
                    userName = '';
                    password = '';
                    _isLoading = false;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: gr,
                ),
                child: const Text('نعم', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: r,
                ),
                child: const Text('لا', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  loginForFirstTime(String u, String p) async {
    AccountController ac = AccountController();
    await ac.login(u, p);
    if (ac.success) {
      profileContent = ac.content;
      if (!mounted) return;
      context.read<LoggedController>().login();
      userName = u;
      password = p;
      await getReservations();
      setState(() {
        _isLoading = false;
      });
    }
  }

  check() async {
    setState(() {
      _isLoading = true;
    });
    var s = await SharedPreferences.getInstance();
    dynamic u, p;
    u = s.get('master_car_username');
    p = s.get('master_car_password');

    if ((u != null && p != null)) {
      loginForFirstTime(u, p);

      //context.read<UserReservationController>().getReservation(u, p);
    } else {
      /// here
      if (!mounted) return;
      context.read<LoggedController>().logout();
      setState(() {
        _isLoading = false;
      });
    }
  }

  dynamic numberOfNotifications;
  getNumberOfNotifications() async {
    GetNotificationController n = GetNotificationController();
    await n.getCountNotification();
    if (n.countSuccess) {
      numberOfNotifications = n.notNum;
      setState(() {});
    } else {
      numberOfNotifications = 0;
    }
  }

  whenStart() async {
    await check();
    await getCount();
    await getNumberOfNotifications();
    getReservations();
  }

  @override
  void initState() {
    whenStart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return _isLoading
        ? const SafeArea(child: Splash())
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: r,
            body: Column(
              children: [
                Container(
                  width: w,
                  height: h * 0.3,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/Banner_Bg.png'),
                          fit: BoxFit.fill)),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const NotificationScreen()));
                                },
                                icon: Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: w * 0.1,
                                ),
                              ),
                              Positioned(
                                  top: w * 0.01,
                                  right: w * 0.03,
                                  child: Stack(children: [
                                    CircleAvatar(
                                      backgroundColor: const Color(0xfffcbc04),
                                      radius: w * 0.02,
                                    ),
                                    Positioned(
                                        right: w * 0.01,
                                        bottom: w * 0.001,
                                        child: Center(
                                          child: Text(
                                            numberOfNotifications.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: w * 0.03),
                                          ),
                                        )),
                                  ])),
                            ]),
                          ),
                          Image.asset(
                            'assets/images/Element.png',
                            height: h * 0.3,
                            width: h * 0.25,
                          ),
                        ]),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: w,
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: h * 0.1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Consumer<LoggedState>(
                                      builder: (context, state, _) {
                                    return state.logged
                                        ? Column(children: [
                                            CircleAvatar(
                                                backgroundColor: gr,
                                                radius: 15,
                                                child: const Icon(Icons.person,
                                                    color: Colors.white)),
                                            Text(AccountController.userMobile,
                                                style: const TextStyle(
                                                    color: Colors.black)),
                                            InkWell(
                                              child: Text(
                                                'تسجيل خروج',
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: r),
                                              ),
                                              onTap: () {
                                                logoutAlert();
                                              },
                                            ),
                                          ])
                                        : const SizedBox(width: 0, height: 0);
                                  }),
                                  Image(
                                    image: const AssetImage(
                                        'assets/images/Logo.png'),
                                    width: w * 0.3,
                                    height: h * 0.1,
                                  )
                                ],
                              ),
                            ),
                          ),
                          HomeCard(
                              visible: false,
                              hint: '',
                              img: "Reservation_icon",
                              title: "حجز موعد الصيانة",
                              onPress: () async {
                                if (context
                                    .read<LoggedController>()
                                    .getLogged()) {
                                  var s = await SharedPreferences.getInstance();
                                  userName = s.get('master_car_username');
                                  password = s.get('master_car_password');
                                  login(userName, password, "appointment");
                                } else {
                                  loginAlert('appointment');
                                }
                              }),
                          HomeCard(
                              visible: true,
                              hint: (numberOfOffers ?? 0).toString(),
                              img: "Offers_icon",
                              title: "العروض وقطع الغيار",
                              onPress: () async {
                                if (context
                                    .read<LoggedController>()
                                    .getLogged()) {
                                  var s = await SharedPreferences.getInstance();
                                  userName = s.get('master_car_username');
                                  password = s.get('master_car_password');
                                  login(userName, password, "offers");
                                } else {
                                  loginAlert('offers');
                                }
                              }),
                          HomeCard(
                              visible: false,
                              hint: '',
                              img: "counter_icon",
                              title: "الصيانات السابقة",
                              onPress: () async {
                                if (context
                                    .read<LoggedController>()
                                    .getLogged()) {
                                  var s = await SharedPreferences.getInstance();
                                  userName = s.get('master_car_username');
                                  password = s.get('master_car_password');
                                  login(userName, password, "fixing");
                                } else {
                                  loginAlert('fixing');
                                }
                              }),
                          HomeCard(
                              hint: '',
                              img: 'Prevoius_icon',
                              title: 'الصيانات القادمة',
                              visible: false,
                              onPress: () async {
                                if (context
                                    .read<LoggedController>()
                                    .getLogged()) {
                                  var s = await SharedPreferences.getInstance();
                                  userName = s.get('master_car_username');
                                  password = s.get('master_car_password');
                                  login(userName, password, "nextM");
                                  setState(() {});
                                } else {
                                  loginAlert('nextM');
                                }
                              }),
                          HomeCard(
                              visible: false,
                              hint: '',
                              img: "About_icon",
                              title: "من نحن",
                              onPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const About()));
                              }),
                          Consumer<LoggedState>(
                            builder:
                                (BuildContext context, state, Widget? child) {
                              return state.logged && reservations.length > 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: w,
                                          height: h * 0.085,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: reservations.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: w * 0.05),
                                                child: AppointTimer(
                                                  // key: ValueKey(
                                                  //     reservations[index]['id']
                                                  //         .toString()),
                                                  w: w * 0.865,
                                                  reservations:
                                                      reservations[index],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(height: h * 0.04);
                            },
                          ),
                          SizedBox(height: h * 0.005),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _lunchWhats();
                                  },
                                  child: SizedBox(
                                    width: w * 0.45,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Icon(Icons.whatsapp,
                                              color: bl, size: w * 0.08),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'واتس و اتصال و حجز مواعيد',
                                              style: TextStyle(
                                                  fontSize: 14, color: bl),
                                            ),
                                            Text(
                                              '01096196217',
                                              style: TextStyle(
                                                  fontSize: 14, color: bl),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _lunchPhone();
                                  },
                                  child: SizedBox(
                                    width: w * 0.46,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Icon(Icons.phone,
                                              color: bl, size: w * 0.08),
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'للاستفسارات والشكاوى اتصال ',
                                              style: TextStyle(
                                                  fontSize: 13, color: bl),
                                            ),
                                            Text(
                                              '01099889394',
                                              style: TextStyle(
                                                  fontSize: 14, color: bl),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
