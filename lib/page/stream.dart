import 'package:flutter/material.dart';
import 'package:flutterfire/data.dart';
import 'package:rxdart/subjects.dart';

class Stream extends StatefulWidget {
  const Stream({Key? key}) : super(key: key);
  @override
  State<Stream> createState() => _StreamState();
}

class _StreamState extends State<Stream> {
  BehaviorSubject<List<PersonModel>> subjectPerson =
      BehaviorSubject<List<PersonModel>>();
  final List<Map> myProducts =
      List.generate(20, (index) => {"id": index, "name": "Product $index"})
          .toList();
  @override
  void initState() {
    super.initState();
    subjectPerson.add(persondata);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      // body: StreamBuilder(
      //   stream: subjectPerson,
      //   builder: (BuildContext context,
      //       AsyncSnapshot<List<PersonModel>> snapshot) {
      //     if (!snapshot.hasData) return Container();
      //     return SizedBox(
      //       width: size.width,
      //       height: size.height,
      //       child: ListView.builder(
      //         itemCount: snapshot.data!.length,
      //         scrollDirection: Axis.vertical,
      //         itemBuilder: (BuildContext context, int index) {
      //           return Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Container(
      //               height: 100,
      //               color: Colors.cyan,
      //               child: Center(
      //                   child: Text(
      //                 snapshot.data![index].name,
      //                 style: const TextStyle(fontSize: 50),
      //               )),
      //             ),
      //           );
      //         },
      //       ),
      //     );
      //   },
      // ));
      body: ListView.builder(
        itemCount: myProducts.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              color: Colors.red,
              child: Center(
                  child: Text(
                myProducts[index]['name'],
                style: TextStyle(fontSize: 30),
              )),
            ),
          );
        },
      ),
    );
  }
}
