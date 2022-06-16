import 'package:flutter/material.dart';
import 'package:master_car_project/helper_widgets/custom_screen.dart';
import 'package:master_car_project/ui/home_page.dart';

class ConfirmScreen extends StatelessWidget {
  final String date;
  final bool lastPageAppointment;

  const ConfirmScreen({
    Key? key,
    required this.date,
    required this.lastPageAppointment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    Color r = const Color(0xffd01f25);
    // Color gr = Color(0xe4595959);
    Color bl = const Color(0xff2a2a2a);
    return CustomScreen(
      img: 'confirm_icon',
      title: '',
      sizedBoxHeight: h * 0.15,
      heightOfRedPart: h * 0.15,
      appBarTitle: ' ',
      showAppBar: true,
      positionFromTop: h * 0.05,
      showNavigatorBar: false,
      imgH: w * 0.24,
      imgW: w * 0.24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            lastPageAppointment
                ? "تم تأكيد الحجز بنجاح "
                : 'تم حجز العرض بنجاح',
            style: TextStyle(color: bl, fontSize: w * 0.08),
          ),
          Text(
            lastPageAppointment ? "يوم$date" : '',
            style: TextStyle(color: bl, fontSize: w * 0.08),
          ),
          SizedBox(height: h * 0.1),
          SizedBox(
            width: w * 0.8,
            height: h * 0.075,
            child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (_) => const Home()));
                },
                style: ElevatedButton.styleFrom(
                    primary: r,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  " الذهاب الى الرئيسية",
                  style: TextStyle(color: Colors.white, fontSize: w * 0.05),
                )),
          ),
        ],
      ),
    );
  }
}
