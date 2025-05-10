import 'package:amplify_auth/core/constants/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UIComponentsScreen extends StatelessWidget {
  const UIComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Components'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/'); // Navigate back to the landing page explicitly
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center buttons horizontally
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Buttons',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                print('ElevatedButton Pressed');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    UIConstants.primaryColor, // Define the background color
                foregroundColor: Colors.white, // Define the text color
              ),
              child: const Text('Elevated Button'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('OutlinedButton Pressed');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                    color: Colors.blue, width: 2), // Define the border
              ),
              child: const Text('Outlined Button'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('TextButton Pressed');
              },
              child: const Text('Text Button'),
            ),
          ],
        ),
      ),
    );
  }
}
