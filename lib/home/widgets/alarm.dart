import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Alarm extends StatelessWidget {
  final bool hasNewAlarm;
  final void Function()? onTapped;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapped,
      child: SvgPicture.asset('assets/icons/alarm.svg', width: 28, height: 28),
    );
  }

  const Alarm({
    super.key,
    required this.hasNewAlarm,
    this.onTapped,
  });
}
