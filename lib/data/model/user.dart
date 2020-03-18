class User {
  String name;
  String familyName;
  String email;
  String picture;

  User({this.name, this.familyName, this.email, this.picture});

  User.fromMap(Map<String, String> attrs) {
    name = attrs['name'] == null ? "first name" : attrs["name"];
    familyName =
        attrs['family_name'] == null ? "last name" : attrs["family_name"];
    email = attrs['email'] == null ? "email" : attrs["email"];
    picture = attrs['picture'] == null ? "" : attrs["picture"];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['name'] = name;
    data['family_name'] = familyName;
    data['email'] = email;
    data['picture'] = picture;
    return data;
  }
}
