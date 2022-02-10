import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  const ItemWidget({required this.string});

  final String? string;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        string!,
        maxLines: 10,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
