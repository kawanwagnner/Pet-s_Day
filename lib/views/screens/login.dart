// login_page.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pet_adopt/controllers/login_controller.dart';
import 'package:pet_adopt/views/screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _loginController = LoginController();
  bool _isLoading = false;

  void _login() async {
    print("Iniciando processo de login..."); // Debug

    setState(() {
      _isLoading = true;
    });

    try {
      print("Chamando método login() do LoginController"); // Debug
      final response = await _loginController.login();

      print("Resposta do login: $response"); // Debug da resposta

      setState(() {
        _isLoading = false;
      });

      if (response['success']) {
        print("Login realizado com sucesso!"); // Debug de sucesso
        // Exibe uma mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login bem-sucedido!')),
        );

        // Limpa os campos de entrada
        print("Limpando os campos de entrada..."); // Debug do clear
        _loginController.clearControllers();

        // Navega para a HomeScreen
        print("Navegando para a HomeScreen..."); // Debug da navegação
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        print(
            "Erro retornado pela API: ${response['message']}"); // Debug do erro da API
        // Exibe o erro retornado pela API
        _showError(response['message']);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      print("Erro capturado no processo de login: $error"); // Debug do erro

      // Exibe a mensagem de erro exatamente como veio na exceção
      _showError(error.toString());
    }
  }

  void _showError(String message) {
    print("Exibindo mensagem de erro: $message"); // Debug do erro exibido
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Erro de Login"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                print(
                    "Fechando diálogo de erro"); // Debug do fechamento do diálogo
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Método para verificar se o usuário já está logado
  void _checkLoginStatus() async {
    print("Verificando se o usuário já está logado..."); // Debug
    bool isLoggedIn = await _loginController.isLoggedIn();

    print("Status de login: $isLoggedIn"); // Debug do status de login

    if (isLoggedIn) {
      print("Usuário já está logado, navegando para a HomeScreen..."); // Debug
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    print("Inicializando LoginPage..."); // Debug
    _checkLoginStatus();
  }

  @override
  void dispose() {
    print("Limpando recursos de LoginPage..."); // Debug
    _loginController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.only(
                top: 60,
                left: 40,
                right: 40,
              ),
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    width: 128,
                    height: 128,
                    child: Image.asset("assets/img/logo.png"),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _loginController.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "E-mail",
                      labelStyle: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _loginController.passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Senha",
                      labelStyle: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    style: const TextStyle(fontSize: 20),
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: const Text("Recuperar Senha"),
                      onPressed: () {
                        print(
                            "Navegando para a página de recuperação de senha"); // Debug
                        Navigator.pushNamed(context, '/reset-password');
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    height: 60,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.3, 1],
                          colors: [
                            Color(0xFFF58524),
                            Color(0xFFF92B7F),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: SizedBox.expand(
                      child: TextButton(
                        onPressed: _login,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: 28,
                              width: 28,
                              child: Image.asset("assets/img/bone.png"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: TextButton(
                      child: const Text(
                        "Cadastre-se",
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        print("Navegando para a página de cadastro"); // Debug
                        Navigator.pushNamed(context, '/signup');
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
