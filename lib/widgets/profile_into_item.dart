// import 'dart:ffi';
import 'package:flutter/material.dart';

class ProfileIntoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final dynamic value;
  final bool showEditIcon;
  final VoidCallback? onEditPressed;
  final Color iconColor;

  const ProfileIntoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.showEditIcon = false,
    this.onEditPressed,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            ': ${value.toString()}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        if (showEditIcon)
          InkWell(onTap: onEditPressed, child: Icon(Icons.edit)),
      ],
    );
  }
}