import 'package:e_learning_mobile/data/dtos/quizz/quizz_question_dto.dart';
import 'dart:math';

/// Wrapper class for a question with shuffled options
/// Tracks the mapping between original and shuffled indices
class ShuffledQuestion {
  final QuizzQuestionDto originalQuestion;
  final List<String> shuffledOptions;
  final Map<int, int> originalToShuffled; // original index -> shuffled index
  final Map<int, int> shuffledToOriginal; // shuffled index -> original index
  final int shuffledCorrectIndex; // correct answer index in shuffled options

  ShuffledQuestion({
    required this.originalQuestion,
    required this.shuffledOptions,
    required this.originalToShuffled,
    required this.shuffledToOriginal,
    required this.shuffledCorrectIndex,
  });

  /// Create a shuffled question from original question
  factory ShuffledQuestion.fromOriginal(QuizzQuestionDto question) {
    // Create a copy of options
    final optionsCopy = List<String>.from(question.options);

    // Create index list for shuffling
    final indices = List.generate(optionsCopy.length, (i) => i);
    indices.shuffle(Random());

    // Shuffle options
    final shuffledOptions = indices.map((i) => optionsCopy[i]).toList();

    // Create mapping
    final originalToShuffled = <int, int>{};
    final shuffledToOriginal = <int, int>{};

    for (int i = 0; i < indices.length; i++) {
      final originalIndex = indices[i];
      final shuffledIndex = i;
      originalToShuffled[originalIndex] = shuffledIndex;
      shuffledToOriginal[shuffledIndex] = originalIndex;
    }

    // Find correct answer in shuffled options
    final shuffledCorrectIndex =
        originalToShuffled[question.correctAnswerIndex]!;

    return ShuffledQuestion(
      originalQuestion: question,
      shuffledOptions: shuffledOptions,
      originalToShuffled: originalToShuffled,
      shuffledToOriginal: shuffledToOriginal,
      shuffledCorrectIndex: shuffledCorrectIndex,
    );
  }

  /// Convert selected shuffled index back to original index
  int? getOriginalIndex(int shuffledIndex) {
    return shuffledToOriginal[shuffledIndex];
  }
}
