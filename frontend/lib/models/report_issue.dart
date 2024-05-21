class ReportIssue {  
  final String subject;
  final String issue;

  ReportIssue({    
    required this.subject,
    required this.issue,
  });

  factory ReportIssue.fromJson(Map<String, dynamic> json) {
    return ReportIssue(      
      subject: json['Subject'] ?? '',
      issue: json['Issue'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Subject': subject,
      'Issue': issue,
    };
  }
}
