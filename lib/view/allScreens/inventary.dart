import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/widgets/inventary/fridgecontent.dart';
import 'package:inventory_app/widgets/inventary/otherscontent.dart';
import 'package:inventory_app/widgets/inventary/pantrycontent.dart';

import 'addInventary.dart/addInventary.dart';

class InventaryScreen extends StatefulWidget {
  const InventaryScreen({Key? key}) : super(key: key);

  @override
  State<InventaryScreen> createState() => _InventaryScreenState();
}

class _InventaryScreenState extends State<InventaryScreen> {
  bool isEditing = false;
  bool isAddVisible = true;
  List<Map<String, dynamic>> fridgeData = [];
  Map<String, String> collectionNames = {
    'Fridge': 'Fridge',
    'Pantry': 'Pantry',
    'Others': 'Others',
  };

  List<String> labels = ['Fridge', 'Pantry', 'Others'];
  List<bool> isSelected = [true, false, false];

  Future<void> updateQuantity(String documentId, String newValue) async {
    try {
      String selectedContentType = labels[isSelected.indexOf(true)];
      String collectionName = collectionNames[selectedContentType] ?? '';
      if (collectionName.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentId)
            .update({'quantityValue': newValue});
        print('Quantity updated successfully');
      } else {
        print('Invalid content type: $selectedContentType');
      }
    } catch (error) {
      print('Error updating quantity: $error');
    }
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                    'Inventory',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff191f14),
                    ),
                  ),
                ),
                isEditing
                    ? SizedBox()
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddInventory(
                                collectionNames:
                                    collectionNames, // Pass the map here
                                labels: labels,
                                currentIndex: isSelected
                                    .indexOf(true), // Pass the list here
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Color(0xff000000),
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          height: 20,
                          width: 20,
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 18,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isEditing) {
                        for (var data in fridgeData) {
                          updateQuantity(
                            data['documentId'],
                            data['quantityValue'],
                          );
                        }
                      }
                      isEditing = !isEditing;
                      isAddVisible = !isAddVisible;
                    });
                  },
                  child: isEditing
                      ? Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff64bc26),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Icon(
                            Icons.edit,
                            size: 24,
                            color: Color(0xff64bc26),
                          ),
                        ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Color(0xff64bc26),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  for (int index = 0; index < labels.length; index++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == index;
                          }
                        });
                      },
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.2983,
                        decoration: BoxDecoration(
                          color: isSelected[index]
                              ? Color(0xff64bc26)
                              : Colors.transparent,
                          border: Border.all(
                            width: 0.5,
                            color: Color(0xff64bc26),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: isSelected[index]
                                  ? Colors.white
                                  : Color(0xff64bc26),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: IndexedStack(
                index: isSelected.indexOf(true),
                children: [
                  SingleChildScrollView(
                    child: InventaryContent(
                      isEditing: isEditing,
                      onDataChanged: (index, newValue) {
                        setState(() {
                          fridgeData[index]['quantityValue'] = newValue;
                        });
                      },
                      updateFirestoreQuantityValue: updateQuantity,
                    ),
                  ),
                  SingleChildScrollView(
                    child: PantryContent(
                      isEditing: isEditing,
                      onDataChanged: (index, newValue) {
                        setState(() {
                          fridgeData[index]['quantityValue'] = newValue;
                        });
                      },
                      updateFirestoreQuantityValue: updateQuantity,
                    ),
                  ),
                  SingleChildScrollView(
                    child: OthersContent(
                      isEditing: isEditing,
                      onDataChanged: (index, newValue) {
                        setState(() {
                          fridgeData[index]['quantityValue'] = newValue;
                        });
                      },
                      updateFirestoreQuantityValue: updateQuantity,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
