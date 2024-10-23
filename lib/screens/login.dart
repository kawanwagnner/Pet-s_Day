import 'package:flutter/material.dart';
import 'package:pet_adopt/screens/profile.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailOrNameController = TextEditingController();
  final _passwordController = TextEditingController();

  final String registeredEmail = "email@example.com";
  final String registeredPassword = "password123";
  final String registeredName = "Nome de Exemplo"; // Nome do usuário registrado

  void _login() {
    final String emailOrName = _emailOrNameController.text;
    final String password = _passwordController.text;

    // Verifica se o campo de email/nome ou senha está vazio
    if (emailOrName.isEmpty || password.isEmpty) {
      _showError("Por favor, preencha todos os campos.");
      return;
    }

    // Verifica se o valor inserido corresponde ao e-mail ou nome do usuário
    if ((emailOrName != registeredEmail && emailOrName != registeredName)) {
      // O erro pode estar aqui
      _showError("E-mail ou nome incorreto.");
      return;
    }

    // Verifica se a senha está correta
    if (password != registeredPassword) {
      _showError("Senha incorreta.");
      return;
    }

    // Se as credenciais estiverem corretas, navega para a tela de perfil
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProfilePage(email: registeredEmail, name: registeredName),
      ),
    );
  }

  void _showError(String message) {
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              controller: _emailOrNameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "E-mail / Usuário",
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
              controller: _passwordController,
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
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
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
            // Container(
            //   height: 60,
            //   alignment: Alignment.centerLeft,
            //   decoration: const BoxDecoration(
            //     color: Color(0xFF3C5A99),
            //     borderRadius: BorderRadius.all(Radius.circular(5)),
            //   ),
            //   child: SizedBox.expand(
            //     child: TextButton(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: <Widget>[
            //           const Text(
            //             "Login com Facebook",
            //             style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white,
            //               fontSize: 20,
            //             ),
            //             textAlign: TextAlign.left,
            //           ),
            //           SizedBox(
            //             height: 28,
            //             width: 28,
            //             child: Image.asset("assets/img/fb-icon.png"),
            //           ),
            //         ],
            //       ),
            //       onPressed: () {},
            //     ),
            //   ),
            // ),
            // const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: TextButton(
                child: const Text(
                  "Cadastre-se",
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
