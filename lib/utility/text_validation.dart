import 'package:flutter/widgets.dart';

bool validTextValue(TextEditingController controller) {
  if (controller.text.trim() == "") {
    return false;
  } else {
    return true;
  }
}

String validTextValueReturner(TextEditingController controller) {
  return controller.text.trim();
}