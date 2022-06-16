import 'dart:async';
import 'package:date_count_down/countdown.dart';

import 'package:flutter/material.dart';

class AppointTimer extends StatefulWidget {
  final double w;
  final dynamic reservations;

  const AppointTimer({
    Key? key,
    required this.w,
    required this.reservations,
  }) : super(key: key);

  @override
  State<AppointTimer> createState() => _AppointTimerState();
}

class _AppointTimerState extends State<AppointTimer> {
  Color r = const Color(0xffd01f25);

  Color gr = const Color(0xff606060);
  Color bl = const Color(0xff2a2a2a);
  late Timer _timer;
  String countTime = '00:00:00:00';
  DateTime getTime() {
    String date =
        widget.reservations['reservation_date'].toString().split('T')[0];
    // String date = '13/02/2022';
    String year = date.split('-')[0];
    String month = date.split('-')[1];
    String day = date.split('-')[2];

    final dateInMilli = DateTime.parse(
        '$year-$month-$day ${widget.reservations['reservation_hour']}');
    // final dateInMilli =
    // DateTime.parse('$year-$month-$day ${widget.reservations['time']}:00');
    return dateInMilli;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  String splitTime() {
    countTime = CountDown().timeLeft(
      getTime(),
      '00:00:00:00',
    );

    if (countTime.contains('days')) {
      String days = countTime.split(' ')[0].padLeft(2, '0');

      String hours = countTime.split(' ')[2].padLeft(2, '0');

      String minutes = countTime.split(' ')[4].padLeft(2, '0');

      String seconds = countTime.split(' ')[6].padLeft(2, '0');

      return "$days:$hours:$minutes:$seconds";
    } else if (countTime.contains('hours') && !countTime.contains('days')) {
      String days = '00';
      String hours = countTime.split(' ')[0].padLeft(2, '0');

      String minutes = countTime.split(' ')[2].padLeft(2, '0');

      String seconds = countTime.split(' ')[4].padLeft(2, '0');

      return "$days:$hours:$minutes:$seconds";
    } else if (countTime.contains('minutes') &&
        !countTime.contains('hours') &&
        !countTime.contains('days')) {
      String days = '00';
      String hours = '00';
      String minutes = countTime.split(' ')[0].padLeft(2, '0');
      String seconds = countTime.split(' ')[2].padLeft(2, '0');
      return "$days:$hours:$minutes:$seconds";
    } else if (countTime.contains('seconds') &&
        !countTime.contains('minutes') &&
        !countTime.contains('hours') &&
        !countTime.contains('days')) {
      String days = '00';
      String hours = '00';
      String minutes = '00';
      String seconds = countTime.split(' ')[0].padLeft(2, '0');
      return "$days:$hours:$minutes:$seconds";
    } else {
      _timer.cancel();
      String days = '00';
      String hours = '00';
      String minutes = '00';
      String seconds = '00';
      return "$days:$hours:$minutes:$seconds";
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.w,
      padding: EdgeInsets.only(
        top: widget.w * 0.015,
        right: widget.w * 0.05,
        left: widget.w * 0.05,
        bottom: widget.w * 0.015,
      ),
      decoration: BoxDecoration(
        color: const Color(0xabffffff),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.timer_outlined,
            size: widget.w * 0.1,
          ),
          SizedBox(width: widget.w * 0.02),
          // width: widget.w * 0.17,
          Expanded(
              child: Text(
            'لديك  حجز بعد :',
            style: TextStyle(
              color: r,
              fontWeight: FontWeight.bold,
              fontSize: widget.w * 0.042,
            ),
          )),
          SizedBox(
            width: widget.w * 0.03,
          ),
          SizedBox(
            width: widget.w * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' ث : د : س : ي ',
                  style: TextStyle(
                    color: r,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.w * 0.05,
                  ),
                ),
                Text(
                  splitTime(),
                  style: TextStyle(
                    color: r,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.w * 0.05,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
