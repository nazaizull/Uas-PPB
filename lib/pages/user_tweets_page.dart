import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class UserTweetsPage extends StatelessWidget {
  final String username;

  const UserTweetsPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tweet Saya'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( // Memastikan data tweet berdasarkan username
        future: DatabaseHelper().getTweetsForUser(username),  // Memanggil fungsi untuk mendapatkan tweet berdasarkan username
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Anda belum memiliki tweet.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final tweet = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      tweet['content'],  // Menampilkan isi tweet
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${tweet['date']}',  // Menampilkan tanggal tweet
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
