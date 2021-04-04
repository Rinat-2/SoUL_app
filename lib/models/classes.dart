import 'package:intl/intl.dart';

class Classes {
  String subject;
  String type;
  String teacherName;
  String group;
  DateTime time;


  Classes.fromJson(map) {
    this.subject = map["subject"];
    this.type = map["type"];
    this.teacherName = map["teacherName"];
    this.time = DateTime.parse(map["time"]);
    this.group =map["group"];
  }
  Map<String, dynamic> toJson() => {
        'subject': subject,
        'type': type,
        'teacherName': teacherName,
        'time': time.toString(),
      };

  @override
  String toString() {
    return 'Classes{subject: $subject, type: $type, teacherName: $teacherName, time: $time}';
  }

  Classes({this.subject, this.type, this.teacherName, this.time});
}

List<Classes> classes = [
  Classes(
    subject: "Android & IOS",
    type: "Online Class",
    teacherName: "Abelmazhinova D.Z.",
    time: DateTime.parse("2020-09-18 09:35:00"),
  ),
  Classes(
    subject: "Исскусственный \nинтеллект и \nнейросетевое \nуправление",
    type: "Online Class",
    teacherName: "N/A",
    time: DateTime.parse("2020-09-15 10:40:00"),
  ),
  Classes(
    subject: "Технология \nкомпьютерной \nграфики",
    type: "Online Class",
    teacherName: "Orazaeva L.I",
    time: DateTime.parse("2020-09-09 13:00:00"),
  ),
];
