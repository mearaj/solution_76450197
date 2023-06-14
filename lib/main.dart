import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int quizTime = 10;
  int thresholdTime = 5;
  final CountDownController _controller = CountDownController();
  final player = AudioPlayer();

  bool isAudioPlaying = false;


  // Please not that it's not called at every second change but instead
  // called on more smaller unit of second second.
  // Hence it could be called multiple times per second
  void onCountdownChange(v) {
    int vInt = int.parse(v);
    if (!isAudioPlaying && vInt > 0 && vInt <= thresholdTime) {
      // Do not call setUpdate here, we don't need to rerender UI here
      isAudioPlaying = true;
       player.seek(const Duration(milliseconds: 0));
       player.resume();
    }
  }

  @override
  void initState() {
    super.initState();
    player.setSource(AssetSource('tick.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: CircularCountDownTimer(
            duration: quizTime,
            initialDuration: 0,
            controller: _controller,
            width: 50,
            height: 50,
            ringColor: Colors.grey.shade400,
            ringGradient: null,
            fillColor: _controller.isPaused
                ? Colors.lightBlueAccent
                : Colors.redAccent,
            fillGradient: null,
            backgroundColor: const Color(0xfff5f5f5),
            backgroundGradient: null,
            strokeWidth: 4,
            strokeCap: StrokeCap.butt,
            textStyle: TextStyle(
              fontSize: 20,
              color: _controller.isPaused
                  ? Colors.blueAccent
                  : Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textFormat: CountdownTextFormat.S,
            isReverse: true,
            isReverseAnimation: false,
            isTimerTextShown: true,
            autoStart: false,
            onStart: () {},
            onChange: onCountdownChange,
            onComplete: () {
              player.pause();
              setState(() {
                isAudioPlaying = false;
              });
              print("on Complete");
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:  (){
          player.pause();
          isAudioPlaying = false;
          _controller.restart(duration: quizTime);
        },
        tooltip: 'Start',
        child: Text("Start"),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
