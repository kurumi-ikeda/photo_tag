import 'package:flutter/foundation.dart';

class ResultSelectionProvider extends ChangeNotifier {
  bool get isSelectionState => _isSelectionState;
  ResultSelectionProvider() {
    initValue();
  }
  bool _isSelectionState = false;

  void initValue() {
    _isSelectionState = false;
  }

  void refresh() {
    initValue();
    notifyListeners(); // Providerを介してConsumer配下のWidgetがリビルドされる
  }

  changeIsSelectionState() {
    _isSelectionState = !_isSelectionState;
    notify();
  }

  void notify() {
    notifyListeners(); // Providerを介してConsumer配下のWidgetがリビルドされる
  }
}
