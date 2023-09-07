class SectionTT {
  String? day;
  String? s0830;
  String? s0930;
  String? s1030;
  String? s1130;
  String? s1230;
  String? s0130;
  String? s0230;
  String? s0330;
  String? s0430;
  String? s0530;

  SectionTT(
      {String? day,
      String? s0830,
      String? s0930,
      String? s1030,
      String? s1130,
      String? s1230,
      String? s0130,
      String? s0230,
      String? s0330,
      String? s0430,
      String? s0530}) {
    if (day != null) {
      day = day;
    }
    if (s0830 != null) {
      s0830 = s0830;
    }
    if (s0930 != null) {
      s0930 = s0930;
    }
    if (s1030 != null) {
      s1030 = s1030;
    }
    if (s1130 != null) {
      s1130 = s1130;
    }
    if (s1230 != null) {
      s1230 = s1230;
    }
    if (s0130 != null) {
      s0130 = s0130;
    }
    if (s0230 != null) {
      s0230 = s0230;
    }
    if (s0330 != null) {
      s0330 = s0330;
    }
    if (s0430 != null) {
      s0430 = s0430;
    }
    if (s0530 != null) {
      s0530 = s0530;
    }
  }

  SectionTT.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    s0830 = json['08:30'] ?? 'free';
    s0930 = json['09:30'] ?? 'free';
    s1030 = json['10:30'] ?? 'free';
    s1130 = json['11:30'] ?? 'free';
    s1230 = json['12:30'] ?? 'free';
    s0130 = json['01:30'] ?? 'free';
    s0230 = json['02:30'] ?? 'free';
    s0330 = json['03:30'] ?? 'free';
    s0430 = json['04:30'] ?? 'free';
    s0530 = json['05:30'] ?? 'free';
  }

  static Map<String, dynamic> toJson(SectionTT tt) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = tt.day;
    data['08:30'] = tt.s0830 ?? 'free';
    data['09:30'] = tt.s0930 ?? 'free';
    data['10:30'] = tt.s1030 ?? 'free';
    data['11:30'] = tt.s1130 ?? 'free';
    data['12:30'] = tt.s1230 ?? 'free';
    data['01:30'] = tt.s0130 ?? 'free';
    data['02:30'] = tt.s0230 ?? 'free';
    data['03:30'] = tt.s0330 ?? 'free';
    data['04:30'] = tt.s0430 ?? 'free';
    data['05:30'] = tt.s0530 ?? 'free';
    return data;
  }
}

class TeacherTTModel {
  List<TeacherByDay>? teacher;

  TeacherTTModel({this.teacher});

  TeacherTTModel.fromJson(Map<String, dynamic> json) {
    if (json['teacher'] != null) {
      teacher = <TeacherByDay>[];
      json['teacher'].forEach((v) {
        teacher!.add(TeacherByDay.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (teacher != null) {
      data['teacher'] = teacher!.map((v) => toJson()).toList();
    }
    return data;
  }
}

class TeacherByDay {
  String? day;
  String? s0830;
  String? s0930;
  String? s1030;
  String? s1130;
  String? s1230;
  String? s0130;
  String? s0230;
  String? s0330;
  String? s0430;
  String? s0530;

  TeacherByDay({
    required this.s0830,
    required this.s0930,
    required this.s1030,
    required this.s1130,
    required this.s1230,
    required this.s0130,
    required this.s0230,
    required this.s0330,
    required this.s0430,
    required this.s0530,
    required this.day,
  });

  TeacherByDay.fromJson(Map<String, dynamic> json) {
    day = json['__EMPTY'];

    s0830 = json['08:30'] ?? 'free';
    s0930 = json['09:30'] ?? 'free';
    s1030 = json['10:30'] ?? 'free';
    s1130 = json['11:30'] ?? 'free';
    s1230 = json['12:30'] ?? 'free';
    s0130 = json['01:30'] ?? 'free';
    s0230 = json['02:30'] ?? 'free';
    s0330 = json['03:30'] ?? 'free';
    s0430 = json['04:30'] ?? 'free';
    s0530 = json['05:30'] ?? 'free';
  }

  static Map<String, dynamic> toJson(TeacherByDay tt) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['08:30'] = tt.s0830 ?? 'free';
    data['09:30'] = tt.s0930 ?? 'free';
    data['10:30'] = tt.s1030 ?? 'free';
    data['11:30'] = tt.s1130 ?? 'free';
    data['12:30'] = tt.s1230 ?? 'free';
    data['01:30'] = tt.s0130 ?? 'free';
    data['02:30'] = tt.s0230 ?? 'free';
    data['03:30'] = tt.s0330 ?? 'free';
    data['04:30'] = tt.s0430 ?? 'free';
    data['05:30'] = tt.s0530 ?? 'free';
    data['__EMPTY'] = tt.day;
    return data;
  }
}
