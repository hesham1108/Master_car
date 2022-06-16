import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:master_car_project/controller/account_controller.dart';

import 'package:master_car_project/controller/offers_controller.dart';
import 'package:master_car_project/ui/confirm.dart';
import 'package:master_car_project/ui/splash.dart';

class SingleOffer extends StatefulWidget {
  final dynamic offer;

  const SingleOffer({
    Key? key,
    required this.offer,
  }) : super(key: key);

  @override
  State<SingleOffer> createState() => _SingleOfferState();
}

class _SingleOfferState extends State<SingleOffer> {
  bool _isLoading = false;

  void reserveOffer(int customerId, int offerId) async {
    setState(() {
      _isLoading = true;
    });
    OffersController o = OffersController();
    await o.reserveOffer(customerId, offerId);
    if (o.reserveOfferSuccess) {
      if (o.reservationProcess == 'true') {
        setState(() {
          _isLoading = false;
        });

        /// here
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ConfirmScreen(
                    date: '',
                    lastPageAppointment: false,
                  )),
        );
      } else {
        Fluttertoast.showToast(
            msg: OffersController.errorMsg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white,
            fontSize: 20.0);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: 'يوجد مشكلة تقنية برجاء المحاولة مرة أخري',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 20.0);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    Color r = const Color(0xffd01f25);
    //Color bg = Color(0xfff6f6f6);
    Color gr = const Color(0xff606060);
    return _isLoading
        ? const SafeArea(child: Splash())
        : Scaffold(
            backgroundColor: const Color(0xfff6f6f6),
            appBar: AppBar(
              title: Text(
                widget.offer['item_name'].toString(),
                style: TextStyle(color: gr),
              ),
              backgroundColor: const Color(0xfff6f6f6),
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: r),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                      'http://mastercar.ddns.net:8891${widget.offer['url']}',
                      width: w * 0.7,
                      height: h * 0.25),
                ),
                SizedBox(
                  width: w * 0.95,
                  height: h * 0.15,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.offer['after_discount']}جنيه',
                              style: TextStyle(color: gr)),
                          Row(
                            children: [
                              Text('${widget.offer['price_part']}جنيه',
                                  style: TextStyle(
                                      color: gr,
                                      decoration: TextDecoration.lineThrough)),
                              Column(
                                children: [
                                  Text(
                                    'خصم',
                                    style: TextStyle(color: gr),
                                  ),
                                  Text('${widget.offer['discount_percent']}%',
                                      style: TextStyle(color: r))
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: h * 0.03),
                SizedBox(
                  width: w * 0.95,
                  height: h * 0.15,
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: r,
                        width: 1,
                      ),
                    ),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(widget.offer['main_content'].toString(),
                              style: TextStyle(color: gr)),
                        ],
                      ),
                    )),
                  ),
                ),
                SizedBox(height: h * 0.1),
                SizedBox(
                  width: w * 0.8,
                  height: h * 0.075,
                  child: ElevatedButton(
                      onPressed: () {
                        reserveOffer(
                            AccountController.userId, widget.offer['Id']);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: r,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(
                        "احجز العرض",
                        style:
                            TextStyle(color: Colors.white, fontSize: w * 0.05),
                      )),
                ),
              ]),
            ),
          );
  }
}
