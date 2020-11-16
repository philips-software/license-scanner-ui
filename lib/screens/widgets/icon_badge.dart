/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  IconBadge(this.icon, {this.value, this.color = Colors.red});

  final IconData icon;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Badge(
      child: Icon(icon),
      badgeContent: Text(
        value.toString(),
        style: TextStyle(color: Colors.white),
      ),
      position: BadgePosition.bottomStart(bottom: 10, start: 20),
      shape: BadgeShape.square,
      borderRadius: BorderRadius.circular(10),
      badgeColor: color,
      showBadge: value > 0,
    );
  }
}
