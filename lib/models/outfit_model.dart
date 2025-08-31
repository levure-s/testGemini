import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

class OutfitModel {
  static List<String> getAvailableBloodTypes() {
    return ['A', 'B', 'O', 'AB'];
  }
}

class OutfitProvider extends ChangeNotifier {
  String? _selectedBloodType;
  String _outfitSuggestion = '血液型を選んでください。';
  bool _isGeneratingSuggestion = false;

  // Getters
  String? get selectedBloodType => _selectedBloodType;
  String get outfitSuggestion => _outfitSuggestion;
  bool get isGeneratingStory => _isGeneratingSuggestion;

  // Methods
  void selectBloodType(String? bloodType) {
    _selectedBloodType = bloodType;
    if (bloodType != null) {
      _outfitSuggestion = 'AIがあなたの血液型に合わせてファッション提案を生成中...';
      _isGeneratingSuggestion = false;
    } else {
      _outfitSuggestion = '血液型を選んでください。';
      _isGeneratingSuggestion = false;
    }
    notifyListeners();

    // 血液型が選択された場合、自動的にファッション提案を生成
    if (bloodType != null) {
      generateFashionSuggestion();
    }
  }

  Future<void> generateFashionSuggestion() async {
    if (_selectedBloodType == null) return;

    _isGeneratingSuggestion = true;
    notifyListeners();

    try {
      // ファッション提案をAIで生成
      _outfitSuggestion = await _generateFashionSuggestion(_selectedBloodType!);
    } catch (e) {
      _outfitSuggestion = 'ファッション提案の生成に失敗しました';
    } finally {
      _isGeneratingSuggestion = false;
      notifyListeners();
    }
  }

  Future<String> _generateFashionSuggestion(String bloodType) async {
    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-2.5-flash',
      );

      final prompt = [
        Content.text(
          '血液型$bloodTypeの人向けのファッション提案を日本語で1-2行で書いてください。'
          '血液型の特徴を活かしたスタイリングのアドバイスを含めてください。',
        ),
      ];

      final response = await model.generateContent(prompt);
      return response.text ?? 'ファッション提案の生成に失敗しました。';
    } catch (e) {
      return 'ファッション提案の生成に失敗しました。';
    }
  }

  void reset() {
    _selectedBloodType = null;
    _outfitSuggestion = '血液型を選んでください。';
    _isGeneratingSuggestion = false;
    notifyListeners();
  }
}
