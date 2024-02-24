import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fuel_it_vendor_app/provider/auth_provier.dart';
import 'package:fuel_it_vendor_app/screens/product_screen.dart';
import 'package:fuel_it_vendor_app/widget/category_list.dart';
import 'package:fuel_it_vendor_app/widget/inventory_update.dart';
import 'package:fuel_it_vendor_app/widget/selected_image.dart';
import 'package:fuel_it_vendor_app/widget/subCategoryList.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = "AddNewProduct Screen";
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  Product_provider _provider = Product_provider();
  bool isPicAvailable = false;
  bool _track = false;
  String? _selectedImagePath;
  String imageUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW4n7CbPgSjtTv4HOmt1qEmPfpXZoYOCM0OA&usqp=CAU";
  File? _selectedImage;
  final TextEditingController _imageFileNameController =
      TextEditingController();
  final TextEditingController _comparedPriceContrller = TextEditingController();
  final TextEditingController _brandContrller = TextEditingController();
  final TextEditingController _quantityContrller = TextEditingController();
  final TextEditingController _lowStockContrller = TextEditingController();
  final TextEditingController _StockContrller = TextEditingController();

  String prdName = '';
  String aboutPrd = '';
  String sku = '';
  String quantity = '';
  String shopName = '';
  double price = 0.0;
  double tax = 0.0;
  int stockQty = 0;
  double comparedPrice = 0.0;

  Future<String> _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? pickedFile =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _selectedImagePath = pickedFile.path;
        _imageFileNameController.text =
            "${pickedFile.name}.${pickedFile.path.split('.').last}";
      });

      try {
        Map<String, dynamic> uploadResult = await _provider.uploadFile(
          _selectedImage!,
        );

        isPicAvailable = uploadResult["isPicAvail"];
        String downloadUrl = uploadResult["downloadURL"];
        imageUrl = downloadUrl;
        return downloadUrl;
      } catch (error) {
        print("Error during upload: $error");
        throw error;
      }
    } else {
      print('No image selected.');
      throw 'No image selected.';
    }
  }

  final _formKey = GlobalKey<FormState>();

  final List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];

  String sub_cat = "";
  String? dropdownValue;
  final _categoryController = TextEditingController();
  final _subcategoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          forceMaterialTransparency: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, product_screen.id);
              },
              icon: const Icon(CupertinoIcons.back)),
        ),
        body: Form(
          key: _formKey,
          child: Column(
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
                          child: const Text(
                            "Product / Add",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 20),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (isPicAvailable) {
                                  EasyLoading.dismiss();
                                  _provider.saveProductDataToDb(
                                    brand: _brandContrller.text,
                                    collection: dropdownValue,
                                    comparedPrice: comparedPrice,
                                    context: context,
                                    description: aboutPrd,
                                    lowStackQty: _lowStockContrller.text,
                                    maincategory: _categoryController.text,
                                    price: price,
                                    prdImageUrl: imageUrl,
                                    productName: prdName,
                                    quantity: _quantityContrller.text,
                                    sku: sku,
                                    stockQty: stockQty,
                                    subcategory: _subcategoryController.text,
                                  );
                                } else {
                                  _provider.alertDialog(
                                      context: context,
                                      title: 'Error',
                                      content: 'Please All Details');
                                }
                              } else {
                                _provider.alertDialog(
                                    context: context,
                                    title: 'Error',
                                    content: 'Please add an Image');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            icon: const Icon(
                              Icons.save_sharp,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Save",
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
                    Tab(text: "GENERAL"),
                    Tab(text: "INVENTORY"),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: TabBarView(children: [
                      ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a name';
                                    }
                                    setState(() {
                                      prdName = value;
                                      _provider.prdName = value;
                                    });
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "Product Name *",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45))),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Dexcription';
                                    }
                                    setState(() {
                                      aboutPrd = value;
                                    });
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      labelText: "About Product *",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45))),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: InkWell(
                                    onTap: () async {
                                      try {
                                        String url = await _pickImage();
                                        setState(() {
                                          imageUrl = url;
                                        });
                                      } catch (error) {
                                        // Handle error
                                      }
                                    },
                                    child: SelectedImage(imageUrl: imageUrl),
                                  ),
                                )
                              ],
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Selling Price';
                              }
                              setState(() {
                                price = double.parse(value);
                              });
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: "Price *",
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black45))),
                          ),
                          TextFormField(
                            controller: _comparedPriceContrller,
                            validator: (value) {
                              if (price > double.parse(value!)) {
                                return 'Compared Pirce Should be higher than Selling Price';
                              }
                              setState(() {
                                comparedPrice = double.parse(value);
                              });
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: "Compared Price *",
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black45))),
                          ),
                          Container(
                            child: Row(
                              children: [
                                const Text(
                                  'Collection',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 17.5),
                                ),
                                const SizedBox(
                                  width: 40,
                                ),
                                DropdownButton<String>(
                                  value: dropdownValue ??
                                      _collections
                                          .first, // Use a default value if dropdownValue is null
                                  icon: const Icon(Icons.arrow_drop_down),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownValue = value;
                                      print(dropdownValue);
                                    });
                                  },
                                  items: _collections
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 36,
                                child: TextFormField(
                                  controller: _brandContrller,
                                  decoration: const InputDecoration(
                                      labelText: "Brand",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45))),
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 36,
                                child: TextFormField(
                                  controller: _quantityContrller,
                                  decoration: const InputDecoration(
                                      labelText: "Quantity (No/Liter)",
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.black45))),
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Dexcription';
                              }
                              setState(() {
                                sku = value;
                              });
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: "SKU",
                                labelStyle: TextStyle(color: Colors.grey),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black45))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              children: [
                                const Text(
                                  "Category",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Select Category';
                                        }
                                        return null;
                                      },
                                      controller: _categoryController,
                                      decoration: InputDecoration(
                                        hintText:
                                            _categoryController.text.isNotEmpty
                                                ? ""
                                                : "Not Selected",
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black45),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const CategoryList();
                                      },
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          _provider.prdImage = "value['image']";
                                          _categoryController.text =
                                              value['name'];
                                          sub_cat = value['subcat'];
                                        });
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              children: [
                                const Text(
                                  "Sub \nCategory",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Select Sub-Category';
                                        }
                                        return null;
                                      },
                                      controller: _subcategoryController,
                                      decoration: InputDecoration(
                                        hintText:
                                            _categoryController.text.isNotEmpty
                                                ? ""
                                                : "Not Selected",
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black45),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return sub_CategoryList(
                                            cat_list: sub_cat);
                                      },
                                    ).then((value) {
                                      if (value != null) {
                                        setState(() {
                                          _subcategoryController.text =
                                              value['sname'];
                                        });
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      InventoryPage(),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
