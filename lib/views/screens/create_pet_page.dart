// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreatePetPage extends StatefulWidget {
  const CreatePetPage({super.key});

  @override
  _CreatePetPageState createState() => _CreatePetPageState();
}

class _CreatePetPageState extends State<CreatePetPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _image1Controller = TextEditingController();
  final TextEditingController _image2Controller = TextEditingController();

  bool _isLoading = false;

  Future<void> _createPet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print("Token recuperado: $token");

      if (token == null) {
        throw Exception("Token não encontrado. Faça login novamente.");
      }

      final body = jsonEncode({
        "name": _nameController.text.trim(),
        "color": _colorController.text.trim(),
        "weight": int.parse(_weightController.text.trim()),
        "age": int.parse(_ageController.text.trim()),
        "images": [_image1Controller.text.trim(), _image2Controller.text.trim()]
      });

      print("Cabeçalhos: ${{
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      }}");
      print("Corpo: $body");

      final response = await http.post(
        Uri.parse("https://pet-adopt-dq32j.ondigitalocean.app/pet/create"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: body,
      );

      print("Status da resposta: ${response.statusCode}");
      print("Corpo da resposta: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Pet criado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );

        // Limpa os campos do formulário
        _formKey.currentState!.reset();
        _nameController.clear();
        _colorController.clear();
        _weightController.clear();
        _ageController.clear();
        _image1Controller.clear();
        _image2Controller.clear();

        // Redireciona para a tela inicial
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error['message'] ?? "Erro ao criar pet."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e, stackTrace) {
      print("Erro: $e");
      print("StackTrace: $stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Pet"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Preencha as informações do Pet",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _nameController,
                  label: "Nome",
                  hintText: "Digite o nome do pet",
                  validator: (value) => value == null || value.isEmpty
                      ? "Campo obrigatório"
                      : null,
                ),
                _buildTextField(
                  controller: _colorController,
                  label: "Cor",
                  hintText: "Digite a cor do pet",
                  validator: (value) => value == null || value.isEmpty
                      ? "Campo obrigatório"
                      : null,
                ),
                _buildTextField(
                  controller: _weightController,
                  label: "Peso (kg)",
                  hintText: "Digite o peso do pet",
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null
                      ? "Digite um peso válido"
                      : null,
                ),
                _buildTextField(
                  controller: _ageController,
                  label: "Idade",
                  hintText: "Digite a idade do pet",
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null
                      ? "Digite uma idade válida"
                      : null,
                ),
                _buildTextField(
                  controller: _image1Controller,
                  label: "Imagem 1 (URL)",
                  hintText: "URL da imagem principal do pet",
                  validator: (value) => value == null || value.isEmpty
                      ? "Campo obrigatório"
                      : null,
                ),
                _buildTextField(
                  controller: _image2Controller,
                  label: "Imagem 2 (URL)",
                  hintText: "URL de uma segunda imagem (opcional)",
                  validator: (value) => null,
                ),
                const SizedBox(height: 20),
                Center(
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton.icon(
                          onPressed: _createPet,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            "Adicionar Pet",
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
