class ConnectionModel {
  final String fromStation;
  final String toStation;
  final String transportMode;
  final int costMin;
  final int costMax;
  final int timeMin;
  final int timeMax;

  ConnectionModel({
    required this.fromStation,
    required this.toStation,
    required this.transportMode,
    required this.costMin,
    required this.costMax,
    required this.timeMin,
    required this.timeMax,
  });

  factory ConnectionModel.fromJson(Map<String, dynamic> json) {
    return ConnectionModel(
      fromStation: json['fromStation'] ?? '',
      toStation: json['toStation'] ?? '',
      transportMode: json['transportMode'] ?? '',
      costMin: json['costMin'] ?? 0,
      costMax: json['costMax'] ?? 0,
      timeMin: json['timeMin'] ?? 0,
      timeMax: json['timeMax'] ?? 0,
    );
  }
}