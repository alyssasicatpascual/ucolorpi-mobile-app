// Mock Authentication Class - No Firebase Backend
// This is for UI prototyping with mock data only

class MockUser {
  final String uid;
  final String? email;
  final String? displayName;

  MockUser({
    required this.uid,
    required this.email,
    this.displayName,
  });
}

class MockUserCredential {
  final MockUser user;
  MockUserCredential({required this.user});
}

class Exception {
  final String message;
  Exception(this.message);

  @override
  String toString() => message;
}

class Auth {
  static MockUser? _currentUser;
  static final Map<String, Map<String, dynamic>> _mockUsers = {};

  MockUser? get currentUser => _currentUser;

  Stream<MockUser?> get authStateChanges {
    return Stream.value(_currentUser);
  }

  // ===================== LOGIN =====================
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }

    // Mock validation - for demo purposes
    if (!email.contains('@')) {
      throw Exception('Invalid email format.');
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if user exists in mock data
    if (!_mockUsers.containsKey(email)) {
      throw Exception('No account found with this email. Please sign up first.');
    }

    final userData = _mockUsers[email]!;
    if (userData['password'] != password) {
      throw Exception('Incorrect password. Please try again.');
    }

    // Set current user
    _currentUser = MockUser(
      uid: userData['uid'],
      email: email,
      displayName: userData['fullName'],
    );
  }

  // ===================== SIGN UP =====================
  Future<MockUserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String fullName,
    required String? sex,
    required String dateOfBirth,
  }) async {
    // Validate inputs
    if (email.trim().isEmpty || password.isEmpty || fullName.trim().isEmpty) {
      throw Exception('Please fill in all required fields');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters long');
    }

    if (!email.contains('@')) {
      throw Exception('Invalid email format.');
    }

    // Check if email already exists
    if (_mockUsers.containsKey(email)) {
      throw Exception('An account with this email already exists.');
    }

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Create mock user
    final uid = 'user_${DateTime.now().millisecondsSinceEpoch}';
    _mockUsers[email] = {
      'uid': uid,
      'email': email,
      'password': password,
      'fullName': fullName.trim(),
      'sex': sex ?? 'Not Specified',
      'dateOfBirth': dateOfBirth,
      'createdAt': DateTime.now().toIso8601String(),
    };

    final user = MockUser(
      uid: uid,
      email: email,
      displayName: fullName.trim(),
    );

    _currentUser = user;
    return MockUserCredential(user: user);
  }

  // ===================== LOGOUT =====================
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }
}