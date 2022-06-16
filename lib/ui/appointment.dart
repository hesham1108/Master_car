import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:master_car_project/controller/account_controller.dart';
import 'package:master_car_project/controller/appointment_controller.dart';

import 'package:master_car_project/helper_widgets/custom_screen.dart';
import 'package:master_car_project/ui/confirm.dart';
import 'package:master_car_project/ui/splash.dart';

class Appointment extends StatefulWidget {
  const Appointment({
    Key? key,
  }) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  bool _isLoading = true;
  bool visible = true;

  Color r = const Color(0xffd01f25);
  Color gr = const Color(0xe4595959);
  final double paddingForAlertCards = 20.0;
  String date = '';
  bool isEmpty = true;
  dynamic times = [];

  getTimes(String date) async {
    AppointmentController apc = AppointmentController();

    await apc.availableTimes(date);
    if (apc.timesSuccess) {
      if (apc.emptyList) {
        _isLoading = false;
        isEmpty = true;
        setState(() {});
      } else {
        setState(() {
          isEmpty = false;
          _isLoading = false;
          times = apc.times;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      /// here
      if (!mounted) return;
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "حدث خطأ !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100, 10));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        visible = false;
      });

      setState(() {
        _isLoading = true;
      });
      getTimes(convertDate(selectedDate.toString().split(' ')[0]));
    }
    setState(() {
      _isLoading = false;
    });
  }

  String convertDate(String d) {
    List<String> numbers = d.split('-');
    return '${numbers[2]}/${numbers[1]}/${numbers[0]}';
  }

  dynamic content;
  sendAppointment(String date, int id, String time) async {
    setState(() {
      _isLoading = true;
    });
    AppointmentController ac = AppointmentController();
    await ac.reservation(id, date, time);
    if (ac.reservationSuccess) {
      content = ac.content;
      if (content['status'] == "true") {
        setState(() {
          _isLoading = false;
        });

        /// here
        if (!mounted) return;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => ConfirmScreen(
                      date: date,
                      lastPageAppointment: true,
                    )));
      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(
            msg: content['message'].toString(),
            backgroundColor: r,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "حدث خطأ حاول مرة اخرى",
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

  confirmAlert(int customerId, String date, String time) {
    AlertDialog alert = AlertDialog(
      title: Center(
          child: Text(
        "هل تريد تاكيد الحجز؟",
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
                onPressed: () {
                  Navigator.pop(context);
                  sendAppointment(date, customerId, time);
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

  @override
  void initState() {
    getTimes(convertDate(selectedDate.toString().split(' ')[0]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return _isLoading
        ? const Splash()
        : CustomScreen(
            img: 'Appiontment',
            title: '',
            sizedBoxHeight: h * 0.1,
            heightOfRedPart: h * 0.15,
            appBarTitle: 'حجز موعد صيانة',
            showAppBar: true,
            positionFromTop: h * 0.05,
            showNavigatorBar: false,
            imgH: w * 0.24,
            imgW: w * 0.24,
            child: Container(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      width: w * 0.8,
                      height: h * 0.08,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: r),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: visible
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                    // Text(
                                    //   'اختر موعد الحجز',
                                    //   style: TextStyle(fontSize: 25, color: gr),
                                    // ),
                                    Text(
                                      DateTime.now().toString().split(' ')[0],
                                      style: TextStyle(fontSize: 25, color: gr),
                                    ),
                                    Icon(Icons.date_range_outlined,
                                        color: gr, size: 30),
                                  ])
                            : Text(
                                selectedDate.toString().split(' ')[0],
                                style: TextStyle(fontSize: 25, color: gr),
                              ),
                      ),
                    ),
                    onTap: () {
                      _selectDate(context);
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  SizedBox(
                    height: h * 0.06,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(' اختر الموعد المناسب لك',
                              style: TextStyle(color: r, fontSize: w * 0.06)),
                        ],
                      ),
                    ),
                  ),
                  isEmpty
                      ? const SizedBox(
                          child: Text('لا يوجد مواعيد متاحة هذا اليوم '),
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.48,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              childAspectRatio:
                                  MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? 1
                                      : 4,
                            ),
                            itemCount: times.length,
                            itemBuilder: (BuildContext context, int index) {
                              return TextButton(
                                onPressed: () {
                                  times[index]['status'] == 'false'
                                      ? null
                                      : confirmAlert(
                                          AccountController.userId,
                                          convertDate(selectedDate
                                              .toString()
                                              .split(' ')[0]),
                                          times[index]['hour_half']);
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      int.parse((times[index]['hour_half'])
                                                  .split(":")[0]) <=
                                              12
                                          ? "${int.parse((times[index]['hour_half']).split(":")[0]).toString().padLeft(2, '0')}:${(times[index]['hour_half']).split(":")[1]}"
                                          : "${(int.parse((times[index]['hour_half']).split(":")[0]) - 12).toString().padLeft(2, '0')}:${(times[index]['hour_half']).split(":")[1]}",
                                      style: TextStyle(
                                        color: times[index]['status'] == 'false'
                                            ? const Color(0xffafc4d3)
                                            : const Color(0xff595959),
                                        fontSize: w * 0.07,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    Text(
                                      int.parse((times[index]['hour_half'])
                                                  .split(":")[0]) <
                                              12
                                          ? "صباحًا"
                                          : "مساءًا",
                                      style: TextStyle(
                                        fontSize: w * 0.061,
                                        color: times[index]['status'] == 'false'
                                            ? const Color(0xffafc4d3)
                                            : const Color(0xff595959),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          );
  }
}
