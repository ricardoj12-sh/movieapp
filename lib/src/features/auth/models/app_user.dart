class AppUser {
  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.favorites,
    required this.watchlist,
    this.photoUrl, // 🔹 Agregado el campo opcional photoUrl
  });

  final String uid;
  final String name;
  final String email;
  final List<int> favorites;
  final List<int> watchlist;
  final String? photoUrl; // 🔹 Ahora puede contener la URL de la foto del usuario

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      favorites: List<int>.from(json['favorites'] ?? []),
      watchlist: List<int>.from(json['watchlist'] ?? []),
      photoUrl: json['photoUrl'] ?? "", // 🔹 Manejo de null para evitar errores
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'favorites': favorites,
      'watchlist': watchlist,
      'photoUrl': photoUrl, // 🔹 Ahora se almacena la URL de la foto
    };
  }
}
