import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/authmodel.dart';

class OthersContent extends StatefulWidget {
  final bool isEditing;
  final Function(int, String) onDataChanged;
  final Function(String, String) updateFirestoreQuantityValue;

  const OthersContent({
    Key? key,
    required this.isEditing,
    required this.onDataChanged,
    required this.updateFirestoreQuantityValue,
  }) : super(key: key);

  @override
  State<OthersContent> createState() => _OthersContentState();
}

class _OthersContentState extends State<OthersContent> {
  List<InventoryItem> items = [];
  List<TextEditingController> textFieldControllers = [];
  int currentIndex = 0;
  PageController? _controller;

  late Stream<QuerySnapshot<Map<String, dynamic>>> inventoryStream;

  @override
  void initState() {
    super.initState();
    inventoryStream =
        FirebaseFirestore.instance.collection('Others').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: inventoryStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
            color: Color(0xff64bc26),
          )); // Loading indicator
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'No data yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Color(0xff64bc26),
              ),
            ),
          );
        }

        List<InventoryItem> items = [];
        if (snapshot.hasData) {
          items = snapshot.data!.docs.map((doc) {
            return InventoryItem(
              id: doc.id,
              result: doc['result'],
              category: doc['category'],
              quantityValue: doc['quantityValue'],
              quantity: doc['quantity'],
            );
          }).toList();
        }

        return Padding(
          padding: const EdgeInsets.only(
            top: 10.0,
          ),
          child: SingleChildScrollView(
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
                            padding:
                                const EdgeInsets.only(left: 30.0, bottom: 10),
                            child: Text(
                              'Product',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, bottom: 10),
                            child: Text(
                              'Category',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 40.0, bottom: 10),
                            child: Text(
                              'Quantity',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 10,
                  ),
                  child: Divider(),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.68,
                  child: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _controller,
                    itemCount: 1,
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
                          if (textFieldControllers.length <= index) {
                            textFieldControllers.add(TextEditingController());
                          }
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
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildInventoryItemRow(InventoryItem item, int index) {
    int? parsedValue = int.tryParse(item.quantityValue);
    bool showCircle = parsedValue != null && parsedValue < 3;

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) async {
        await FirebaseFirestore.instance
            .collection('Others')
            .doc(item.id)
            .delete();
        setState(() {
          items.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item deleted'),
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showCircle)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                      bottom: 5,
                      left: 15,
                      right: 8,
                    ),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                SizedBox(width: showCircle ? 5 : 23),
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
                      padding: EdgeInsets.only(top: 10.0, right: 20, left: 10),
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
                              child: widget.isEditing
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        top: 15,
                                      ),
                                      child: TextField(
                                        controller: textFieldControllers[index],
                                        decoration: InputDecoration(
                                          hintText: item.quantityValue,
                                        ),
                                        keyboardType: TextInputType.number,
                                        onSubmitted: (newValue) {
                                          widget.updateFirestoreQuantityValue(
                                              item.id, newValue);
                                          widget.onDataChanged(index, newValue);
                                        },
                                      ),
                                    )
                                  : Text(item.quantityValue),
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
                              padding:
                                  const EdgeInsets.only(left: 2.0, right: 1),
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
}
