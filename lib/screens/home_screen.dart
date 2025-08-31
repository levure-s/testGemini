import 'package:flutter/material.dart';
import '../models/outfit_model.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('血液型ファッション診断'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<OutfitProvider>(
        builder: (context, outfitProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'あなたの血液型を選んでください',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Blood type selection buttons
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children:
                      OutfitModel.getAvailableBloodTypes().map((bloodType) {
                        final isSelected =
                            outfitProvider.selectedBloodType == bloodType;
                        return ElevatedButton(
                          onPressed:
                              () => outfitProvider.selectBloodType(bloodType),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                            foregroundColor:
                                isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : null,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            bloodType,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 48),

                // Outfit suggestion and story display
                if (outfitProvider.selectedBloodType != null) ...[
                  // Outfit suggestion display
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.style,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '今日のファッション提案',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (outfitProvider.outfitSuggestion.isNotEmpty)
                          Text(
                            outfitProvider.outfitSuggestion,
                            style: const TextStyle(fontSize: 18, height: 1.5),
                            textAlign: TextAlign.center,
                          )
                        else if (outfitProvider.isGeneratingStory)
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('ファッション提案を生成中...'),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 48),

                // Reset button
                if (outfitProvider.selectedBloodType != null)
                  TextButton(
                    onPressed: () => outfitProvider.reset(),
                    child: const Text('リセット'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
