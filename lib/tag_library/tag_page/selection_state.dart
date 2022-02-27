import 'package:flutter/cupertino.dart';

class SelectionState {
  static bool isSelectionState = false;

  static changeIsSelectionState() {
    isSelectionState = !isSelectionState;
  }
}
