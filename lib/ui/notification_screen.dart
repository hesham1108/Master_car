import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:master_car_project/controller/get_notification_controller.dart';
import 'package:master_car_project/controller/local_notification_service.dart';
import 'package:master_car_project/controller/notifiers/load_notification_notifier.dart';
import 'package:master_car_project/helper_widgets/custom_screen.dart';
import 'package:master_car_project/ui/splash.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Color r = const Color(0xffd01f25);
  bool _isLoading = true;
  dynamic notifications = [];

  getNotificationContent() async {
    GetNotificationController nc = GetNotificationController();
    await nc.getAllNotification();
    if (nc.success) {
      notifications = nc.content.reversed.toList();

      _isLoading = false;

      context.read<LoadNotificationController>().unloadNotification();

      setState(() {});
    } else {
      Fluttertoast.showToast(
          msg: "حدث خطأ أثناء التحميل",
          backgroundColor: r,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 17.0);

      /// here
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    LocalNotificationService.x = 1;
    getNotificationContent();
    super.initState();
  }

  @override
  void dispose() {
    LocalNotificationService.x = 0;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return _isLoading
        ? const Splash()
        : CustomScreen(
            img: 'notification',
            title: '',
            sizedBoxHeight: h * 0.11,
            heightOfRedPart: h * 0.15,
            appBarTitle: 'الاشعارات',
            showAppBar: true,
            positionFromTop: h * 0.05,
            showNavigatorBar: false,
            imgH: w * 0.24,
            imgW: w * 0.24,
            child: Consumer<LoadState>(
                builder: (BuildContext context, value, Widget? child) {
              if (value.load) {
                getNotificationContent();
              }
              return ListView.separated(
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: h * 0.03,
                    );
                  },
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // if you need this
                        // side: BorderSide(
                        //   color: r,
                        //   width: 1,
                        // ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                      'http://mastercar.ddns.net:8891${notifications[index]['imagePath']}',
                                      width: w * 0.9,
                                      height: h * 0.3),
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(notifications[index]['content'],
                                    style: TextStyle(
                                        color: const Color(0xff08497D),
                                        fontSize: w * 0.05)),
                              ],
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    notifications[index]['notification_date']
                                        .toString()
                                        .split("T")[0],
                                    style: TextStyle(
                                      color: const Color(0xff08497D),
                                      fontSize: w * 0.035,
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: Text(
                                  //     '12:12',
                                  //     style: TextStyle(
                                  //       color: Color(0xff08497D),
                                  //       fontSize: w * 0.035,
                                  //     ),
                                  //   ),
                                  // ),
                                ]),
                          ],
                        ),
                      ),
                    );
                  });
            }),
          );
  }
}
