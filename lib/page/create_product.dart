import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

class CreateProducts extends StatefulWidget {
  //final AnimationController? animationController;
  final BehaviorSubject<AnimationController> subjectAnimationController;

  CreateProducts({Key? key, required this.subjectAnimationController})
      : super(key: key);

  @override
  State<CreateProducts> createState() => _CreateProductsState();
}

class _CreateProductsState extends State<CreateProducts> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();

  SnackBar erorrsnackBar = SnackBar(
    content: Row(children: const [
      Text('please fill all the fields'),
      SizedBox(
        width: 20,
      ),
      Icon(
        Icons.error,
        color: Colors.red,
      )
    ]),
  );
  SnackBar succesesnackBar = SnackBar(
    content: Row(children: const [
      Text('data added successfully'),
      SizedBox(
        width: 20,
      ),
      Icon(
        Icons.check,
        color: Colors.green,
      )
    ]),
  );
  void showSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  FocusNode _CostTextFieldfocusNode = FocusNode();
  FocusNode _PriceTextFieldfocusNode = FocusNode();
  FocusNode _QtyTextFieldfocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _CostTextFieldfocusNode.unfocus();
        _PriceTextFieldfocusNode.unfocus();
        _QtyTextFieldfocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white, elevation: 0, actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red[900]),
                  onPressed: () {
                    _CostTextFieldfocusNode.unfocus();
                    _PriceTextFieldfocusNode.unfocus();
                    _QtyTextFieldfocusNode.unfocus();
                    widget.subjectAnimationController.value.reverse(from: 1.0);
                  },
                  child: const Icon(CupertinoIcons.clear)),
            ),
          )
        ]),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
              //color: Colors.amber,
              child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //name
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      controller: _nameController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 235, 235, 235))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 106, 9, 2))),
                        hintText: 'Name',
                        labelText: 'Name',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //cost
                    TextFormField(
                      focusNode: _CostTextFieldfocusNode,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter cost';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: _costController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 235, 235, 235))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 106, 9, 2))),
                        hintText: 'Cost',
                        labelText: 'Cost',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //price
                    TextFormField(
                      focusNode: _PriceTextFieldfocusNode,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 235, 235, 235))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 106, 9, 2))),
                        hintText: 'Price',
                        labelText: 'Price',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //qty
                    TextFormField(
                      focusNode: _QtyTextFieldfocusNode,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter qty';
                        }
                        return null;
                      },
                      controller: _qtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 235, 235, 235))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 106, 9, 2))),
                          labelText: 'Qty',
                          hintText: 'Qty'),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return showSnackBar(context, erorrsnackBar);
                          }

                          return await FirebaseFirestore.instance
                              .collection('products')
                              .add({
                            "name": _nameController.text,
                            "price": num.parse(_priceController.text),
                            "cost": num.parse(_costController.text),
                            "qty": num.parse(_qtyController.text)
                          }).then((value) {
                            _nameController.clear();
                            _priceController.clear();
                            _costController.clear();
                            _qtyController.clear();
                          }).then((value) =>
                                  showSnackBar(context, succesesnackBar));
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red[900], onPrimary: Colors.white),
                        child: const Text('Add now')),
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
}
