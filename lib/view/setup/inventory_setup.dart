import 'package:flutter/material.dart';
import 'package:inventory_app/view/setup/steps.dart';
import 'package:inventory_app/widgets/header.dart';
import 'package:inventory_app/widgets/initailButton.dart';

class InventorySetup extends StatelessWidget {
  const InventorySetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 80.0,
          left: 20,
          right: 20,
        ),
        child: Column(
          children: [
            Header(text: 'Inventory Setup'),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'We’ve developed a quick, guided walk-through to  see what you currently have in stock and/or what you usually keep on hand but might be out.\n\n'
                'This will help us start creating your grocery  predictions right away.\n\n'
                'You can save your progress at any time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff191f14),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/images/checklist.png',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            CustomButton(
              text: 'Lets go',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Steps(),
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
