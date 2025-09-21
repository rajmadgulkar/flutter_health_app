import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  // keys
  static const _kEmail = 'email';
  static const _kUserId = 'userId';
  static const _kIsLoggedIn = 'isUserLoggedIn';
  static const _kName = 'name';
  static const _kFavourites = 'favourite_assessments';

  // runtime fields
  String email = "";
  String userId = "";
  String name = "";
  bool isLoggedIn = false;

  // singleton (optional but handy)
  static final UserController _instance = UserController._internal();
  factory UserController() => _instance;
  UserController._internal();

  // set (only store what's necessary)
  Future<void> setSharedPrefData({
    required String email,
    required String userId,
    required bool loginFlag,
    String? name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEmail, email);
    await prefs.setString(_kUserId, userId);
    if (name != null && name.isNotEmpty) await prefs.setString(_kName, name);
    await prefs.setBool(_kIsLoggedIn, loginFlag);

    // update runtime fields
    this.email = email;
    this.userId = userId;
    this.name = name ?? "";
    this.isLoggedIn = loginFlag;
  }

  // get
  Future<void> getSharedPrefData() async {
    final prefs = await SharedPreferences.getInstance();
    email = prefs.getString(_kEmail) ?? "";
    userId = prefs.getString(_kUserId) ?? "";
    name = prefs.getString(_kName) ?? "";
    isLoggedIn = prefs.getBool(_kIsLoggedIn) ?? false;
  }

  /// Toggle favourite status for a given assessment ID
  Future<void> toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(_kFavourites) ?? [];
    if (favs.contains(id)) {
      favs.remove(id);
    } else {
      favs.add(id);
    }
    await prefs.setStringList(_kFavourites, favs);
  }

  /// Get all favourite assessment IDs
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kFavourites) ?? [];
  }

  /// Check if a specific assessment is favourite
  Future<bool> isFavourite(String id) async {
    final favs = await getFavorites();
    return favs.contains(id);
  }

  // clear (for logout)
  Future<void> clearSharedPrefData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kEmail);
    await prefs.remove(_kUserId);
    await prefs.remove(_kName);
    await prefs.remove(_kIsLoggedIn);
    await prefs.remove(_kFavourites);

    email = "";
    userId = "";
    name = "";
    isLoggedIn = false;
  }
}
