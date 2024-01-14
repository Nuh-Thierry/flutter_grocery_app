import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/widgets/initailButton.dart';

import '../../model/authmodel.dart';
import '../../model/steps.dart';

class ShoppingMode extends StatefulWidget {
  ShoppingMode({Key? key}) : super(key: key);

  @override
  State<ShoppingMode> createState() => _ShoppingModeState();
}

class _ShoppingModeState extends State<ShoppingMode> {
  bool showSearchResults = false;
  List<InventoryItem> items = [];
  int currentIndex = 0;
  PageController? _controller;

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  List<TextEditingController> quantityControllers = [];

  void clearSearch() {
    setState(() {
      _textEditingController.clear();
    });
  }

  void initState() {
    _controller = PageController(initialPage: 0);
    fetchFirestoreData();
    super.initState();
  }

  void fetchFirestoreData() async {
    final firestore = FirebaseFirestore.instance;
    final collections = ['Fridge', 'Pantry', 'Others'];

    for (final collectionName in collections) {
      final querySnapshot = await firestore.collection(collectionName).get();

      for (final docSnapshot in querySnapshot.docs) {
        final inventoryItem = InventoryItem(
          id: docSnapshot.id,
          result: docSnapshot['result'],
          category: docSnapshot['category'],
          quantity: docSnapshot['quantity'],
          quantityValue: docSnapshot['quantityValue'],
        );
        setState(() {
          items.add(inventoryItem);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 80.0,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xff191f14),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: Text(
                      'Shopping Mode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff191f14),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _controller,
                    itemCount: contents.length,
                    onPageChanged: (int index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemBuilder: (_, i) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          Color backgroundColor = index == 0
                              ? Colors.white
                              : (index % 2 == 1
                                  ? Color(
                                      0xffe5ebe0,
                                    )
                                  : Colors.white);

                          return Container(
                            color: backgroundColor,
                            child: Center(
                                child:
                                    buildInventoryItemRow(items[index], index)),
                          );
                        },
                      );
                    }),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1.5,
                        color: Color(
                          0xff64bc26,
                        ),
                      )),
                  child: Center(
                    child: Text(
                      'Scan Receipt',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff64bc26),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                text: 'Confirm',
                onPressed: () {},
                isActive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildInventoryItemRow(InventoryItem item, int index) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  activeColor: Color(0xff64bc26),
                  value: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                    side: BorderSide(
                      color: Color(0xff64bc26),
                    ),
                  ),
                  onChanged: (newValue) {
                    // Handle checkbox value change here
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 8, right: 8),
                  child: Text(
                    item.result,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 8, right: 8),
                  child: Text(
                    item.category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, right: 10, left: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 45,
                          height: 36,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color(0xff999999),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(item.quantityValue),
                          ),
                        ),
                        SizedBox(width: 5),
                        Container(
                          width: 48,
                          height: 36,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color(0xff999999),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2.0, right: 1),
                            child: Center(
                              child: Text(item.quantity),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
