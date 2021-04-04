class Group {
  String name;
  bool teaching;
  Group.fromJson(map){
    name = map["name"];
    teaching = map["teaching"];
  }

  Group.withOnceName(this.name);
}