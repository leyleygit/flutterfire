import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire/product_model.dart';
import 'package:rxdart/subjects.dart';

class UpdateScreen extends StatefulWidget {
  final String productKey;
  final ProductModel productModel;
  const UpdateScreen(
      {Key? key,
      required,
      required this.productKey,
      required this.productModel})
      : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _costTextFieldfocusNode = FocusNode();
  final _priceTextFieldfocusNode = FocusNode();
  final _qtyTextFieldfocusNode = FocusNode();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  void showSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  SnackBar upDateSnackbarText = SnackBar(
    content: Row(children: const [
      Text('Data Update successfully'),
      SizedBox(
        width: 20,
      ),
      Icon(
        Icons.check,
        color: Colors.green,
      )
    ]),
  );
  BehaviorSubject<bool> subjectButton = BehaviorSubject<bool>();
  bool isValid = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productModel.name);
    _priceController =
        TextEditingController(text: widget.productModel.price.toString());
    _costController =
        TextEditingController(text: widget.productModel.cost.toString());
    _qtyController =
        TextEditingController(text: widget.productModel.qty.toString());
  }

  update() {
    FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productKey)
        .update({
          "name": _nameController.text,
          "price": num.parse(_priceController.text),
          "cost": num.parse(_costController.text),
          "qty": num.parse(_qtyController.text)
        })
        .then((value) => showSnackBar(context, upDateSnackbarText))
        .then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerEdgeDragWidth: 0,
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Color.fromARGB(255, 19, 53, 29)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(CupertinoIcons.clear)),
            )
          ],
          automaticallyImplyLeading: false,
          title: const Text('Update Product'),
          backgroundColor: const Color.fromARGB(255, 19, 53, 29),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Form(
            key: _formKey,
            onChanged: () {
              if (!_formKey.currentState!.validate()) {
                return subjectButton.add(true);
              }
              return subjectButton.add(isValid);
            },
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
                                color: Color.fromARGB(255, 19, 53, 29))),
                        hintText: 'Name',
                        labelText: 'Name',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //cost
                    TextFormField(
                      focusNode: _costTextFieldfocusNode,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter cost';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: _costController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow((RegExp("[.0-9]")))
                      ],
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 235, 235, 235))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 19, 53, 29))),
                        hintText: 'Cost',
                        labelText: 'Cost',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //price
                    TextFormField(
                      focusNode: _priceTextFieldfocusNode,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter price';
                        }
                        return null;
                      },
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow((RegExp("[.0-9]")))
                      ],
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 235, 235, 235))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 19, 53, 29))),
                        hintText: 'Price',
                        labelText: 'Price',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //qty
                    TextFormField(
                      focusNode: _qtyTextFieldfocusNode,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter qty';
                        }
                        return null;
                      },
                      controller: _qtyController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow((RegExp("[.0-9]")))
                      ],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 235, 235, 235))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 19, 53, 29))),
                          labelText: 'Qty',
                          hintText: 'Qty'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                      stream: subjectButton,
                      initialData: false,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        return ElevatedButton(
                            onPressed: snapshot.data == true
                                ? null
                                : () {
                                    update();
                                  },
                            style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 19, 53, 29),
                                onPrimary: Colors.white),
                            child: const Text('Update Product Now'));
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
