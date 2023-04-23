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
    seconds = 60;
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

      print('SPEECH : $generatedContent');
    }
    print(result);
  }

  void onCommandResult(String result) async {
    lastWords = result;
    final speech = await openAIService.isArtPromptAI(lastWords);

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
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
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
                      fontStyle: FontStyle.italic,
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
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: TextField(
                        controller: commandController,
                        onSubmitted: (_) {
                          onCommandResult(commandController.text);
                          commandController.clear();
                          startTimer();
                          seconds = 60;
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
                  child: Icon(
                      speechToText.isNotListening ? Icons.mic : Icons.stop),
                  onPressed: () async {
                    if (await speechToText.hasPermission &&
                        speechToText.isNotListening) {
                      await startListening();
                      startTimer();
                      seconds = 60;
                    } else if (speechToText.isListening) {
                      await stopListening();
                    } else {
                      initSpeechToText();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
