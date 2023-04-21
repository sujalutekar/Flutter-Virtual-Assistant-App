import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/secrets.dart';
import './splash_screen.dart';

class AddNewApiScreen extends StatefulWidget {
  const AddNewApiScreen({super.key});

  @override
  State<AddNewApiScreen> createState() => _AddNewApiScreenState();
}

class _AddNewApiScreenState extends State<AddNewApiScreen> {
  final apiKeyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String keyName = 'apiKey';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    apiKeyController.dispose();
    super.dispose();
  }

  void _getData() async {
    final prefs = await SharedPreferences.getInstance();
    final getAPIKey = prefs.getString(keyName);
    openAIAPIKey = getAPIKey ?? '';
    if (openAIAPIKey.isNotEmpty) {
      navigateToSplashScreen();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> setData(apiKeyValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyName, apiKeyValue);
  }

  showSnackbar() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
        duration: const Duration(
          milliseconds: 1500,
        ),
        backgroundColor: Colors.white,
        content: const Text(
          'Successfully Added Your API Key',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void navigateToSplashScreen() {
    Future.delayed(
      const Duration(milliseconds: 1000),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5).copyWith(left: 15),
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Your API Key';
                            }
                            if (!value.startsWith('sk') && value.length < 40) {
                              return 'Invalid API Key';
                            }

                            return null;
                          },
                          controller: apiKeyController,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (value) async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                openAIAPIKey = value;
                                print('New API Key : $openAIAPIKey');
                              });
                              showSnackbar();
                              navigateToSplashScreen();
                              // ...
                              await setData(value);
                              // ...
                            }
                            apiKeyController.clear();
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add Your API Key Here',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            openAIAPIKey = apiKeyController.text;
                            print('New API Key : $openAIAPIKey');
                          });
                          showSnackbar();
                          navigateToSplashScreen();
                          // ...
                          await setData(apiKeyController.text);
                          // ...
                        }
                        apiKeyController.clear();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text(
                            'NEXT',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const Center(
              child: Text(
                'LOADING...',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}
