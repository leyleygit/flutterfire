import 'package:flutter/material.dart';
import 'package:flutterfire/data.dart';
import 'package:flutterfire/page/new_update_screen.dart';
import 'package:rxdart/subjects.dart';

class Stream extends StatefulWidget {
  const Stream({Key? key}) : super(key: key);
  @override
  State<Stream> createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  // BehaviorSubject<List<PersonModel>> subjectPerson =
  //     BehaviorSubject<List<PersonModel>>();
  // final List<Map> myProducts =
  //     List.generate(20, (index) => {"id": index, "name": "Product $index"})
  //         .toList();
  BehaviorSubject<List<PersonModel>> subjectPeople =
      BehaviorSubject<List<PersonModel>>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController sexController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // subjectPerson.add(persondata);
    subjectPeople.add(personInBattambang);
  }

  @override
  void dispose() {
    subjectPeople.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Form(
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
                        personInBattambang.add(person);
                        subjectPeople.add(personInBattambang);

                        nameController.clear();
                        ageController.clear();
                        sexController.clear();
                      },
                      child: Text('Add Now'))
                ],
              )),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder(
                initialData: const <PersonModel>[],
                stream: subjectPeople,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  // List<PersonModel> person = snapshot.data;
                  if (snapshot.data == null) {
                    return Container();
                  }
                  return Container(
                    height: size.height,
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            color: Colors.red,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                    child: Text(
                                  snapshot.data[index].name,
                                  style: TextStyle(fontSize: 30),
                                )),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      print(snapshot.data[index].id);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => NewUpdateScreen(
                                                    person:
                                                        snapshot.data[index],
                                                  ))).then((value) {
                                        if (value != null) {
                                          personInBattambang[index] = value;

                                          subjectPeople.add(personInBattambang);
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      personInBattambang.removeAt(index);
                                      subjectPeople.add(personInBattambang);
                                    },
                                    icon: Icon(Icons.delete))
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
