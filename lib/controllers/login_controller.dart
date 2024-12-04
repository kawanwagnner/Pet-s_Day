// auth_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // URL do endpoint de login da API
  static const String apiUrl =
      "https://pet-adopt-dq32j.ondigitalocean.app/user/login";

  // Função para realizar login com API usando requisição POST
  Future<Map<String, dynamic>> login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    // Valida se os campos estão vazios
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Por favor, preencha todos os campos.");
    }

    try {
      // Envia a requisição POST para o endpoint
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      // Log da resposta para depuração
      print('Resposta da API: ${response.statusCode} - ${response.body}');

      // Decodifica a resposta da API
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Tratamento de status codes
      if (response.statusCode == 200) {
        // Supondo que a API retorna um token ou dados do usuário
        if (data.containsKey('token')) {
          // Salva o token e outras informações no SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          await prefs.setString('userId', data['userId']);
          await prefs.setBool('isAdmin', data['isAdmin']);

          return {
            "success": true,
            "message": "Login realizado com sucesso!",
            "data": data
          };
        } else {
          // Caso o token não esteja presente, considere como erro
          throw Exception(data['message'] ?? "Erro desconhecido no login.");
        }
      } else if (response.statusCode == 400) {
        // 400: Requisição inválida (por exemplo, validação falhou)
        throw Exception(data['message'] ?? "Requisição inválida.");
      } else if (response.statusCode == 401) {
        // 401: Não autorizado (credenciais inválidas)
        throw Exception(data['message'] ?? "Credenciais inválidas.");
      } else if (response.statusCode == 500) {
        // 500: Erro interno do servidor
        throw Exception(
            "Erro interno do servidor. Por favor, tente novamente mais tarde.");
      } else {
        // Outros códigos de status
        throw Exception(
            "Erro ao se conectar com o servidor. Status: ${response.statusCode}");
      }
    } catch (e) {
      // Captura e lança a exceção para ser tratada na UI
      print('Erro na requisição de login: $e');
      throw Exception("Falha na requisição: $e");
    }
  }

  // Função para limpar os campos após o login
  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }

  // Função para descartar os controladores quando não forem mais necessários
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  // Método para verificar se o usuário está logado
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }

  // Método para fazer logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
