import 'package:flutter/material.dart';
import 'package:luoyi_dart_base/luoyi_dart_base.dart';

class DebouncePage extends StatefulWidget {
  const DebouncePage({super.key});

  @override
  State<DebouncePage> createState() => _DebouncePageState();
}

class _DebouncePageState extends State<DebouncePage> {
  final controller = ScrollController();
  String inputValue = '';
  int count = 0;
  bool flag = true;

  void addCount() {
    setState(() {
      count++;
    });
  }

  /// input
  void setInputValue(String? value) {
    i(value);
    setState(() {
      inputValue = value ?? '';
    });
  }

  void Function()? debounceFun;
  final String key = 'scroll_debounce';

  void scrollDebounceFun() {
    addCount();
    i(count, '滚动防抖监听');
  }

  void setListener() {
    if (debounceFun != null) {
      controller.removeListener(debounceFun!);
    }
    // 根据switch开关判断是否添加节流函数
    debounceFun = flag ? scrollDebounceFun.debounce(500, key: key) : scrollDebounceFun;
    controller.addListener(debounceFun!);
  }

  @override
  void initState() {
    super.initState();
    setListener();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('防抖页面'),
        actions: [
          Switch(
              value: flag,
              onChanged: (v) {
                setState(() => flag = v);
                setListener();
              }),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: addCount.debounce(2000),
            child: Text('防抖，2秒后更新值：$count'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(onChanged: (v) => (() => setInputValue(v)).debounce(1000, key: 'update_input')()),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemBuilder: (context, index) => ListTile(
                title: Text('${index + 1}.文本框内容: $inputValue'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
