import 'package:flutter/material.dart';
import '/db/database_helper.dart';

class FormTweetPage extends StatelessWidget {
  final String username;
  final TextEditingController _tweetController = TextEditingController();

  FormTweetPage({Key? key, required this.username}) : super(key: key);

  Future<void> _saveTweet(BuildContext context) async {
    if (_tweetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tweet tidak boleh kosong!')),
      );
      return;
    }

    final tweet = {
      'content': _tweetController.text,
      'date': DateTime.now().toIso8601String(),
      'username': username,
    };
    await DatabaseHelper().insertTweet(tweet);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Tweet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tweetController,
              decoration: InputDecoration(
                labelText: 'Apa yang terjadi?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              maxLength: 280,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.blue,
              ),
              onPressed: () => _saveTweet(context),
              child: const Text(
                'Tweet',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
