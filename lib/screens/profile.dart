import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String email;
  final String name;

  const ProfilePage({super.key, required this.email, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuário"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
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
                    name,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
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
              subtitle: Text(name),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.redAccent),
                onPressed: () {},
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.redAccent),
              title: const Text("Email"),
              subtitle: Text(email),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.redAccent),
                onPressed: () {},
              ),
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.redAccent),
              title: const Text("Senha"),
              subtitle: const Text("••••••••"),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.redAccent),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Ação de logout
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
