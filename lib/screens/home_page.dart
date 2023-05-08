import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jarvis/service/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../service/openai_service.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  final commandController = TextEditingController();
  int seconds = 0;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
    systemSpeak('How may i help you today sir');
    // startTimer();
    getData();
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    final getName = prefs.getString('name');
    bossName = getName ?? '';
    final getEmail = prefs.getString('email');
    userEmailId = getEmail ?? '';
    final getApi = prefs.getString('apiKey');
    openAIAPIKey = getApi ?? '';
  }

  void startTimer() {
    seconds = 35;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  Future<void> initTextToSpeech() async {
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) async {
    if (result.finalResult) {
      print("FINAL RESULT : ${result.alternates}");
      lastWords = result.recognizedWords;
      final speech = await openAIService.isArtPromptAI(lastWords);

      startTimer();
      seconds = 35;

      if (speech.contains('https')) {
        generatedImageUrl = speech;
        generatedContent = null;
        setState(() {});
      } else {
        generatedImageUrl = null;
        generatedContent = speech;
        setState(() {});
        await systemSpeak(speech);
      }
      if (generatedContent == 'An internal error occured') {
        print('AlertDialog');
        showAlertDialog();
      }

      print('SPEECH : $speech');
    }
    print(result);
  }

  void onCommandResult(String result) async {
    lastWords = result;
    final speech = await openAIService.isArtPromptAI(lastWords);

    startTimer();
    seconds = 35;

    if (speech.contains('https')) {
      generatedImageUrl = speech;
      generatedContent = null;
      setState(() {});
    } else {
      generatedImageUrl = null;
      generatedContent = speech;
      setState(() {});
      await systemSpeak(speech);
    }
    if (generatedContent == 'An internal error occured') {
      print('AlertDialog');
      showAlertDialog();
    }
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  showAlertDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Please wait for the time to pass out'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
    commandController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'J.A.R.V.I.S.',
          style: GoogleFonts.nunito(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10).copyWith(bottom: 12),
            child: Container(
              height: 45,
              width: 45,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/jarvis.png'),
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.topRight,
            height: 20,
            child: seconds != 0
                ? Text(
                    'Timer : $seconds',
                    style: const TextStyle(
                      // fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // color: Colors.amber,
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20).copyWith(top: 40),
                          child: Text(
                            (generatedContent == null &&
                                    generatedImageUrl == null)
                                ? 'Hello Sir, How can i assist you today?'
                                : generatedContent ?? "",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        // For Image
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: generatedImageUrl != null
                                ? Image.network(generatedImageUrl!)
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: seconds != 0 ? Colors.grey : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextField(
                        enabled: seconds != 0 ? false : true,
                        controller: commandController,
                        onSubmitted: (_) {
                          onCommandResult(commandController.text);
                          commandController.clear();
                          startTimer();
                          seconds = 35;
                        },
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Give command',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                FloatingActionButton(
                  backgroundColor: lastWords.isNotEmpty
                      ? seconds != 0
                          ? Colors.grey
                          : Colors.blue
                      : Colors.blue,
                  onPressed: seconds == 0
                      ? () async {
                          if (await speechToText.hasPermission &&
                              speechToText.isNotListening) {
                            await startListening();
                          } else if (speechToText.isListening) {
                            await stopListening();
                          } else {
                            initSpeechToText();
                          }
                        }
                      : null,
                  child: Icon(
                      speechToText.isNotListening ? Icons.mic : Icons.stop),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
