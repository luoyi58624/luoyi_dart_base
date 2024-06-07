import 'package:flutter/material.dart';
import 'package:luoyi_dart_base/luoyi_dart_base.dart';

class ThrottlePage extends StatefulWidget {
  const ThrottlePage({super.key});

  @override
  State<ThrottlePage> createState() => _ThrottlePageState();
}

class _ThrottlePageState extends State<ThrottlePage> {
  final controller = ScrollController();
  int count = 0;
  bool flag = true;

  /// 无参节流函数
  void addCount() {
    count++;
    setState(() {});
  }

  /// 有参数并且有返回值的节流函数
  int addCount2(int value) {
    setState(() {
      count += value;
    });
    return count;
  }

  void Function()? throttleFun;
  final String key = 'scroll_throttle';

  /// 节流包裹的实际业务逻辑，在实际业务中是不需要拆分的，直接用匿名函数包裹然后添加节流扩展函数即可
  void addCountThrottleFun() {
    int result = addCount2(100);
    i(result, '滚动节流监听');
  }

  void setListener() {
    if (throttleFun != null) {
      controller.removeListener(throttleFun!);
    }
    // 根据switch开关判断是否添加节流函数
    throttleFun = flag ? addCountThrottleFun.throttle(1000, key: key) : addCountThrottleFun;
    controller.addListener(throttleFun!);
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
        title: const Text('节流页面'),
        actions: [
          Switch(
              value: flag,
              onChanged: (v) {
                setState(() => flag = v);
                setListener();
              }),
        ],
      ),
      body: ListView.builder(
        controller: controller,
        itemBuilder: (context, index) => ListTile(
          onTap: addCount.throttle(1000),
          title: Text('节流: $count'),
        ),
      ),
    );
  }
}
