import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  static const String apiUrl =
      "https://pet-adopt-dq32j.ondigitalocean.app/user/login";

  Future<Map<String, dynamic>> login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    print("Email inserido: $email"); // Debug do email
    print("Senha inserida: $password"); // Debug da senha

    if (email.isEmpty || password.isEmpty) {
      throw Exception("Por favor, preencha todos os campos.");
    }

    try {
      print("Iniciando requisição para API: $apiUrl"); // Debug do endpoint

      // Adicionando os prints dos cabeçalhos e corpo enviados
      print("Cabeçalhos enviados: ${{"Content-Type": "application/json"}}");
      print("Corpo enviado: ${jsonEncode({
            "email": email,
            "password": password
          })}");

      // Requisição HTTP
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print(
          "Resposta recebida: ${response.statusCode}"); // Debug do código HTTP
      print(
          "Corpo da resposta: ${response.body}"); // Debug do corpo da resposta

      final data = jsonDecode(response.body);

      // Verifica status HTTP
      if (response.statusCode == 200) {
        print(
            "Login bem-sucedido! Dados retornados: $data"); // Debug de sucesso

        if (data.containsKey('token') && data.containsKey('userId')) {
          // Salva os dados no SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          await prefs.setString('userId', data['userId']);

          if (data.containsKey('isAdmin')) {
            await prefs.setBool('isAdmin', data['isAdmin']);
          }

          print("Token salvo: ${data['token']}"); // Debug do token
          print("UserId salvo: ${data['userId']}"); // Debug do userId

          return {
            "success": true,
            "message": "Login realizado com sucesso!",
            "data": data
          };
        } else {
          throw Exception(
              data['message'] ?? "Erro: Resposta incompleta da API.");
        }
      } else if (response.statusCode == 400) {
        print("Erro 400: ${data['message']}"); // Debug de erro 400
        throw Exception(data['message'] ?? "Requisição inválida.");
      } else if (response.statusCode == 401) {
        print("Erro 401: ${data['message']}"); // Debug de erro 401
        throw Exception(data['message'] ?? "Credenciais inválidas.");
      } else if (response.statusCode == 500) {
        print("Erro 500: Erro interno do servidor."); // Debug de erro 500
        throw Exception(
            "Erro interno do servidor. Tente novamente mais tarde.");
      } else {
        print(
            "Erro inesperado: ${response.statusCode} - ${response.body}"); // Debug para outros códigos de erro
        throw Exception(
            "Erro ao se conectar com o servidor. Status: ${response.statusCode}");
      }
    } catch (e) {
      print('Erro na requisição de login: $e'); // Debug do catch
      throw Exception("Falha na requisição: $e");
    }
  }

  void clearControllers() {
    print("Limpando campos de entrada"); // Debug do clear
    emailController.clear();
    passwordController.clear();
  }

  void dispose() {
    print("Disposing controllers"); // Debug do dispose
    emailController.dispose();
    passwordController.dispose();
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print("Token encontrado no dispositivo: $token"); // Debug do token salvo
    return token != null;
  }

  Future<void> logout() async {
    print("Realizando logout..."); // Debug do logout
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print("SharedPreferences limpo com sucesso."); // Debug do clear
  }
}
