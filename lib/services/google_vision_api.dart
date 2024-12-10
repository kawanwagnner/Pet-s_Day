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
        for (var label in labels) {
          if (label['description'].toLowerCase().contains("dog")) {
            return "Cachorro";
          } else if (label['description'].toLowerCase().contains("cat")) {
            return "Gato";
          }
        }
        return "Outro animal ou objeto";
      } else {
        return "Nenhum rótulo identificado";
      }
    } else {
      throw Exception("Erro na API: ${response.body}");
    }
  }
}
