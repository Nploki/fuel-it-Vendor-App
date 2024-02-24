import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fuel_it_vendor_app/services/firebase_services.dart';

class sub_CategoryList extends StatefulWidget {
  final String cat_list;
  const sub_CategoryList({Key? key, required this.cat_list}) : super(key: key);

  @override
  State<sub_CategoryList> createState() => _sub_CategoryListState();
}

class _sub_CategoryListState extends State<sub_CategoryList> {
  Firebase_services _services = Firebase_services();

  @override
  Widget build(BuildContext context) {
    List<String> subCategory = widget.cat_list.split("#");
    return Dialog(
      child: Column(
        children: [
          Container(
            height: 65,
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
            ),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sub Category List",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: subCategory.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text((index + 1).toString()),
                  ),
                  title: Text(subCategory[index]),
                  onTap: () {
                    Navigator.pop(context, {"sname": subCategory[index]});
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
