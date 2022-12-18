import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BINGO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      // routes: {
      //   '/': (context) => MyHomePage(),
      //   'BingoView': (context) => BingoView(),
      // },
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  final TextEditingController myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BINGO'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: myController,
            keyboardType: TextInputType.number,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: "請輸入所需的數字",
              hintText: "請輸入所需的數字",
            ),
          ),
          TextButton(
            onPressed: () {
              final text = myController.text;
              // print(myController.text);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BingoView(text: text),
                ),
              );
              // Navigator.of(context).pushNamed('BingoView',
              //     arguments: int.parse(myController.text));
            },
            child: const Text("確定"),
          ),
        ],
      ),
    );
  }
}

class BingoView extends StatefulWidget {
  final String text;

  const BingoView({Key? key, required this.text}) : super(key: key);

  @override
  State<BingoView> createState() => _BingoViewState();
}

class _BingoViewState extends State<BingoView> with TickerProviderStateMixin {
  //輸入的變數
  int number = 0;
  //被選中的變數
  int select = -1;
  //被選中的列表
  List selectNum = [];
  //輸入數字的列表
  List numList = [];
  //選中列表
  List choose = [];
  //動畫控制器
  late AnimationController _controller;
  //補間動畫
  late final Animation<num> _animation =
      Tween<num>(begin: 1, end: number).animate(_controller);

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 30),
      vsync: this,
    );
    number = int.parse(widget.text);
    numList = List.generate(number, (index) => index + 1);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BINGO'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 45),
                shrinkWrap: true,
                itemCount: number,
                itemBuilder: (_, index) {
                  bool isSelect = selectNum.contains(index);
                  return Container(
                    decoration: BoxDecoration(
                      color: isSelect ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(10000),
                    ),
                    child: Center(
                      child: Text("${index + 1}"),
                    ),
                  );
                }),
            SizedBox(
              height: 40,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    select = -1;
                    _controller.repeat();
                  });
                  showDialog(
                      context: context,
                      builder: (_) {
                        return buildDialog();
                      });
                },
                child: const Text("抽選"),
              ),
            ),
            GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 45),
                itemCount: choose.length,
                itemBuilder: (_, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10000),
                    ),
                    child: Center(
                      child: Text("${choose[index]}"),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  Dialog buildDialog() {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
        Radius.circular(10000),
      )),
      child: GestureDetector(
        onTap: () {
          setState(() {
            do {
              select = Random().nextInt(numList.length);
            } while (selectNum.contains(select));
            selectNum.contains(select) ? null : selectNum.add(select);
            choose.add(select + 1);
            // print(select);
          });
          _controller.reset();
          Timer(const Duration(seconds: 3), () {
            Navigator.pop(context);
          });
        },
        child: Container(
          height: 300,
          width: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10000),
            ),
            color: Colors.red,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: _controller.drive(
                    IntTween(begin: 1, end: number),
                  ),
                  builder: (context, Widget? child) {
                    return Text(
                      select == -1
                          ? _animation.value.toStringAsFixed(0)
                          : "${select + 1}",
                      style: const TextStyle(fontSize: 96),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
