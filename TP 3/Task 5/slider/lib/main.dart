import 'package:flutter/material.dart';
 import 'package:untitled_2713913369_f2f/figma_to_flutter.dart' as f2f;

void main() {
  runApp(f2f.getApp(withInit: () {
    print('Figma to Flutter initialized!');

    f2f.subscribeToEvent('pageLoaded', (e) async {
      String pageName = e.payload;
      print('$pageName Loaded');
    });

    // Get and display slider value
    f2f.subscribeToComponentEvent('onChanged', 'MySlider1', (e) {
      String value = e.payload;
      f2f.setComponentText('MySlider1Value', value);
    });
  }));
}
