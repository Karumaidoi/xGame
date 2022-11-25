import 'dart:async';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'xgame',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  bool getStarted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/game.jpg'),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: getStarted
              ? SizedBox(
                  height: 10,
                  width: MediaQuery.of(context).size.width * .4,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(seconds: 150),
                    curve: Curves.easeInOut,
                    tween: Tween<double>(
                      begin: 0,
                      end: 100,
                    ),
                    builder: (context, value, _) =>
                        LinearProgressIndicator(value: value),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      getStarted = true;
                    });
                    AssetsAudioPlayer.newPlayer().open(
                      Audio("assets/start.wav"),
                      showNotification: false,
                    );

                    Timer(const Duration(seconds: 8), () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const SplashScreen()));
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(100)),
                    child: const Center(
                      child: Text(
                        'Start',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Remachine'),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int highestScore = 0;
  int score = 20;
  int numberGuess = 0;
  int userGuess = 0;
  bool hasWon = false;
  String state = 'Between 1 and 20';
  final assetsAudioPlayer = AssetsAudioPlayer();

  TextEditingController _controller = TextEditingController();

  late ConfettiController controller;

  @override
  void initState() {
    Random random = Random();
    numberGuess = random.nextInt(21);
    print(numberGuess);
    controller = ConfettiController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          '',
          style: TextStyle(
              color: Colors.white, fontFamily: 'Remachine', fontSize: 36),
        ),
        centerTitle: true,
      ),
      body: ConfettiWidget(
        confettiController: controller,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        colors: const [Colors.green, Colors.pink, Colors.yellow, Colors.purple],
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/game.jpg'),
            fit: BoxFit.cover,
          )),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Text(
                        "<$state>",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    'Guess My Number!',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Remachine'),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    height: 120,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        hasWon ? '$numberGuess' : '?',
                        style: const TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: Text(
                    '💯 Score:     $score',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '🥇 Highscore:     $highestScore',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: TextFormField(
                        controller: _controller,
                        onChanged: (value) {
                          setState(() {
                            userGuess = int.parse(value);
                          });
                        },
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 33,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: TextStyle(
                              fontSize: 33,
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  hasWon
                      ? GestureDetector(
                          onTap: () {
                            assetsAudioPlayer.stop();
                            assetsAudioPlayer.dispose();
                            controller.stop();
                            setState(() {
                              Random random = Random();
                              numberGuess = random.nextInt(21);
                              score = 20;
                              hasWon = false;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 45,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'New Game',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Remachine'),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (userGuess != numberGuess) {
                              setState(() {
                                score--;
                              });

                              final snackBar = SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(15),
                                content: Text(
                                  'Wrong Guess! $state',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 122, 11, 4),
                              );

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              if (userGuess > numberGuess) {
                                setState(() {
                                  state = 'Guess to high😡';
                                });
                              } else if (userGuess < numberGuess) {
                                setState(() {
                                  state = 'Guess too low😡';
                                });
                              } else {
                                state = 'Between 1 and 20';
                              }
                            } else {
                              assetsAudioPlayer.open(Audio('assets/done.wav'));
                              setState(() {
                                controller.play();
                                hasWon = true;
                                state = 'Between 1 and 20';
                                if (score > highestScore) {
                                  highestScore = score;
                                }
                                _controller.text = '';
                              });
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 45,
                            decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'Guess',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Remachine'),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
