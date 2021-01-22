/*
 * Copyright (c) 2020-2021, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
 */
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class IconBadge extends StatelessWidget {
  IconBadge(this.icon, {this.value, this.color = Colors.red});

  final IconData icon;
  final Object value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Badge(
      child: Icon(icon),
      badgeContent: Text(
        value.toString(),
        style: TextStyle(color: Colors.white, fontSize: 9),
      ),
      position: BadgePosition.bottomStart(bottom: 10, start: 20),
      shape: BadgeShape.square,
      borderRadius: BorderRadius.circular(10),
      badgeColor: color,
      showBadge: value != null,
    );
  }
}
