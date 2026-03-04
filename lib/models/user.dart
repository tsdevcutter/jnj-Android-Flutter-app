class User {
  final int? id;
  String mid;
  String name;
  String surname;
  String email;
  String cell;
  String token;
  String profile_url;
  String accessToken;

  User({
    this.id,
    required this.mid,
    required this.name,
    required this.surname,
    required this.email,
    required this.cell,
    required this.token,
    required this.profile_url,
    required this.accessToken,
  });


  factory User.fromMap(Map<String, dynamic> json) => new User(
    id: json['id'],
    mid: json['mid'],
    name: json['name'],
    surname: json['surname'],
    cell: json['cell'],
    email: json['email'],
    profile_url: json['profile_url'],
    token: json['token'],
    accessToken: json['accessToken']
  );


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mid': mid,
      'name': name,
      'surname': surname,
      'cell': cell,
      'email': email,
      'token': token,
      'profile_url': profile_url,
      'accessToken' : accessToken
    };
  }
}

