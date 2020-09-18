import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void showError(BuildContext context, String message) {
  Toast.show(message, context);
}
