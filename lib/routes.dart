import 'package:flutter/cupertino.dart';
import 'package:license_scanner_ui/screens/scan/scan_screen.dart';
import 'package:license_scanner_ui/screens/search/search_screen.dart';

import 'screens/latest/latest_screen.dart';

final Map<String, WidgetBuilder> routes = {
 '/' : (_) => LatestScreen(),
 'scan': (_) => ScanScreen(),
 'search': (_) => SearchScreen(),
};
