// Creado por: Marco Antonio Rosas Gonzalez
// Asignatura: Desarrollo Movil Integral
//Grado: 10   Grupo: "A"
// Docente: MTI. Marco Antonio Ramirez Hernandez
import 'dart:async'; // Importa la biblioteca para manejar operaciones asíncronas.
import 'dart:convert'; // Importa la biblioteca para codificar y decodificar JSON.
import 'package:http/http.dart' as http; // Importa la biblioteca para realizar solicitudes HTTP.
import 'package:movieapp_200749/common/Constants.dart'; // Importa un archivo Constants.dart.
import 'package:movieapp_200749/model/Media.dart'; // Importa la definición de la clase Media.
import 'package:movieapp_200749/model/Cast.dart';

class HttpHandler {
  static final _httHandler = new HttpHandler();
  final String _baseUrl = "api.themoviedb.org";
  final String _language =
      "es-MX";

  static HttpHandler get(){
    return _httHandler;
  }

  Future<dynamic> getJson(Uri uri) async {
    http.Response response =
        await http.get(uri);
    return json.decode(response.body);
  }
  
Future<List<Media>> fetchMovies({String category = "populares"}) async {
  var uri = new Uri.https(
    _baseUrl,
    "3/movie/$category",
    {
      'api_key': API_KEY,
      'page': "1",
      'language': _language,
    },
  );

  return getJson(uri).then((data) {
    if (category == "upcoming") {
      var sortedResults = data['results']
          .where((item) => item['release_date'] != null)
          .toList()
            ..sort((a, b) {
              DateTime dateA = DateTime.parse(a['release_date']);
              DateTime dateB = DateTime.parse(b['release_date']);
              return dateB.compareTo(dateA);
            });

      return sortedResults
          .map<Media>((item) => new Media(item, MediaType.movie))
          .toList();
    } else {
      return data['results']
          .map<Media>((item) => new Media(item, MediaType.movie))
          .toList();
    }
  });
}

  Future<List<Media>> fetchShow({String category = "populares"}) async {
    var uri = new Uri.https(
        _baseUrl,
        "3/tv/$category", 
        {
          'api_key': API_KEY,
          'page': "1",
          'language': _language
        });
    return getJson(uri).then(((data) =>
        data['results'].map<Media>((item) => new Media(item, MediaType.show)).toList()));
  }
  Future<List<Media>> fetchCreditMovies(int mediaId) async {
    var uri = new Uri.https(_baseUrl,"3/movie/$mediaId/credits", 
        {
          'api_key': API_KEY,
          'page': "1",
          'language': _language
        });
    return getJson(uri).then(((data) =>
        data['cast'].map<Cast>((item) => new Cast(item, MediaType.movie)).toList()));
  }
  Future<List<Media>> fetchCreditShows(int mediaId) async {
    var uri = new Uri.https(_baseUrl,"3/tv/$mediaId/credits", 
        {
          'api_key': API_KEY,
          'page': "1",
          'language': _language
        });
    return getJson(uri).then(((data) =>
        data['cast'].map<Cast>((item) => new Cast(item, MediaType.show)).toList()));
  }
}