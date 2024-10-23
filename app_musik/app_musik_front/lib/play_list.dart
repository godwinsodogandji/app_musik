import 'package:flutter/material.dart';

class PlayListPage extends StatelessWidget {
  const PlayListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('play List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'play List',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Remplace ce nombre par la longueur de ta liste de clients
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text('C$index'),
                    ),
                    title: Text('Client $index'),
                    subtitle: Text('client$index@example.com'),
                    onTap: () {
                      // Action lorsque tu appuies sur un client
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
