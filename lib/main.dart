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

class _BingoViewState extends State<BingoView> {
  int number = 0;
  int select = 0;
  int showNum = 0;
  List selectNum = [];
  List numList = [];
  List selList = [];
  List choose = [];

  @override
  void initState() {
    number = int.parse(widget.text);
    numList = List.generate(number, (index) => index + 1);
    print(numList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // dynamic obj = ModalRoute.of(context)?.settings.arguments;
    // number = obj;
    // numList = List.generate(number, (index) => index + 1);

    return Scaffold(
        appBar: AppBar(
          title: const Text('BINGO'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 9,
                ),
                itemCount: number,
                itemBuilder: (_, index) {
                  bool isSelect = selectNum.contains(index);
                  return Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: isSelect ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text("${index + 1}"),
                    ),
                  );
                },
              ),
              // GridView.count(
              //   crossAxisCount: 9,
              //   children: List.generate(number, (index) {
              //     bool isSelect = selectNum.contains(index);
              //     return Center(
              //       child: Container(
              //         height: 50,
              //         width: 50,
              //         decoration: BoxDecoration(
              //           color: isSelect ? Colors.red : Colors.green,
              //           borderRadius: BorderRadius.circular(30),
              //         ),
              //         child: Center(
              //           child: Text("${index + 1}"),
              //         ),
              //       ),
              //     );
              //   }),
              // ),
            ),
            SizedBox(
              height: 30,
              width: 50,
              child: TextButton(
                onPressed: () {
                  // select = Random().nextInt(numList.length);
                  // while (selectNum.contains(select) ||
                  //     selectNum.length == numList.length) {
                  //   Random().nextInt(numList.length);
                  // }
                  do {
                    select = Random().nextInt(numList.length);
                  } while (selectNum.contains(select) ||
                      selectNum.length == numList.length);
                  setState(() {
                    print(select);
                    selectNum.contains(select) ? null : selectNum.add(select);
                    print(selectNum);
                    choose.add(select + 1);
                  });
                },
                child: const Text("點擊"),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10),
                  itemCount: choose.length,
                  itemBuilder: (_, index) {
                    return Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text("${choose[index]}"),
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}
