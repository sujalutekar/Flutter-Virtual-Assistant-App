import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/secrets.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final apiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String nameKey = 'name';
  final String emailKey = 'email';
  final String apiKey = 'api';

  @override
  void initState() {
    super.initState();
    nameController.text = bossName;
    emailController.text = userEmailId;
    apiController.text = openAIAPIKey;
    // getData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    apiController.dispose();
    super.dispose();
  }

  // void getData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final getName = prefs.getString(nameKey);
  //   bossName = getName ?? '';
  //   final getEmail = prefs.getString(emailKey);
  //   userEmailId = getEmail ?? '';
  // }

  Future<void> setData(keyName, value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyName, value);
    // await prefs.setString(keyName, value);
  }

  void saveForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        apiController.text.isNotEmpty) {
      setState(() {
        bossName = nameController.text;
        userEmailId = emailController.text;
        openAIAPIKey = apiController.text;
      });
      await setData(nameKey, nameController.text);
      await setData(emailKey, emailController.text);
      await setData(apiKey, apiController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              saveForm();
              if (_formKey.currentState!.validate()) {
                if (nameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    apiController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      duration: Duration(milliseconds: 1500),
                      content: Text('Saved Successfully'),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            // Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  // initialValue: bossName,
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    border: InputBorder.none,
                    hintText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }

                    return null;
                  },
                  onFieldSubmitted: (value) async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        bossName = value;
                      });

                      await setData(nameKey, value);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // Email
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    border: InputBorder.none,
                    hintText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email-id';
                    }
                    if (!value.endsWith('.com') && !value.contains('@')) {
                      return 'Enter a valid email-id';
                    }

                    return null;
                  },
                  onFieldSubmitted: (value) async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        userEmailId = value;
                      });

                      await setData(emailKey, value);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            // API Key
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.deepPurple),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: apiController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    border: InputBorder.none,
                    hintText: 'Your API Key',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your API Key';
                    }
                    if (!value.startsWith('sk') && value.length < 40) {
                      return 'Invalid API Key';
                    }

                    return null;
                  },
                  onFieldSubmitted: (value) async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        openAIAPIKey = value;
                      });

                      await setData(apiKey, value);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
