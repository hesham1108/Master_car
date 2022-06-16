import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:master_car_project/ui/appointment.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/account_controller.dart';
import '../controller/all_app_controller.dart';

class CustomScreen extends StatefulWidget {
  final String img, title;
  final double? imgW, imgH;
  final double sizedBoxHeight;
  final double heightOfRedPart;
  final String appBarTitle;
  final bool showAppBar, showNavigatorBar;
  final double positionFromTop;
  final Widget child;

  const CustomScreen({
    Key? key,
    required this.img,
    required this.title,
    required this.sizedBoxHeight,
    required this.heightOfRedPart,
    required this.appBarTitle,
    required this.showAppBar,
    required this.positionFromTop,
    this.imgW,
    this.imgH,
    required this.showNavigatorBar,
    required this.child,
  }) : super(key: key);

  @override
  State<CustomScreen> createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  Color r = const Color(0xffd01f25);
  Color bl = const Color(0xff2a2a2a);
  Color wh = const Color(0xfffcfcfc);
  Color gr = const Color(0xff606060);
  bool isLoading = false;
  dynamic userName, password;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  loginAlert() {
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
                      setState(() {
                        isLoading = true;
                      });

                      login(
                        userName,
                        password,
                      );
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

  login(
    String userName,
    String password,
  ) async {
    setState(() {
      isLoading = true;
    });
    AccountController ac = AccountController();

    await ac.login(userName, password);

    if (ac.success) {
      SharedPreferences p = await SharedPreferences.getInstance();
      p.setString('master_car_username', userName);
      p.setString('master_car_password', password);

      /// here
      if (!mounted) return;
      context.read<LoggedController>().login();

      setState(() {
        isLoading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const Appointment()));
    } else {
      Fluttertoast.showToast(
          msg: "حدث خطأ اسم المستخدم او كلمة المرور",
          backgroundColor: r,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    // var h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff6f6f6),
      appBar: widget.showAppBar
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              elevation: 0,
              title: Text(
                widget.appBarTitle,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: r)
          : null,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: w,
                height: widget.heightOfRedPart,
                decoration: BoxDecoration(
                  color: r,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
              //SizedBox(height: widget.sizedBoxHeight),
              Expanded(
                child: Container(
                  width: w,
                  padding: EdgeInsets.only(top: widget.sizedBoxHeight),
                  color: const Color(0xfff0f3f3),
                  child: widget.child,
                  //decoration: BoxDecoration(color: Colors.green),
                ),
              ),
            ],
          ),
          Positioned(
            top: w * 0.1,
            right: w * 0.25,
            child: Text(widget.title,
                style: TextStyle(color: wh, fontSize: w * 0.09)),
          ),
          Positioned(
            top: widget.positionFromTop,
            right: w * 0.32,
            // w * 0.32
            child: CircleAvatar(
              radius: w * 0.19,
              backgroundColor: const Color(0xfff1f4f4),
              child: Image(
                image: AssetImage('assets/images/${widget.img}.png'),
                width: widget.imgW ?? w * 0.28,
                height: widget.imgH ?? w * 0.28,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.showNavigatorBar
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
              child: ElevatedButton(
                onPressed: () async {
                  // Navigator.pop(context);
                  var s = await SharedPreferences.getInstance();

                  userName = s.get('master_car_username');
                  password = s.get('master_car_password');

                  /// here
                  if (!mounted) return;
                  context.read<LoggedController>().getLogged()
                      ? login(
                          userName,
                          password,
                        )
                      : loginAlert();
                },
                style: ElevatedButton.styleFrom(primary: gr),
                child: const Text('احجز موعد', style: TextStyle(fontSize: 20)),
              ),
            )
          : null,
    );
  }
}
