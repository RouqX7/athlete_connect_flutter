class Profile {
  final String accountStatus;
  final DateTime lastUpdated;
  final Preferences preferences;
  final User user;
  final bool verified;

  Profile({
    required this.accountStatus,
    required this.lastUpdated,
    required this.preferences,
    required this.user,
    required this.verified,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      accountStatus: json['accountStatus'] ?? 'inactive',
      lastUpdated: DateTime.parse(json['lastUpdated']),
      preferences: Preferences.fromJson(json['preferences']),
      user: User.fromJson(json['user']),
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'accountStatus': accountStatus,
    'lastUpdated': lastUpdated.toIso8601String(),
    'preferences': preferences.toJson(),
    'user': user.toJson(),
    'verified': verified,
  };
}

class Preferences {
  final Notifications notifications;
  final String theme;

  Preferences({
    required this.notifications,
    required this.theme,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      notifications: Notifications.fromJson(json['notifications']),
      theme: json['theme'] ?? 'light',
    );
  }

  Map<String, dynamic> toJson() => {
    'notifications': notifications.toJson(),
    'theme': theme,
  };
}

class Notifications {
  final bool email;
  final bool push;
  final bool sms;

  Notifications({
    required this.email,
    required this.push,
    required this.sms,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      email: json['email'] ?? true,
      push: json['push'] ?? true,
      sms: json['sms'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'email': email,
    'push': push,
    'sms': sms,
  };
}

class User {
  final AuthInfo authInfo;
  final String? bio;
  final String? image;
  final bool isAgreed;
  final dynamic location; // Using dynamic since it's null in your data
  final Map<String, dynamic> socialLinks;
  final String? website;

  User({
    required this.authInfo,
    this.bio = '',
    this.image = '',
    required this.isAgreed,
    this.location,
    required this.socialLinks,
    this.website = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      authInfo: AuthInfo.fromJson(json['authInfo']),
      bio: json['bio'] ?? '',
      image: json['image'] ?? '',
      isAgreed: json['isAgreed'] ?? false,
      location: json['location'],
      socialLinks: json['socialLinks'] ?? {},
      website: json['website'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'authInfo': authInfo.toJson(),
    'bio': bio,
    'image': image,
    'isAgreed': isAgreed,
    'location': location,
    'socialLinks': socialLinks,
    'website': website,
  };
}

class AuthInfo {
  final DateTime createdAt;
  final String email;
  final DateTime lastLogin;
  final String? phone;
  final bool secureLogin;
  final String uid;
  final String? username;

  AuthInfo({
    required this.createdAt,
    required this.email,
    required this.lastLogin,
    this.phone = '',
    required this.secureLogin,
    required this.uid,
    this.username,
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    return AuthInfo(
      createdAt: DateTime.parse(json['createdAt']),
      email: json['email'],
      lastLogin: DateTime.parse(json['lastLogin']),
      phone: json['phone'] ?? '',
      secureLogin: json['secureLogin'] ?? true,
      uid: json['uid'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt.toIso8601String(),
    'email': email,
    'lastLogin': lastLogin.toIso8601String(),
    'phone': phone,
    'secureLogin': secureLogin,
    'uid': uid,
    'username': username,
  };
} 