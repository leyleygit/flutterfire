import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire/product_model.dart';
import 'package:rxdart/subjects.dart';

class DepositScreen extends StatefulWidget {
  final String idProduct;
  const DepositScreen({Key? key, required this.idProduct}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  FocusNode focusNode = FocusNode();
  BehaviorSubject<bool> subjectButton = BehaviorSubject<bool>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Deposit Now'),
          backgroundColor: const Color.fromARGB(255, 40, 9, 89),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white, onPrimary: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(CupertinoIcons.clear)),
            )
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('products')
              .doc(widget.idProduct)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            ProductModel product = ProductModel.fromJson(snapshot.data.data());
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 150,
                    //color: Colors.green,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('stock on hand now'),
                          Text(
                            product.qty.toString(),
                            style: const TextStyle(fontSize: 50),
                          ),
                          Text(
                            product.name,
                            style: const TextStyle(fontSize: 30),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,
                    // color: Colors.yellow,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 40, 9, 89),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Form(
                                key: _formKey,
                                onChanged: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return subjectButton.add(true);
                                  }
                                  return subjectButton.add(isValid);
                                },
                                child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    focusNode: focusNode,
                                    controller: controller,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please Input some value';
                                      } else if (int.parse(value) == 0) {
                                        return 'Please input value > 0';
                                      }
                                      return null;
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          (RegExp("[.0-9]")))
                                    ],
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Colors.white,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none)),
                              ),
                            ),
                          ),
                          StreamBuilder(
                            stream: subjectButton,
                            initialData: true,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              return ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary:
                                          const Color.fromARGB(255, 89, 14, 9)),
                                  onPressed: snapshot.data == true
                                      ? null
                                      : () {
                                          FirebaseFirestore.instance
                                              .collection("products")
                                              .doc(widget.idProduct)
                                              .update({
                                            "qty": FieldValue.increment(
                                                num.parse(controller.text))
                                          }).then((value) =>
                                                  controller.clear());

                                          //Navigator.pop(context);
                                        },
                                  child: const Text('Diposit Now'));
                            },
                          ),
                        ]),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
