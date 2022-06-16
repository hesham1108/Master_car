import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:master_car_project/helper_widgets/custom_screen.dart';
import 'package:master_car_project/ui/splash.dart';

import '../controller/account_controller.dart';
import '../controller/maintenance_controller.dart';

class NextMaintenance extends StatefulWidget {
  const NextMaintenance({
    Key? key,
  }) : super(key: key);

  @override
  State<NextMaintenance> createState() => _NextMaintenanceState();
}

class _NextMaintenanceState extends State<NextMaintenance> {
  Color r = const Color(0xffd01f25);
  Color bl = const Color(0xff2a2a2a);
  bool _isLoading = true;
  dynamic nextMaintenanceContent = [];
  Future<void> getNextMaintenance() async {
    MaintenanceController m = MaintenanceController();
    await m.getNextMaintenance(AccountController.userId);
    if (m.nextMaintenanceSuccess) {
      nextMaintenanceContent = m.nextMaintenance;

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
    getNextMaintenance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return _isLoading
        ? const SafeArea(child: Splash())
        : CustomScreen(
            img: 'History',
            title: '',
            sizedBoxHeight: h * 0.1,
            heightOfRedPart: h * 0.15,
            appBarTitle: 'الصيانات القادمة',
            showAppBar: true,
            positionFromTop: h * 0.05,
            showNavigatorBar: false,
            child: ListView.separated(
                clipBehavior: Clip.none,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: h * 0.03,
                  );
                },
                itemCount: nextMaintenanceContent.length,
                itemBuilder: (context, index) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        //height: h * 0.17,
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // if you need this
                            side: BorderSide(
                              color: r,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                // height: h * 0.08,
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: w * 0.25,
                                        child: Text('رقم السيارة',
                                            style: TextStyle(
                                                color: r, fontSize: 20)),
                                      ),
                                      SizedBox(
                                        width: w * 0.7,
                                        child: Text(
                                            '${nextMaintenanceContent[index]['name']}',
                                            style: TextStyle(
                                                color: bl, fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                  Divider(color: r),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: w * 0.25,
                                        child: Text('اخر قراءة للعداد',
                                            style: TextStyle(
                                                color: r, fontSize: 20)),
                                      ),
                                      SizedBox(
                                        width: w * 0.70,
                                        child: Text(
                                            '${nextMaintenanceContent[index]['car_speedometer']}',
                                            style: TextStyle(
                                                color: bl, fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                  Divider(color: r),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: w * 0.25,
                                        child: Text('ملاحظات',
                                            style: TextStyle(
                                                color: r, fontSize: 20)),
                                      ),
                                      SizedBox(
                                        width: w * 0.7,
                                        child: Text(
                                            '${nextMaintenanceContent[index]['notes']}',
                                            style: TextStyle(
                                                color: bl, fontSize: 20)),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: -h * 0.03,
                          child: Card(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            color: r,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                nextMaintenanceContent[index]['date']
                                    .toString()
                                    .split("T")[0],
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                    ],
                  );
                }),
          );
  }
}
