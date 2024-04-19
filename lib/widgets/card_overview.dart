import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardOverview extends StatelessWidget {
  final String title;
  final String value;
  final Color colorThemeCard;

  const CardOverview(
      {required this.title, required this.value, required this.colorThemeCard});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 27),
        width: MediaQuery.of(context).size.width / 1.15,
        height: 130,
        decoration: BoxDecoration(
            color: colorThemeCard, borderRadius: BorderRadius.circular(6)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
            ),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
