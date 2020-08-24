import 'package:flutter/cupertino.dart';
import 'package:license_scanner_ui/screens/scans/search_screen.dart';

import 'screens/scans/scans_screen.dart';

final Map<String, WidgetBuilder> routes = {
 '/' : (_) => ScansScreen(),
 'search': (_) => SearchScreen(),
};
