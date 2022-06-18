import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WidgetInDrawer extends StatefulWidget {
  final Color primaryColor;
  final Color onPrimaryColor;
  final String centerString;
  final IconData centerIcon;
  final Function() onPressed;

  const WidgetInDrawer({
    Key? key,
    required this.onPressed,
    required this.size,
    required this.centerString,
    required this.centerIcon,
    required this.primaryColor,
    required this.onPrimaryColor,
  }) : super(key: key);

  final Size size;

  @override
  State<WidgetInDrawer> createState() => _WidgetInDrawerState();
}

class _WidgetInDrawerState extends State<WidgetInDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: widget.size.width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: widget.primaryColor, onPrimary: widget.onPrimaryColor),
          onPressed: () {
            widget.onPressed();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.centerString,
                style: TextStyle(fontSize: 20),
              ),
              Icon(
                widget.centerIcon,
                size: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}
