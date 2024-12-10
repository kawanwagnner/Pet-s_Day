import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleVisionApi {
  final String apiKey;

  GoogleVisionApi(this.apiKey);

  Future<String> classifyImage(String imageUrl) async {
    final url = "https://vision.googleapis.com/v1/images:annotate?key=$apiKey";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "requests": [
          {
            "image": {
              "source": {"imageUri": imageUrl}
            },
            "features": [
              {"type": "LABEL_DETECTION", "maxResults": 10}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final labels = data['responses'][0]['labelAnnotations'];

      if (labels != null && labels.isNotEmpty) {
        // Loop através das labels e verifica se existe "dog" ou "cat"
        for (var label in labels) {
          final description = label['description'].toLowerCase();

          // Debug: Imprimir cada label para verificar como a API está retornando
          print('Descrição da label: $description');

          if (description == "dog" || description == "cachorro") {
            return "Cachorro";
          } else if (description == "cat" || description == "gato") {
            return "Gato";
          }
        }
        // Caso não encontre "dog" ou "cat", retorna "Outro"
        return "Outro";
      } else {
        return "Nenhum rótulo identificado";
      }
    } else {
      throw Exception("Erro na API: ${response.body}");
    }
  }
}
