class CheckAttendanceModel {
  String? attendanceStatus;

  CheckAttendanceModel({this.attendanceStatus});

  CheckAttendanceModel.fromJson(Map<String, dynamic> json) {
    attendanceStatus = json['attendanceStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendanceStatus'] = this.attendanceStatus;
    return data;
  }
}