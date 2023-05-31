import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../service/secrets.dart';
import '../service/openai_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/images.dart';
import '../widgets/chat_item.dart';
import '../models/message.dart';

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
  int maxSeconds = 35;
  final List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
    systemSpeak('How may i help you today sir');
    // startTimer();
    getData();
  }

  void addMessages(Message message) {
    messages.add(message);
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
    seconds = maxSeconds;
    Timer.periodic(const Duration(milliseconds: 1700), (timer) {
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

  Future<void> promptResult() async {
    addMessages(
      Message(
        content: lastWords,
        isMe: true,
        color: Colors.blue,
      ),
    );
    final speech = await openAIService.isArtPromptAI(lastWords);

    startTimer();
    seconds = maxSeconds;

    if (speech.contains('https')) {
      generatedImageUrl = speech;
      generatedContent = null;
      setState(() {
        addMessages(
          Message(
            content: generatedImageUrl.toString(),
            isMe: false,
            color: Colors.white,
          ),
        );
      });
    } else {
      generatedImageUrl = null;
      generatedContent = speech;
      setState(() {
        addMessages(
          Message(
            content: generatedContent.toString(),
            isMe: false,
            color: Colors.white,
          ),
        );
      });
      await systemSpeak(speech);
    }
    if (generatedContent == 'An internal error occured') {
      print('AlertDialog was shown');
      showAlertDialog('PLease Wait For The Time To Pass Out');
    }
    print('SPEECH : $speech');
    print('List : $messages');
  }

  Future<void> onSpeechResult(SpeechRecognitionResult result) async {
    if (result.finalResult) {
      print("FINAL RESULT : ${result.alternates}");
      lastWords = result.recognizedWords;
      promptResult();
    }
    print(result);
  }

  Future<void> onCommandResult(String result) async {
    lastWords = result;
    promptResult();
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  showAlertDialog(String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
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
          style: GoogleFonts.nunito(color: Colors.black, fontSize: 25),
        ),
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
                      color: Colors.black,
                    ),
                  )
                : null,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10).copyWith(top: 20),
                          child: (messages.isEmpty)
                              ? ChatItem(
                                  message: Message(
                                    content: 'How can i help you',
                                    isMe: false,
                                    color: Colors.white,
                                  ),
                                )
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: messages.length,
                                  itemBuilder: (ctx, i) => IgnorePointer(
                                    child: ChatItem(
                                      message: messages[i],
                                    ),
                                  ),
                                ),
                        ),
                        // For Image
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Images(
                              imageUrl: (jsonDecode(generatedImageUrl ?? "[]")
                                      as Iterable)
                                  .toList()),
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
                      borderRadius: BorderRadius.circular(10),
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
                          seconds = maxSeconds;
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
