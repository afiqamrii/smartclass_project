class SummaryPromptModels {
  final int promptId;
  final String lecturerId;
  final String summaryPrompt;

  SummaryPromptModels({
    required this.promptId,
    required this.lecturerId,
    required this.summaryPrompt,
  });

  Map<String, dynamic> toJson() {
    return {
      'idSummaryPrompt': promptId,
      'lecturerId': lecturerId,
      'summary_prompt': summaryPrompt,
    };
  }

  // Factory constructor to create an instance from JSON
  factory SummaryPromptModels.fromJson(Map<String, dynamic> json) {
    return SummaryPromptModels(
      promptId: json['idSummaryPrompt'],
      lecturerId: json['lecturerId'],
      summaryPrompt: json['summary_prompt'],
    );
  }
}
