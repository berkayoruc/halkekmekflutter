import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'map.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Gilroy'),
      home: const SafeArea(child: MapPage()),
    );
  }
}
