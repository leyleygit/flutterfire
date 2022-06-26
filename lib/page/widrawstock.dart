import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutterfire/product_model.dart';
import 'package:rxdart/rxdart.dart';

class Widrawstock extends StatefulWidget {
  const Widrawstock({Key? key, required this.idProduct}) : super(key: key);
  final String idProduct;
  @override
  State<Widrawstock> createState() => _WidrawstockState();
}

class _WidrawstockState extends State<Widrawstock> {
  TextEditingController textEditingController = TextEditingController();
  BehaviorSubject<bool> subjectButton = BehaviorSubject<bool>();

  FocusNode focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  void showSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  SnackBar widrawSnackBar = SnackBar(
    content: Row(children: const [
      Text('Stock has been minus'),
      SizedBox(
        width: 20,
      ),
      Icon(
        Icons.check_circle_outline,
        color: Colors.green,
      )
    ]),
  );
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Scaffold(
          body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .doc(widget.idProduct)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          ProductModel productModel =
              ProductModel.fromJson(snapshot.data.data());
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Color.fromARGB(255, 107, 27, 21),
                automaticallyImplyLeading: false,
                title: Text('Widraw Stock'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          CupertinoIcons.clear,
                          color: Color.fromARGB(255, 97, 15, 15),
                        )),
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Stock On Hand Now',
                      ),
                      Text(
                        productModel.qty.toString(),
                        style: TextStyle(fontSize: 50),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        productModel.name,
                        style: TextStyle(fontSize: 30),
                      )
                    ],
                  )),
                ),
              ),
              SliverToBoxAdapter(
                //input is here
                child: Container(
                  height: 200,
                  //color: Colors.green[100],
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 97, 15, 15),
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Form(
                              onChanged: () {
                                if (!_formKey.currentState!.validate()) {
                                  return subjectButton.add(true);
                                }
                                return subjectButton.add(isValid);
                              },
                              key: _formKey,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'value is Emty';
                                  } else if (int.parse(value) == 0) {
                                    return 'value is 0';
                                  } else if (int.parse(value) >
                                      productModel.qty) {
                                    return 'value is bigger than QTY';
                                  }
                                  return null;
                                },
                                focusNode: focusNode,
                                controller: textEditingController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      (RegExp("[.0-9]")))
                                ],
                                style: TextStyle(color: Colors.white),
                                cursorColor: Colors.white,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                decoration:
                                    InputDecoration(border: InputBorder.none),
                              ),
                            )),
                      ),
                      StreamBuilder(
                        initialData: true,
                        stream: subjectButton,
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(255, 97, 15, 15)),
                              onPressed: snapshot.data == true
                                  ? null
                                  : () {
                                      FirebaseFirestore.instance
                                          .collection("products")
                                          .doc(widget.idProduct)
                                          .update({
                                            "qty": FieldValue.increment(
                                                -num.parse(
                                                    textEditingController.text))
                                          })
                                          .then((value) =>
                                              textEditingController.clear())
                                          .then((value) => showSnackBar(
                                              context, widrawSnackBar));
                                      //Navigator.pop(context);
                                    },
                              // onPressed: () {
                              //   print(snapshot.data);
                              // },
                              child: Text('Widraw Now'));
                        },
                      )
                    ],
                  )),
                ),
              )
            ],
          );
        },
      )),
    );
  }
}
