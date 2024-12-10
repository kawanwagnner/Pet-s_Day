import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _userData;

  // Função para buscar os dados do usuário
  Future<Map<String, dynamic>> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Pega o token salvo
    String? userId = prefs.getString('userId'); // Pega o userId salvo

    if (token == null || userId == null) {
      throw Exception("Usuário não está logado.");
    }

    final url = Uri.parse(
        "https://pet-adopt-dq32j.ondigitalocean.app/user/$userId"); // Rota para pegar o usuário

    print("Requisitando dados do usuário em $url");
    final response = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    print("Status da resposta: ${response.statusCode}");
    print("Corpo da resposta: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['user']; // Acessa diretamente o campo 'user'
    } else {
      throw Exception("Erro ao buscar dados do usuário: ${response.body}");
    }
  }

  @override
  void initState() {
    super.initState();
    _userData = _fetchUserData(); // Inicializa a busca dos dados
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuário"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Carregando
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Erro: ${snapshot.error}"), // Exibe o erro
            );
          } else if (snapshot.hasData) {
            final userData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              AssetImage("assets/img/profile-picture.png"),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userData['name'] ?? "Nome não disponível",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userData['email'] ?? "Email não disponível",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.redAccent),
                    title: const Text("Nome"),
                    subtitle: Text(userData['name'] ?? "Nome não disponível"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.redAccent),
                      onPressed: () {
                        // Implementar edição
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.redAccent),
                    title: const Text("Email"),
                    subtitle: Text(userData['email'] ?? "Email não disponível"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.redAccent),
                      onPressed: () {
                        // Implementar edição
                      },
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock, color: Colors.redAccent),
                    title: const Text("Senha"),
                    subtitle: const Text("••••••••"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.redAccent),
                      onPressed: () {
                        // Implementar edição de senha
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.clear(); // Limpa os dados do usuário
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login', // Navega para a rota de login
                        (Route<dynamic> route) =>
                            false, // Remove todas as telas anteriores
                      );
                    },
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Desconectar",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("Nenhum dado encontrado."),
            );
          }
        },
      ),
    );
  }
}
