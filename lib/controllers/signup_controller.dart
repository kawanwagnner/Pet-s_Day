import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pet_adopt/models/user.dart';

class SignupController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // URL do endpoint de cadastro da API
  static const String apiUrl =
      "https://pet-adopt-dq32j.ondigitalocean.app/user/register";

  // Função para validar URLs (se necessário)
  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  // Função para realizar cadastro com API usando requisição POST
  Future<bool> signup() async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String phone = phoneController.text.trim();
    final String password = passwordController.text;
    final String confirmpassword = confirmPasswordController.text;

    // Valida se os campos estão vazios
    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty) {
      throw Exception("Por favor, preencha todos os campos.");
    }

    // Valida se as senhas coincidem
    if (password != confirmpassword) {
      throw Exception("As senhas não coincidem.");
    }

    // Cria uma instância da classe User
    User user = User(
      name: name,
      email: email,
      phone: phone,
      password: password,
      confirmpassword: confirmpassword,
    );

    try {
      // Envia a requisição POST para o endpoint de cadastro
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      // Log da resposta para depuração
      print('Resposta da API: ${response.statusCode} - ${response.body}');

      // Verifica o status da resposta
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Supondo que a API retorna um campo `success` para indicar sucesso no cadastro
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          clearControllers(); // Limpa os campos após sucesso
          return true; // Cadastro bem-sucedido
        } else {
          throw Exception(data['message'] ?? "Erro desconhecido no cadastro.");
        }
      } else if (response.statusCode == 400) {
        // 400: Requisição inválida (por exemplo, validação falhou)
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? "Requisição inválida.");
      } else if (response.statusCode == 409) {
        // 409: Conflito (por exemplo, email já registrado)
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? "Conflito na requisição.");
      } else {
        // Outros códigos de status
        throw Exception(
            "Erro ao se conectar com o servidor. Status: ${response.statusCode}");
      }
    } catch (e) {
      // Captura e lança a exceção para ser tratada na UI
      print('Erro na requisição de cadastro: $e');
      throw Exception("Falha na requisição: $e");
    }
  }

  // Função para limpar os campos após o cadastro
  void clearControllers() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  // Função para descartar os controladores quando não forem mais necessários
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}
