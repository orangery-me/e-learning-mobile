enum EnrollmentStatus {
  active,
  completed;

  String toJson() => name.toUpperCase();

  factory EnrollmentStatus.fromJson(String? raw) =>
      EnrollmentStatus.values.firstWhere(
        (e) => e.name == raw?.toLowerCase(),
        orElse: () => EnrollmentStatus.active,
      );
}

class EnrollmentDto {
  final String id;
  final String userId;
  final String courseId;
  final DateTime enrollmentDate;
  final DateTime? completionDate;
  final double progressPercentage;
  final EnrollmentStatus status;
  final int totalWatchTimeMinutes;
  final DateTime? lastAccessedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EnrollmentDto({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.enrollmentDate,
    this.completionDate,
    required this.progressPercentage,
    required this.status,
    required this.totalWatchTimeMinutes,
    this.lastAccessedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory EnrollmentDto.fromJson(Map<String, dynamic> json) {
    DateTime? parseEpoch(num? epoch) => epoch != null
        ? DateTime.fromMillisecondsSinceEpoch((epoch * 1000).toInt(),
            isUtc: true)
        : null;

    return EnrollmentDto(
      id: json['id'],
      userId: json['userId'],
      courseId: json['courseId'],
      enrollmentDate: parseEpoch(json['enrollmentDate'])!,
      completionDate: parseEpoch(json['completionDate']),
      progressPercentage: (json['progressPercentage'] as num).toDouble(),
      status: EnrollmentStatus.fromJson(json['status']),
      totalWatchTimeMinutes: json['totalWatchTimeMinutes'],
      lastAccessedAt: parseEpoch(json['lastAccessedAt']),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
