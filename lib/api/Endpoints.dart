import 'package:http/http.dart' as http;

// ignore: depend_on_referenced_packages
enum Difficulty { EASY, MEDIUM, HARD }

enum ExamTypes { MULTIPLE, BOOLEAN }

List<String> difficulties = ['easy', 'medium', 'hard'];
List<String> types = ['multiple', 'boolean'];

class Endpoints {
  static Map<String, dynamic> getLink(
      int? category, Difficulty? difficulty, ExamTypes? type,
      {int amount = 10}) {
    return {
      'authority': 'opentdb.com',
      'uncodedPath': '/api.php',
      'query': {
        'amount': amount.toString(),
        'category': category != null ? category.toString() : '',
        'type': type != null ? types[type.index] : '',
        'difficulty': difficulty != null ? difficulties[difficulty.index] : '',
      }
    };
  }

  static Future getQuestions(Map<String, dynamic> link) {
    Uri url = Uri.https(link['authority'], link['uncodedPath'], link['query']);
    return http.get(url);
  }
}
