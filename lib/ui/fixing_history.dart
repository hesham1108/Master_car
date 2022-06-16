import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:master_car_project/controller/account_controller.dart';

import 'package:master_car_project/helper_widgets/custom_screen.dart';
import 'package:master_car_project/ui/single_last_maintenence.dart';
import 'package:master_car_project/ui/splash.dart';

import '../controller/maintenance_controller.dart';

class FixingHistory extends StatefulWidget {
  const FixingHistory({
    Key? key,
  }) : super(key: key);

  @override
  State<FixingHistory> createState() => _FixingHistoryState();
}

class _FixingHistoryState extends State<FixingHistory> {
  Color r = const Color(0xffd01f25);
  Color bl = const Color(0xff2a2a2a);
  bool _isLoading = true;

  dynamic maintenanceContent = [];

  Future<void> getAllMaintenance() async {
    MaintenanceController m = MaintenanceController();
    await m.getAllMaintenance(AccountController.userId);
    if (m.allMaintenanceSuccess) {
      maintenanceContent = m.allMaintenance;

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
    getAllMaintenance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;

    return _isLoading
        ? const SafeArea(child: Splash())
        : CustomScreen(
            img: 'History',
            title: '',
            sizedBoxHeight: h * 0.1,
            heightOfRedPart: h * 0.15,
            appBarTitle: 'الصيانات السابقة',
            showAppBar: true,
            positionFromTop: h * 0.05,
            showNavigatorBar: false,
            child: maintenanceContent.isNotEmpty
                ? ListView.separated(
                    clipBehavior: Clip.none,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: h * 0.03,
                      );
                    },
                    itemCount: maintenanceContent.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SingleLastM(
                                        singleMaintenance:
                                            maintenanceContent[index],
                                        customerId: AccountController.userId,
                                      )));
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              //height: h * 0.17,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // if you need this
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
                                            Text('رقم السيارة',
                                                style: TextStyle(
                                                    color: r, fontSize: 20)),
                                            Text(
                                                '${maintenanceContent[index]['car_number']}',
                                                style: TextStyle(
                                                    color: bl, fontSize: 20)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text('اخر قراءة للعداد',
                                                style: TextStyle(
                                                    color: r, fontSize: 20)),
                                            Text(
                                                '${maintenanceContent[index]['car_speedometer']}',
                                                style: TextStyle(
                                                    color: bl, fontSize: 20)),
                                          ],
                                        ),
                                        const Text('...'),
                                      ]),
                                      // child: ListView.separated(
                                      //   separatorBuilder:
                                      //       (BuildContext context, int index) {
                                      //     return Divider(
                                      //       color: r,
                                      //     );
                                      //   },
                                      //   itemCount: maintenanceContent[index]
                                      //           ['maintanence_items']
                                      //       .length,
                                      //   itemBuilder: (BuildContext context, int i) {
                                      //     return Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.spaceAround,
                                      //       children: [
                                      //         Text(
                                      //             "${maintenanceContent[index]['maintanence_items'][i]['item_name']}"),
                                      //         Text(
                                      //             "${maintenanceContent[index]['maintanence_items'][i]['tota bl_after']}"),
                                      //       ],
                                      //     );
                                      //   },
                                      // ),
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
                                      maintenanceContent[index]['date']
                                          .toString()
                                          .split(" ")[0],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                child: Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8)),
                                  ),
                                  color: const Color(0xfffcbc04),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${maintenanceContent[index]['value']}",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      );
                    })
                : Center(
                    child: Text(
                    'لا يوجد صيانات سابقة ',
                    style: TextStyle(fontSize: 20, color: r),
                  )),
          );
  }
}
