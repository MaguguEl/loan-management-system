import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TITHANDIDZANE CLUB',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list_alt),
                onPressed: () {
                  // Add sorting logic
                },
              ),
              IconButton(
                icon: const Icon(Icons.sort),
                onPressed: () {
                  // Add filtering logic
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
