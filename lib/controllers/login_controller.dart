import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Função para realizar login com API usando requisição POST
  Future<bool> login() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    // Valida se os campos estão vazios
    if (email.isEmpty || password.isEmpty) {
      throw Exception("Por favor, preencha todos os campos.");
    }

    // URL do endpoint de login da API
    const String apiUrl = "https://suaapi.com/api/login";

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

      // Verifica se a requisição foi bem-sucedida
      if (response.statusCode == 200) {
        // Decodifica a resposta da API
        final data = jsonDecode(response.body);

        // Supondo que a API retorna um campo `success` para indicar o sucesso do login
        if (data['success'] == true) {
          return true; // Login bem-sucedido
        } else {
          throw Exception(data['message'] ?? "Erro desconhecido no login.");
        }
      } else {
        throw Exception("Erro ao se conectar com o servidor.");
      }
    } catch (e) {
      throw Exception("Falha na requisição: $e");
    }
  }

  // Função para limpar os campos após o login
  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }
}
