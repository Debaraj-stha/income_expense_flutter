class Data {
  Data(
      {required this.title,
      required this.amount,
      required this.date,
      this.type,
      required this.id});
  String title;
  String amount;
  DateTime date;
  String id;
  String? type;
  factory Data.fromJson(Map<String, dynamic> json) => Data(
      title: json['title'],
      amount: json['amount'].toString(),
      date: DateTime.parse(json['date']),
      type: json['type'],
      id: json['id']);
  Map<String, dynamic> toJson() => {
        "title": title,
        "amount": amount,
        "date": date.toLocal().toString(),
        "id": id,
        "type": type
      };
}

class User {
  String name;
  String email;
  String? password;
  String id;
  User(
      {required this.name,
      required this.email,
      this.password,
      required this.id});
  factory User.fromJson(Map<String, dynamic> json) => User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      id: json['id']);
  Map<String, dynamic> toJson() =>
      {"name": name, "email": email, "password": password, "id": id};
}
