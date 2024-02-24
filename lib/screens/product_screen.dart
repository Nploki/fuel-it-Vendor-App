import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fuel_it_vendor_app/screens/add_newProduct.dart';
import 'package:fuel_it_vendor_app/widget/app_bar.dart';
import 'package:fuel_it_vendor_app/widget/slider.dart';
// import 'package:google_fonts/google_fonts.dart';

class product_screen extends StatefulWidget {
  static const String id = "product_screen";

  const product_screen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<product_screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: app_Bar(context, "Products"),
          drawer: slider(
            scaffoldKey: _scaffoldKey,
          ),
          body: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          child: const Row(
                            children: [
                              Text(
                                "Product",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 20),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.black54,
                                maxRadius: 20,
                                child: FittedBox(
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("20",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, AddNewProduct.id);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Add New",
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TabBar(
                  labelColor: Colors.green.shade700,
                  unselectedLabelColor: Colors.black54,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: const Color.fromARGB(255, 76, 175, 120),
                  tabs: const [
                    Tab(text: "PUBLISHED"),
                    Tab(text: "UN PUBLISHED"),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    Center(
                      child: Text("Published Products"),
                    ),
                    Center(
                      child: Text("Unpublished Products"),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
