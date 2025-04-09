import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
  loading,
}

class AuthProvider extends ChangeNotifier {
  static const String _userKey = 'user_data';
  AuthStatus _status = AuthStatus.loading;
  User? _user;

  AuthProvider() {
    _loadUser();
  }

  AuthStatus get status => _status;
  User? get user => _user;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> _loadUser() async {
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson == null) {
        _status = AuthStatus.unauthenticated;
      } else {
        _user = User.fromJson(Map<String, dynamic>.from(
          // ignore: avoid_dynamic_calls
          (jsonDecode(userJson) as Map<String, dynamic>),
        ));
        _status = AuthStatus.authenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    // Em um app real, faríamos uma chamada à API de login
    // Simulando uma autenticação bem-sucedida para fins de demo:
    if (email.isNotEmpty && password.isNotEmpty) {
      _user = User(
        id: '1',
        name: 'Usuário Demo',
        email: email,
      );
      _status = AuthStatus.authenticated;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    // Em um app real, faríamos uma chamada à API de registro
    // Simulando um registro bem-sucedido para fins de demo:
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      _user = User(
        id: '1',
        name: name,
        email: email,
      );
      _status = AuthStatus.authenticated;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    _user = null;
    _status = AuthStatus.unauthenticated;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    
    notifyListeners();
  }

  Future<void> updateUserData(User updatedUser) async {
    _user = updatedUser;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
    
    notifyListeners();
  }
}

// Função auxiliar
dynamic jsonDecode(String source) {
  try {
    return const JsonDecoder().convert(source);
  } catch (e) {
    return null;
  }
}

// Função auxiliar
String jsonEncode(Object? object) {
  return const JsonEncoder().convert(object);
}

class JsonDecoder {
  const JsonDecoder();
  
  dynamic convert(String source) {
    // Implementação simplificada para mapeamento JSON
    // Em um aplicativo real, usaríamos a função jsonDecode real do dart:convert
    return {'id': '1', 'name': 'Usuário Demo', 'email': 'usuario@demo.com'};
  }
}

class JsonEncoder {
  const JsonEncoder();
  
  String convert(Object? object) {
    // Implementação simplificada
    // Em um aplicativo real, usaríamos a função jsonEncode real do dart:convert
    return '{"id":"1","name":"Usuário Demo","email":"usuario@demo.com"}';
  }
} 