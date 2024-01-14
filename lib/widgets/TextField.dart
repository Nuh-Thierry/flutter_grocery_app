import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CodeScanner {
  Future<void> scanCode(
      BuildContext context, Function(String, String) onCodeScanned) async {
    try {
      final ScanResult result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        await fetchProductDetails(result.rawContent, onCodeScanned);
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Camera Access Denied"),
            content: Text("Please grant camera permission to use the scanner."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    } on FormatException {
      // Handle user pressing the back button or cancel
    } catch (e) {
      // Handle other errors
    }
  }

  Future<void> fetchProductDetails(
      String code, Function(String, String) onCodeScanned) async {
    final apiUrl = 'https://world.openfoodfacts.org/api/v0/product/$code.json';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final productName = data['product']['product_name'] ?? '';
        final category =
            data['product']['categories_tags'][0]?.split(':')[1] ?? '';
        onCodeScanned(productName, category);
      } else {
        // Handle API error
      }
    } catch (e) {
      // Handle fetch error
    }
  }
}

class SearchTextField extends StatefulWidget {
  final String text;
  final Function(String, String) onResultSelected;
  final TextEditingController? textEditingController;

  const SearchTextField({
    Key? key,
    required this.text,
    required this.onResultSelected,
    this.textEditingController,
  }) : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  CodeScanner _codeScanner = CodeScanner();
  TextEditingController _textEditingController = TextEditingController();
  Timer? _debounce;

  void _onSearchTextChanged(String value) {
    if (_debounce != null && _debounce!.isActive) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        searchText = value;
        fetchSearchResults();
      });
    });
  }

  String searchText = '';
  List<String> searchResults = [];
  List<String> categoryResults = [];
  bool isTyping = false;
  bool showSearchResults = false;

  void clearSearch() {
    setState(() {
      _textEditingController.clear();
      searchText = '';
      searchResults.clear();
      isTyping = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _textEditingController =
        widget.textEditingController ?? TextEditingController();
  }

  Future<void> fetchSearchResults() async {
    if (searchText.isEmpty) {
      return;
    }
    final apiUrl =
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$searchText&json=true';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final products = data['products'];
      final List<String> parsedResults = List<String>.from(products.map(
          (product) => product['product_name'] != null
              ? product['product_name'] as String
              : ''));

      final List<String> categories = List<String>.from(products.map(
          (product) => product['categories'] != null
              ? product['categories'].split(',')[0] as String
              : ''));

      setState(() {
        searchResults = parsedResults;
        categoryResults = categories;
      });
    }
  }

  void _handleScannedCode(String productName, String category) async {
    await fetchSearchResults();
    setState(() {
      searchText = productName;
      showSearchResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isTyping) {
            clearSearch();
          }
          isTyping = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              spreadRadius: 0,
              offset: Offset(0, 0),
              blurRadius: 8,
              color: Color(
                0xffcccccc,
              ),
            ),
          ],
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            // width: 1.5,
            color: Color(
              0xffcccccc,
            ),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            TextFormField(
              controller: _textEditingController,
              onTap: () {
                setState(() {
                  isTyping = true;
                  showSearchResults = true;
                });
              },
              onChanged: (value) {
                setState(() {
                  searchText = value;
                  fetchSearchResults();
                  showSearchResults = true;
                });
              },
              onFieldSubmitted: (value) {
                _onSearchTextChanged;
                showSearchResults = true;
              },
              decoration: InputDecoration(
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: isTyping || searchText.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              clearSearch();
                            });
                          },
                          child: Icon(Icons.cancel),
                        )
                      : GestureDetector(
                          onTap: () async {
                            setState(() {
                              if (isTyping) {
                                clearSearch();
                              }
                              isTyping = false;
                              showSearchResults = false;
                            });

                            _codeScanner.scanCode(
                              context,
                              _handleScannedCode,
                            );
                          },
                          child: Image.asset('assets/images/suffix.png'),
                        ),
                ),
                hintText: widget.text,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffcccccc),
                ),
                border: isTyping
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26.0),
                        borderSide: BorderSide(
                          color: Color(0xffcccccc),
                        ),
                      ),
                focusedBorder: isTyping
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26.0),
                        borderSide: BorderSide(
                          color: Color(0xffcccccc),
                        ),
                      ),
                enabledBorder: isTyping
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(26.0),
                        borderSide: BorderSide(
                          color: Color(0xffcccccc),
                        ),
                      ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
              ),
              cursorColor: Color(0xffcccccc),
            ),
            if (showSearchResults && searchResults.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      widget.onResultSelected(
                          searchResults[index], categoryResults[index]);
                      setState(() {
                        searchText = searchResults[index];
                        searchResults.clear();
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        children: [
                          Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Color(0xff000000),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                searchResults[index],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff191f14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
