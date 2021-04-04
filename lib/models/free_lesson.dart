class FreeLesson {
  String subject;
  String description;
  DateTime date;
  String userMail;
  String id;

  Map<String, dynamic> toJson() => {
    'subject': subject,
    'description': description,
    'date': date.toString(),
    'userMail': userMail,

  };
  FreeLesson.fromJson(this. id,map){
    print(map);

    subject = map["subject"];
    description = map["description"];
    date = DateTime.parse(map["date"]);
    userMail = map["userMail"];
  }

  @override
  String toString() {
    return 'FreeLesson{subject: $subject, description: $description, date: $date, userMail: $userMail, id: $id}';
  }

  FreeLesson(this.subject, this.description, this.date, this.userMail);
}