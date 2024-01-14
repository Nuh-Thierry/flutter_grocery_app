import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final bool isActive;

  CustomButton({
    required this.text,
    required this.onPressed,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    Color activeColor = Color(0xff64bc26);
    Color inactiveColor = Color(0xffd1f1bb);

    return isActive
        ? ElevatedButton(
            onPressed: onPressed as void Function()?,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 60),
              backgroundColor: activeColor,
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          )
        : Container(
            // Simulate disabled appearance
            width: MediaQuery.of(context).size.width * 0.9,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: inactiveColor,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          );
  }
}
