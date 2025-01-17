class SummarizationModels {
  final int recordingId;
  final int classId;
  final String summaryText;

  SummarizationModels({
    required this.recordingId,
    required this.classId,
    required this.summaryText,
  });

  Map<String, dynamic> toJson() {
    return {
      'recordingId': recordingId,
      'classId': classId,
      'summaryText': summaryText,
    };
  }

  // Factory constructor to create an instance from JSON
  factory SummarizationModels.fromJson(Map<String, dynamic> json) {
    return SummarizationModels(
      recordingId: json['recordingId'],
      classId: json['classId'],
      summaryText: json['summaryText'],
    );
  }
}
