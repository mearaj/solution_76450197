import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class SoloModeLogic {
  String currentMode = "none";
  bool isFreezeColor = false;

  final audioPlayer = AudioPlayer()..setSource(AssetSource('tick.mp3'));
  int quizTime = 10;
  final CountDownController countDownController = CountDownController();


  // The length indicates
  List<bool> threshold = [false, false ,false,false,false];

  onTimeOut({required BuildContext context}) {
    print("time out");
    audioPlayer.pause();
    //restartCountdown();
  }
  // Please not that it's not called at every second change but instead
  // called on more smaller unit of second second.
  // Hence it could be called multiple times per second
  void onCountdownChange(String v) {
    int vInt = int.parse(v);
    if (vInt > 0 && vInt < threshold.length + 1 && !threshold[vInt-1]) {
      audioPlayer.pause();
      threshold[vInt-1] = true;
      //audioPlayer.seek(const Duration(milliseconds: 0));
      audioPlayer.resume();
    } else if (vInt == 0) {
      audioPlayer.pause();
    }
  }


  void restartCountdown() {
    audioPlayer.pause();
    threshold = threshold.map((e) => false).toList();
    countDownController.restart(duration: quizTime);
  }
}

final _soloModeLogic = SoloModeLogic();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return returnSmQuizBodyWidget(context: context);
  }

  /// Returns Body as per mode or mode conditions
  Widget returnSmQuizBodyWidget({required BuildContext context}) {
    if (_soloModeLogic.currentMode == 'Exclusive') {
      return const Text("Exclusive Mode");
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //-----------------------   Question Container
          Stack(
            clipBehavior: Clip.none,
            children: [
              //-----------------------   Question Frame
              const Text("My Question"),

              //-----------------------   Timer
              Positioned(
                right: 0,
                left: 0,
                top: (MediaQuery.of(context).size.height / 2),
                child: CircularCountDownTimer(
                  duration: _soloModeLogic.quizTime,
                  initialDuration: 0,
                  controller: _soloModeLogic.countDownController,
                  width: 50,
                  height: 70,
                  ringColor: Colors.grey.shade400,
                  ringGradient: null,
                  fillColor: _soloModeLogic.isFreezeColor
                      ? Colors.lightBlueAccent
                      : Colors.red,
                  fillGradient: null,
                  backgroundColor: const Color(0xfff5f5f5),
                  backgroundGradient: null,
                  strokeWidth: 4,
                  strokeCap: StrokeCap.butt,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: _soloModeLogic.isFreezeColor
                        ? Colors.lightBlueAccent
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textFormat: CountdownTextFormat.S,
                  isReverse: true,
                  isReverseAnimation: false,
                  isTimerTextShown: true,
                  autoStart: false,
                  onStart: () {},
                  onChange: _soloModeLogic.onCountdownChange,
                  onComplete: () => _soloModeLogic.onTimeOut(context: context),
                ),
              ),
            ],
          ),
          FloatingActionButton(
            onPressed: () {
              _soloModeLogic.restartCountdown();
            },
            child: Text("Start"),
          ),
          // This trailing comma makes auto-formatting nicer for build methods.
        ],
      );
    }
  }
}
