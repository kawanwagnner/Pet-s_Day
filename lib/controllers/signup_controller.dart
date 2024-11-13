import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  // Função para realizar cadastro com API usando requisição POST
  Future<bool> signup() async {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;

    // Valida se os campos estão vazios
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception("Por favor, preencha todos os campos.");
    }

    // URL do endpoint de cadastro da API
    const String apiUrl = "https://suaapi.com/api/signup";

    try {
      // Envia a requisição POST para o endpoint de cadastro
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      // Verifica se a requisição foi bem-sucedida
      if (response.statusCode == 201) {
        // 201 geralmente é usado para criação bem-sucedida
        final data = jsonDecode(response.body);

        // Supondo que a API retorna um campo `success` para indicar sucesso no cadastro
        if (data['success'] == true) {
          return true; // Cadastro bem-sucedido
        } else {
          throw Exception(data['message'] ?? "Erro desconhecido no cadastro.");
        }
      } else {
        throw Exception("Erro ao se conectar com o servidor.");
      }
    } catch (e) {
      throw Exception("Falha na requisição: $e");
    }
  }

  // Função para limpar os campos após o cadastro
  void clearControllers() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }
}
