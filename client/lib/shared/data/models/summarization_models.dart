class SummarizationModels {
  final int recordingId;
  final int classId;
  final String summaryText;
  final String transcriptionText;
  final String publishStatus;

  SummarizationModels({
    required this.recordingId,
    required this.classId,
    required this.summaryText,
    required this.transcriptionText,
    required this.publishStatus,
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
      transcriptionText: json['transcriptionText'],
      publishStatus: json['publishStatus'],
    );
  }
}
