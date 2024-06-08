
import 'package:flutter/material.dart';

import 'debounce.dart';
import 'throttle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ThrottlePage()));
            },
            title: const Text('节流测试'),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DebouncePage()));
            },
            title: const Text('防抖测试'),
          ),
        ],
      ),
    );
  }
}
