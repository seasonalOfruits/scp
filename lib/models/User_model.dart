// ignore_for_file: non_constant_identifier_names

class User {
 final String id;
 final String password;
 final String name;
 final String mail;
 final String access_token;
 final String refreash_token;

 User.forMap(Map<String, dynamic> map)
  : id = map['user_id'],
    password = map['password'],
    name = map['name'],
    mail = map['mail'],
    access_token = map['access_token'],
    refreash_token = map['refreash_token'];
}