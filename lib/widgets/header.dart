import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String text;
  final String? text1;

  Header({
    Key? key,
    required this.text,
    this.text1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.arrow_back_ios,
          color: Color(
            0xff191f14,
          ),
        ),
        SizedBox(
          width: 100,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(
                0xff191f14,
              ),
            ),
          ),
        ),
        if (text1 != null)
          Text(
            text1!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(
                0xff64bc26,
              ),
            ),
          ),
      ],
    );
  }
}
