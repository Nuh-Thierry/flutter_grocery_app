import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/widgets/TextField.dart';
import 'package:inventory_app/widgets/initailButton.dart';

import '../../../model/authmodel.dart';
import '../../../model/steps.dart';

class AddInventory extends StatefulWidget {
  final Map<String, String> collectionNames;
  final List<String> labels;
  final int currentIndex;
  AddInventory({
    Key? key,
    required this.collectionNames,
    required this.labels,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {
  bool showSearchResults = false;
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

  List<String> selectedResults = [];
  List<String> selectedCategories = [];
  List<String> selectedQuantities = [];
  int selectedProductIndex = -1;

  List<String> quantityOptions = ['kg', 'lbs', 'ml', 'st'];
  bool isExpanded = false;

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> saveToFirestore() async {
    final firestore = FirebaseFirestore.instance;

    try {
      String selectedContentType = widget.labels[widget.currentIndex];
      String collectionName = widget.collectionNames[selectedContentType] ?? '';

      if (collectionName.isNotEmpty) {
        final docRef = firestore.collection(collectionName).doc();
        for (int i = 0; i < selectedResults.length; i++) {
          final inventoryItem = InventoryItem(
            id: docRef.id,
            result: selectedResults[i],
            category: selectedCategories[i],
            quantity: selectedQuantities[i],
            quantityValue: quantityControllers[i].text,
          );
          await docRef.set(inventoryItem.toMap());
        }
      } else {
        print('Invalid content type: $selectedContentType');
      }
    } catch (e) {
      print('Error saving data to Firestore: $e');
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
            left: 20,
            right: 20,
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
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xff191f14),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: Text(
                      'Inventory',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff191f14),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              SearchTextField(
                text: 'Search anything...',
                onResultSelected: (result, category) {
                  setState(() {
                    selectedResults.add(result);
                    selectedCategories.add(category);
                    selectedQuantities.add('OZ');

                    TextEditingController controller = TextEditingController(
                      text: '1',
                    );
                    quantityControllers.add(controller);

                    selectedProductIndex = selectedResults.length - 1;
                    showSearchResults = false;
                  });
                },
              ),
              SizedBox(height: 50),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: contents.length,
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemBuilder: (_, i) {
                    if (selectedResults.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Table(
                              border: TableBorder.symmetric(
                                inside: BorderSide.none,
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, bottom: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Product',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          bottom: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Category',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 40.0,
                                          bottom: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Quantity',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            for (int i = 0; i < selectedResults.length; i++)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Table(
                                  border: TableBorder.symmetric(
                                    inside: BorderSide.none,
                                  ),
                                  children: [
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  selectedResults[i],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  selectedCategories[i],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 18.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 45,
                                                      height: 36,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Color(
                                                            0xff999999,
                                                          ),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 8.0,
                                                          bottom: 3,
                                                        ),
                                                        child: TextFormField(
                                                          controller:
                                                              quantityControllers[
                                                                  i],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            isDense: true,
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          onChanged: (value) {
                                                            if (selectedProductIndex ==
                                                                i) {
                                                              selectedQuantities[
                                                                  i] = value;
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                      width: 48,
                                                      height: 36,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          width: 1,
                                                          color: Color(
                                                            0xff999999,
                                                          ),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 2.0,
                                                          right: 1,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              selectedQuantities[
                                                                  i],
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .keyboard_arrow_down,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Handle when selectedResults is empty
                      return Container();
                    }
                  },
                ),
              ),
              CustomButton(
                text: 'Add Item',
                onPressed: () async {
                  await saveToFirestore();
                  setState(() {
                    selectedResults.clear();
                    selectedCategories.clear();
                    selectedQuantities.clear();
                    quantityControllers.clear();
                    selectedProductIndex = -1;
                  });
                },
                isActive: selectedResults.isNotEmpty,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
