import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'form_tweet_page.dart';
import 'user_tweets_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _tweets;

  @override
  void initState() {
    super.initState();
    _loadTweets();
  }

  void _loadTweets() {
    setState(() {
      _tweets = DatabaseHelper().getTweets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selamat Datang, ${widget.username}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserTweetsPage(username: widget.username),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person),
                  label: const Text('Tweet Saya'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(username: widget.username),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Pengaturan'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _tweets,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada tweet.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final tweet = snapshot.data![index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: ListTile(
                          title: Text(
                            tweet['content'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '@${tweet['username']} -> ${tweet['date']}',
                          ),
                          trailing: tweet['username'] == widget.username
                              ? IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteTweet(
                                    tweet['id'],
                                    tweet['username'],
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormTweetPage(username: widget.username),
            ),
          ).then((_) => _loadTweets());
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> _deleteTweet(int id, String username) async {
    if (username == widget.username) {
      await DatabaseHelper().deleteTweet(id, username);
      _loadTweets();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda tidak dapat menghapus tweet orang lain')),
      );
    }
  }
}
