import 'package:flutter/material.dart';

class SecretPage extends StatelessWidget {
  const SecretPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secret Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Yay! You logged in successfully!',
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20), // Adjust the height as needed
          Image.network(
            'https://media.tenor.com/ecLqfAOMvJgAAAAC/dance-cartoon.gif', // Replace with the URL of your GIF
            height: 200, // Adjust the height as needed
          ),
          const SizedBox(height: 20), // Add space between the GIF and the "Created by Kritika" text
          const Text(
            'Created by Kritika',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}