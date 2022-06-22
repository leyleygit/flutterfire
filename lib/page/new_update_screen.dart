import 'package:flutter/material.dart';

import 'package:flutterfire/data.dart';

class NewUpdateScreen extends StatefulWidget {
  final PersonModel? person;

  const NewUpdateScreen({
    Key? key,
    required this.person,
  }) : super(key: key);

  @override
  State<NewUpdateScreen> createState() => _NewUpdateScreenState();
}

class _NewUpdateScreenState extends State<NewUpdateScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController sexController = TextEditingController();

  @override
  void initState() {
    nameController = TextEditingController(text: widget.person!.name);
    ageController = TextEditingController(text: widget.person!.age.toString());
    sexController = TextEditingController(text: widget.person!.sex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'name'),
          ),
          TextFormField(
            controller: ageController,
            decoration: InputDecoration(hintText: 'age'),
          ),
          TextFormField(
            controller: sexController,
            decoration: InputDecoration(hintText: 'sex'),
          ),
          ElevatedButton(
              onPressed: () {
                var person = PersonModel(
                    name: nameController.text,
                    age: num.parse(ageController.text),
                    sex: sexController.text);

                Navigator.pop(context, person);
                // var index = personInBattambang
                //     .indexWhere((element) => element.id == widget.person!.id);

                // personInBattambang[index] = person;

                // var index = personInBattambang.indexOf(widget.person!);
                // print(index);
                // personInBattambang
                //     .replaceRange(widget.index, widget.index + 1, [
                //   person,
                // ]);

                nameController.clear();
                ageController.clear();
                sexController.clear();
              },
              child: Text('Update Now'))
        ],
      )),
    );
  }
}
