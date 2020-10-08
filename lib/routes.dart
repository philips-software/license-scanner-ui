/*
 * This software and associated documentation files are
 *
 * Copyright © 2020-2020 Koninklijke Philips N.V.
 *
 * and is made available for use within Philips and/or within Philips products.
 *
 * All Rights Reserved
 */

import 'package:flutter/cupertino.dart';

import 'screens/latest/latest_screen.dart';
import 'screens/scan/scan_screen.dart';
import 'screens/search/search_screen.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (_) => LatestScreen(),
  'scan': (_) => ScanScreen(),
  'search': (_) => SearchScreen(),
};
