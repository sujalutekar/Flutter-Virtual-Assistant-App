import 'dart:convert';

import 'package:http/http.dart' as http;

import './secrets.dart';

class OpenAIService {
  List<Map<String, String>> messages = [];

  Future<String> isArtPromptAI(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              'role': 'user',
              'content':
                  'Does this message want to generate an AI picture, Image, Art, Drawing or anything similar? $prompt . Simply answer with a yes or a no. ',
            },
          ]
        }),
      );
      print(res.body);
      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        print('Status Code : ${res.statusCode}');

        switch (content) {
          case 'Yes':
          case 'yes':
          case 'Yes.':
          case 'yes.':
          case 'YES':
          case 'YES.':
            final res = await dallEAPI(prompt);
            return res;

          default:
            final res = await chatGPTAI(prompt);
            return res;
        }
      }
      return 'An internal error occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> chatGPTAI(String prompt) async {
    messages.add(
      {
        'role': 'user',
        'content': prompt,
      },
    );
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages,
        }),
      );

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();
        print('Status Code : ${res.statusCode}');

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occured';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> dallEAPI(String prompt) async {
    messages.add(
      {
        'role': 'user',
        'content': prompt,
      },
    );
    try {
      final res = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openAIAPIKey',
        },
        body: jsonEncode({
          'prompt': prompt,
          'n': 1,
        }),
      );

      if (res.statusCode == 200) {
        String imageUrl = jsonDecode(res.body)['data'][0]['url'];
        imageUrl = imageUrl.trim();
        print('Status Code : ${res.statusCode}');

        messages.add({
          'role': 'assistant',
          'content': imageUrl,
        });

        return imageUrl;
      }
      return 'An internal error occured';
    } catch (e) {
      return e.toString();
    }
  }
}