import 'package:flutter/material.dart';
import 'package:master_car_project/helper_widgets/custom_screen.dart';

class SingleLastM extends StatelessWidget {
  final dynamic singleMaintenance;
  final int customerId;
  const SingleLastM(
      {Key? key, required this.singleMaintenance, required this.customerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    Color r = const Color(0xffd01f25);
    Color bl = const Color(0xff2a2a2a);
    return CustomScreen(
      img: 'History',
      title: '',
      sizedBoxHeight: h * 0.1,
      heightOfRedPart: h * 0.15,
      appBarTitle: 'الصيانات السابقة',
      showAppBar: true,
      positionFromTop: h * 0.05,
      showNavigatorBar: false,
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: bl,
            indent: w * 0.05,
            endIndent: w * 0.05,
            height: w * 0.08,
          );
        },
        itemCount: singleMaintenance['maintanence_items'].length,
        itemBuilder: (BuildContext context, int i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: w * 0.70,
                  child: Text(
                      "${singleMaintenance['maintanence_items'][i]['item_name']}",
                      style: TextStyle(color: r, fontSize: 20),
                      maxLines: 3),
                ),
                SizedBox(
                  width: w * 0.25,
                  child: Text(
                      "${singleMaintenance['maintanence_items'][i]['total_after']} جنيه",
                      style: TextStyle(color: bl, fontSize: 20)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
