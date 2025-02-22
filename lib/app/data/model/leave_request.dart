class LeaveRequest {
  final int id;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;
  final String? attachmentUrl;
  final DateTime createdAt;

  LeaveRequest({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.attachmentUrl,
    required this.createdAt,
  });

  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }

  static List<String> get leaveTypes => [
    'Sakit',
    'Izin',
    'Cuti',
    'Dinas Luar',
  ];

  static List<String> get statusTypes => [
    'Pending',
    'Approved',
    'Rejected',
  ];
}
