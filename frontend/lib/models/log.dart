class Log {
  final int logID;
  final int userID;
  final String timeStamp;
  final String date;
  final int gateID;
  final String direction;
  final String cardID;
  final String gateName;
  final String location;

  Log({
    required this.logID,
    required this.userID,
    required this.timeStamp,
    required this.date,
    required this.gateID,
    required this.direction,
    required this.cardID,
    required this.gateName,
    required this.location,
  });

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      logID: json['LogID'] ?? 0, // Provide a default value if null
      userID: json['UserID'] ?? 0,
      timeStamp: json['TimseStamp'] ?? '', // Provide an empty string if null
      date: json['Date'] ?? '',
      gateID: json['GateID'] ?? 0,
      direction: json['Direction'] ?? '',
      cardID: json['CardID'] ?? '',
      gateName: json['GateName'] ?? '',
      location: json['Location'] ?? '',
    );
  }
}
