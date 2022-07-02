import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire/page/create_product.dart';
import 'package:flutterfire/page/depositStock.dart';
import 'package:flutterfire/page/stream.dart';
import 'package:flutterfire/page/widgetItem/update_screen.dart';
import 'package:flutterfire/page/widgetItem/widget_indrawer.dart';
import 'package:flutterfire/page/widrawstock.dart';
import 'package:flutterfire/product_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class HomeScrenn extends StatefulWidget {
  const HomeScrenn({Key? key}) : super(key: key);

  @override
  State<HomeScrenn> createState() => _HomeScrennState();
}

class _HomeScrennState extends State<HomeScrenn> with TickerProviderStateMixin {
  late AnimationController _animationController2;
  late Animation _animation2;
  BehaviorSubject<AnimationController> subjectAnimationController2 =
      BehaviorSubject<AnimationController>();
  BehaviorSubject<Animation> subjectAnimation2 = BehaviorSubject<Animation>();

  void showSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  SnackBar deletednackBar = SnackBar(
    content: Row(children: const [
      Text('Product has been Deletd successfully'),
      SizedBox(
        width: 20,
      ),
      Icon(
        Icons.check_circle_outline,
        color: Colors.yellow,
      )
    ]),
  );
  final _key = GlobalKey<ScaffoldState>();
  deleteProductFuc() async {
    return await FirebaseFirestore.instance
        .collection('products')
        .doc(_id)
        .delete();
  }

  ProductModel? productModel;

  String? _id;
  @override
  void initState() {
    super.initState();
    _animationController2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    subjectAnimationController2.add(_animationController2);
    _animation2 =
        CurvedAnimation(parent: _animationController2, curve: Curves.decelerate)
          ..addListener(() => subjectAnimation2.add(_animation2));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   Navigator.push(context, MaterialPageRoute(builder: (_) => Stream()));
        // }),
        key: _key,
        drawerEdgeDragWidth: 0,
        drawer: Container(
          color: const Color.fromARGB(255, 251, 250, 250),
          width: 300,
          child: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UnconstrainedBox(
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 50,
                      height: 40,
                      child: Center(
                          child: Icon(
                        CupertinoIcons.clear,
                        color: Color.fromARGB(255, 239, 237, 237),
                      )),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 89, 31, 27),
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
              ),
              WidgetInDrawer(
                primaryColor: const Color.fromARGB(255, 40, 9, 89),
                onPrimaryColor: Colors.white,
                size: size,
                centerString: 'Deposit Stock',
                centerIcon: Icons.add,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => DepositScreen(
                            idProduct: _id!,
                          )));
                },
              ),
              WidgetInDrawer(
                onPrimaryColor: Colors.white,
                primaryColor: const Color.fromARGB(255, 97, 15, 15),
                size: size,
                centerString: 'Widraw Stock',
                centerIcon: CupertinoIcons.minus,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return Widrawstock(
                      idProduct: _id!,
                    );
                  }));
                },
              ),
              Expanded(flex: 1, child: Container()),
              WidgetInDrawer(
                onPrimaryColor: Colors.white,
                primaryColor: const Color.fromARGB(255, 19, 53, 29),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UpdateScreen(
                                productKey: _id!,
                                productModel: productModel!,
                              )));
                },
                size: size,
                centerString: 'Update Product',
                centerIcon: CupertinoIcons.pencil,
              ),
              Expanded(flex: 3, child: Container()),
              WidgetInDrawer(
                onPrimaryColor: Colors.white,
                primaryColor: const Color.fromARGB(255, 248, 85, 73),
                onPressed: () {
                  deleteProductFuc();
                  Navigator.pop(context);
                  showSnackBar(context, deletednackBar);
                },
                size: size,
                centerString: 'Delete product',
                centerIcon: CupertinoIcons.delete,
              )
            ],
          )),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.red[900],
                  title: const Text('Fruit Shope'),
                  centerTitle: true,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          width: 60,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.red[900],
                                  primary: Colors.white),
                              onPressed: () {
                                _animationController2.forward(from: 0.0);
                                subjectAnimationController2
                                    .add(_animationController2);
                              },
                              child: const Icon(Icons.add))),
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        List<ProductModel> fetchlistPorductModel =
                            List<ProductModel>.from(snapshot.data.docs
                                .map((e) => ProductModel.fromJson(e.data())));
                        return Container(
                            child: DataTable(
                          columns: const [
                            DataColumn(label: Text('ឈ្មោះ')),
                            DataColumn(label: Text('ចំនួន')),
                            DataColumn(label: Text('តម្លៃលក់')),
                          ],
                          rows: [
                            ...List.generate(fetchlistPorductModel.length,
                                (index) {
                              return DataRow(
                                  onLongPress: () {
                                    _id = snapshot.data.docs[index].id;
                                    productModel = fetchlistPorductModel[index];
                                    _key.currentState!.openDrawer();
                                  },
                                  cells: [
                                    DataCell(Text(
                                        fetchlistPorductModel[index].name)),
                                    DataCell(Text(fetchlistPorductModel[index]
                                        .qty
                                        .toString())),
                                    DataCell(Text(
                                      fetchlistPorductModel[index]
                                              .price
                                              .toString() +
                                          " រៀល",
                                      style: TextStyle(
                                          color: Colors.red[500],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15),
                                    )),
                                  ]);
                            })
                          ],
                        ));
                      },
                    ),
                  ),
                )
              ],
            ),
            StreamBuilder(
              initialData: AnimationController(
                  vsync: this, duration: const Duration(milliseconds: 700)),
              stream: subjectAnimationController2,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return StreamBuilder<Object>(
                    initialData: CurvedAnimation(
                        parent: _animationController2,
                        curve: Curves.decelerate),
                    stream: subjectAnimation2,
                    builder: (context, AsyncSnapshot snapshot) {
                      var animation2Snap = snapshot.data;
                      return Transform(
                          transform: Matrix4.translationValues(
                              0,
                              -size.height + size.height * animation2Snap.value,
                              0),
                          child: CreateProducts(
                            subjectAnimationController:
                                subjectAnimationController2,
                          ));
                    });
              },
            )
          ],
        ));
  }
}
