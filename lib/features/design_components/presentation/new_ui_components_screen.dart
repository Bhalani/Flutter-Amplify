import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/text_components.dart';

class NewUIComponentsScreen extends StatelessWidget {
  const NewUIComponentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New UI Components'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/'); // Navigate back to the landing page explicitly
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final buttonWidth = 200.0; // Approximate width of a button
          final spacing = 16.0; // Spacing between buttons
          final buttonsPerRow = (maxWidth / (buttonWidth + spacing)).floor();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Buttons',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: (maxWidth / buttonsPerRow) - spacing,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Button ${index + 1}'),
                    ),
                  );
                }),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Text Components',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomText(
                  text: 'Text with Pre Icon',
                  preIcon: Icons.info,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomText(
                  text: 'Text with Post Icon',
                  postIcon: Icons.check,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
