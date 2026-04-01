import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test_payment_with_getaways/core/utils/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.isLoiding = false,
    required this.text,
  });

  final void Function()? onTap;
  final bool isLoiding;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: ShapeDecoration(
          color: const Color(0xFF34A853),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Center(
          child: isLoiding
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(text, textAlign: TextAlign.center, style: Styles.style22),
        ),
      ),
    );
  }
}
