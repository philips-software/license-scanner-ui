import 'package:flutter/cupertino.dart';
import 'package:license_scanner_ui/screens/search_screen.dart';

import 'screens/scans_screen.dart';

final Map<String, WidgetBuilder> routes = {
 '/' : (_) => ScansScreen(),
 'search': (_) => SearchScreen(),
};
