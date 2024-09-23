import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.label,
    required this.imagePath, 
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 65, 
          height: 65, 
          child: Card(
            color: Colors.white,
            child: GestureDetector(
              onTap: onPressed,
              child: Image.asset(
                imagePath,
                width: 32,
                height: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
