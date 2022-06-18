import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class TitleWidget extends StatefulWidget {
  final String title;
  TitleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //title
          Text(
            widget.title,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
              width: 100,
              height: 55,
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Color.fromARGB(0, 225, 225, 225))),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Color.fromARGB(255, 110, 24, 214)),
                      borderRadius: BorderRadius.circular(
                        7.0,
                      ),
                    )),
              )),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {},
            child: Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
