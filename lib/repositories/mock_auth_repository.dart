import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';

import '../models/user.dart';

const String usersAuthBoxName = 'auth_users_box';
const String authSessionBoxName = 'auth_session_box';

enum AuthStatus { unauthenticated, authenticated, guest }

class AuthState {
  const AuthState._(this.status, {this.user});

  const AuthState.unauthenticated() : this._(AuthStatus.unauthenticated);

  const AuthState.authenticated(User user)
      : this._(AuthStatus.authenticated, user: user);

  const AuthState.guest() : this._(AuthStatus.guest);

  final AuthStatus status;
  final User? user;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isGuest => status == AuthStatus.guest;
}

class MockAuthRepository {
  MockAuthRepository(this._usersBox, this._sessionBox)
      : _controller = StreamController<AuthState>.broadcast();

  final Box<User> _usersBox;
  final Box<dynamic> _sessionBox;
  final StreamController<AuthState> _controller;

  AuthState _currentState = const AuthState.unauthenticated();

  Future<void> init() async {
    final String? status = _sessionBox.get('status') as String?;
    if (status == 'authenticated') {
      final String? userId = _sessionBox.get('currentUserId') as String?;
      if (userId != null) {
        final User? user = _usersBox.get(userId);
        if (user != null) {
          _currentState = AuthState.authenticated(user);
        }
      }
    } else if (status == 'guest') {
      _currentState = const AuthState.guest();
    }
    _controller.add(_currentState);
  }

  Stream<AuthState> getCurrentUserStatus() {
    return _controller.stream;
  }

  AuthState get currentState => _currentState;

  Future<AuthState> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final String normalizedEmail = email.trim().toLowerCase();
    final bool exists = _usersBox.values.any(
      (User user) => user.email.toLowerCase() == normalizedEmail,
    );
    if (exists) {
      throw StateError('email-already-used');
    }

    final String id = 'user-${DateTime.now().millisecondsSinceEpoch}';
    final User user = User(
      id: id,
      name: name.trim(),
      email: normalizedEmail,
      passwordHash: _hashPassword(password),
    );
    await _usersBox.put(id, user);

    await _persistSession(status: 'authenticated', userId: user.id);
    _currentState = AuthState.authenticated(user);
    _controller.add(_currentState);
    return _currentState;
  }

  Future<AuthState> login({
    required String email,
    required String password,
  }) async {
    final String normalizedEmail = email.trim().toLowerCase();
    final User? user = _usersBox.values.firstWhere(
      (User candidate) => candidate.email.toLowerCase() == normalizedEmail,
      orElse: () => throw StateError('user-not-found'),
    );

    if (user.passwordHash != _hashPassword(password)) {
      throw StateError('invalid-password');
    }

    await _persistSession(status: 'authenticated', userId: user.id);
    _currentState = AuthState.authenticated(user);
    _controller.add(_currentState);
    return _currentState;
  }

  Future<void> continueAsGuest() async {
    _currentState = const AuthState.guest();
    await _persistSession(status: 'guest');
    _controller.add(_currentState);
  }

  Future<void> signOut() async {
    _currentState = const AuthState.unauthenticated();
    await _persistSession(status: 'unauthenticated');
    _controller.add(_currentState);
  }

  Future<void> _persistSession({required String status, String? userId}) async {
    await _sessionBox.put('status', status);
    if (userId != null) {
      await _sessionBox.put('currentUserId', userId);
    } else {
      await _sessionBox.delete('currentUserId');
    }
  }

  String _hashPassword(String password) {
    final List<int> bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  void dispose() {
    _controller.close();
  }
}
