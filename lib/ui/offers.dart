import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:master_car_project/helper_widgets/custom_screen.dart';
import 'package:master_car_project/ui/single_offer.dart';
import 'package:master_car_project/ui/splash.dart';

import '../controller/offers_controller.dart';

class Offers extends StatefulWidget {
  const Offers({
    Key? key,
  }) : super(key: key);

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  Color r = const Color(0xffd01f25);
  bool _isLoading = true;
  dynamic content = [];
  dynamic getAllOffers() async {
    OffersController oc = OffersController();
    await oc.getAllOffers();
    if (oc.allOffersSuccess) {
      content = oc.allOffersContent;
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
    getAllOffers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    Color gr = const Color(0xff606060);
    return _isLoading
        ? const SafeArea(child: Splash())
        : CustomScreen(
            img: 'Offers',
            title: '',
            sizedBoxHeight: h * 0.1,
            heightOfRedPart: h * 0.15,
            appBarTitle: 'العروض وقطع الغيار',
            showAppBar: true,
            positionFromTop: h * 0.05,
            showNavigatorBar: false,
            child: content.isNotEmpty
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: w * 0.01,
                    ),
                    itemCount: content.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: r,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Image.network(
                                        'http://mastercar.ddns.net:8891${content[index]['url']}',
                                        width: w * 0.2,
                                        height: w * 0.18),
                                    Text(
                                      content[index]['item_name'].toString(),
                                      style: TextStyle(color: gr),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                                '${content[index]['after_discount']}جنيه',
                                                style: TextStyle(color: gr)),
                                            Text(
                                                '${content[index]['price_part']}جنيه',
                                                style: TextStyle(
                                                    color: gr,
                                                    decoration: TextDecoration
                                                        .lineThrough))
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'خصم',
                                              style: TextStyle(color: gr),
                                            ),
                                            Text(
                                                '${content[index]['discount_percent']}%',
                                                style: TextStyle(color: r))
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SingleOffer(
                                  offer: content[index],
                                ),
                              ));
                        },
                      );
                    })
                : Center(
                    child: Text(
                    'لا يوجد عروض',
                    style: TextStyle(color: r, fontSize: 20),
                  )),
          );
  }
}
