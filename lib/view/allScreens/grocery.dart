import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/widgets/Grocery/otherscontent.dart';
import '../../widgets/Grocery/fridgecontent.dart';
import '../../widgets/Grocery/pantrycontent.dart';

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({Key? key}) : super(key: key);

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
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
          left: 0,
          right: 0,
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
                    'Grocery list',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff191f14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'option1',
                          child: Text(
                            'send to shopping mode',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(
                                0xff191f14,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'option2',
                          child: Text(
                            'Share to Household',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(
                                0xff191f14,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'option2',
                          child: Text(
                            'Add items to list',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(
                                0xff191f14,
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    onSelected: (value) {
                      // Handle menu item selection here
                      if (value == 'option1') {
                        // Handle option 1
                      } else if (value == 'option2') {
                        // Handle option 2
                      }
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Image.asset('assets/images/Danger-Circle.png'),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Uncheck one-time purchases',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(
                        0xff666666,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
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
                    child: InventaryContent1(
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
                    child: PantryContent1(
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
                    child: OthersContent1(
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
