import 'dart:async';
import 'package:final_620710333/model/game.dart';
import 'package:final_620710333/service/api.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Game>? game_list;
  int count = 0;
  int incorrect = 0;
  String word = "";

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    List list = await Api().fetch('quizzes');
    setState(() {
      game_list = list.map((item) => Game.fromJson(item)).toList();
    });
  }

  void guess(String choice) {
    setState(() {
      if (game_list![count].answer == choice) {
        word = "ใช่แล้วหล่ะ เก่งมาก ๆ เลยคร้าบบบบ 😊👍🏻";
      } else {
        word = "ยังไม่ถูกนะครับผม ไม่เป็นไรลองใหม่อีกครั้งครับ 😎✌️";
      }
    });
    Timer timer = Timer(Duration(seconds: 2), () {
      setState(() {
        word = "";
        if (game_list![count].answer == choice) {
          count++;
        } else {
          incorrect++;
        }
      });
    });
  }

  Widget printGuess() {
    if (word.isEmpty) {
      return SizedBox(height: 20, width: 10);
    } else if (word == "เยี่ยมมากเลยล่ะครับ คนเก่ง อย่าลืมหารางวัลให้ตัวเองนะ 💕😍") {
      return Text(word);
    } else {
      return Text(word);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: game_list != null && count < game_list!.length-1
          ? buildQuiz()
          : game_list != null && count == game_list!.length-1
          ? buildTryAgain()
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildTryAgain() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('End Game - จบเกมแล้วคร้าบบบ'),
            Text('ทายผิดไป ${incorrect} ครั้ง พยายามเข้านะเจ้าตัวเล็ก'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    incorrect = 0;
                    count = 0;
                    game_list = null;
                    _fetch();
                  });
                },
                child: Text('New Game - เรามาเริ่มกันใหม่นะครับ 🌻🍨'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildQuiz() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(game_list![count].image_url, fit: BoxFit.cover),
            Column(
              children: [
                for (int i = 0; i < game_list![count].choices.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () =>
                                guess(game_list![count].choices[i].toString()),
                            child: Text(game_list![count].choices[i]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            printGuess(),
          ],
        ),
      ),
    );
  }
}
