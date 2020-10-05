/*
 * Copyright (c) 2020-2020, Koninklijke Philips N.V., https://www.philips.com
 * SPDX-License-Identifier: MIT
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
