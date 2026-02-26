/// Feedback model
/// Represents user feedback data with rating and comment
class FeedbackModel {
  final int rating;
  final String? comment;

  FeedbackModel({required this.rating, this.comment});

  /// Converts model to JSON for API submission
  Map<String, dynamic> toJson() {
    return {'rating': rating, 'comment': comment};
  }

  /// Creates FeedbackModel from JSON response
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(rating: json['rating'], comment: json['comment']);
  }
}
