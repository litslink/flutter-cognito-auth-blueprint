class User {
  String name;
  String familyName;
  String email;
  String picture;
  String notification;

  User(
      {this.name,
      this.familyName,
      this.email,
      this.picture,
      this.notification});

  User.fromMap(Map<String, String> attrs) {
    name = attrs['name'] == null ? "first name" : attrs["name"];
    familyName =
        attrs['family_name'] == null ? "last name" : attrs["family_name"];
    email = attrs['email'] == null ? "email" : attrs["email"];
    picture = attrs['picture'] == null ? "" : attrs["picture"];
    notification = attrs['custom:notification'] == null
        ? "off"
        : attrs["custom:notification"];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['family_name'] = familyName;
    data['email'] = email;
    data['picture'] = picture;
    data['custom:notification'] = notification;
    return data;
  }
}
