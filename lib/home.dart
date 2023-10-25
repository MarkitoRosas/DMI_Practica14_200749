// Creado por: Marco Antonio Rosas Gonzalez
// Asignatura: Desarrollo Movil Integral
//Grado: 10   Grupo: "A"
// Docente: MTI. Marco Antonio Ramirez Hernandez
import 'dart:ffi';

import 'package:flutter/material.dart'; // Importa la biblioteca Flutter para construir interfaces de usuario.
import 'package:movieapp_200749/common/HttpHandler.dart'; // Importa la clase HttpHandler desde un archivo llamado HttpHandler.dart.
import 'package:movieapp_200749/media_list.dart';
import 'package:movieapp_200749/common/MediaProvider.dart';
import 'package:movieapp_200749/model/Media.dart';

class Home extends StatefulWidget {
  const Home(
      {super.key});
  @override
  State<Home> createState() =>
      _HomeState();
}

class _HomeState extends State<Home> {
@override
void initState(){
  _pageController = PageController();
  super.initState();
}
@override
void dispose(){
  _pageController?.dispose();
  super.dispose();
}
  final MediaProvider movieProvider = new MediaPrvider();
  final MediaProvider showProvider = new ShowProvider();
  PageController? _pageController;
  int _page = 0;

  MediaType mediaType = MediaType.movie;
  final TextStyle customTextStyle = TextStyle(
    fontFamily: 'MiFuente',
    fontSize: 16.0,
    fontWeight: FontWeight
        .bold,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("MovieApp-200749"),
        titleTextStyle: TextStyle(fontFamily: 'MiFuente'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.search,
              color: Colors.black26,
            ),
            onPressed: () {
            },
          ),
        ],
      ),
       drawer: new Drawer(
        backgroundColor: Colors.redAccent,
        // Menú lateral (Drawer) que se despliega desde el borde izquierdo
        child: new ListView(children: <Widget>[
          new DrawerHeader(
              child: new Material()), // Encabezado del menú lateral
          new ListTile(
            title: new Text(
              "Peliculas",
              style:
                  customTextStyle,
            ),
            selected: mediaType == MediaType.movie,
            trailing: new Icon(Icons.local_movies),
            onTap: () {
              _changeMediaType(MediaType.movie);
              Navigator.of(context).pop();
            },
          ),
          new Divider(
            height: 5.0,
          ),
          new ListTile(
            title: new Text(
              "Television",
              style:
                  customTextStyle,
            ),
             trailing: new Icon(Icons.live_tv ),
              onTap: () {
              _changeMediaType(MediaType.show);
              Navigator.of(context).pop();
            },
          ),
          new Divider(
            height: 5.0,
          ),
          new ListTile(
            title: new Text(
              "Cerrar",
              style:
                  customTextStyle,
            ),
           trailing: new Icon(Icons.close),
            onTap: () => Navigator.of(context)
                .pop(),
          ),
        ]),
      ),
      body: PageView(
      children: _getMediaList(),
      controller: _pageController,
      onPageChanged: (int index){
        setState(() {
          _page = index;
        });
      },
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: _obtenerIconos(),
        onTap: _navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  List<BottomNavigationBarItem> _obtenerIconos() {
    return mediaType == MediaType.movie ? [
      BottomNavigationBarItem(
          icon: Icon(Icons.thumb_up_alt_rounded), label: "Populares"),
      BottomNavigationBarItem(
          icon: Icon(Icons.update_rounded), label: "Proximamente"),
      BottomNavigationBarItem(
          icon: Icon(Icons.star_rounded), label: "Mejor Valoradas"),
    ]:
    [
      BottomNavigationBarItem(
          icon: Icon(Icons.thumb_up_alt_rounded), label: "Populares"),
      BottomNavigationBarItem(
          icon: Icon(Icons.update_rounded), label: "Al aire"),
      BottomNavigationBarItem(
          icon: Icon(Icons.star_rounded), label: "Mejor Valoradas"),
    ];
  }

  void _changeMediaType(MediaType type) {
    if (mediaType != type) {
      setState(() {
        mediaType = type;
      });
    }
  }

  List<Widget> _getMediaList() {
    return (mediaType == MediaType.movie)
        ? <Widget>[
        new MediaList(movieProvider,"popular"),
        MediaList(movieProvider,"upcoming"),
        MediaList(movieProvider,"top_rated")
        ]: <Widget>[
          new MediaList(showProvider, "popular"),
          new MediaList(showProvider, "on_the_air"),
          new MediaList(showProvider, "top_rated")
          ];
  }

  void _navigationTapped(int page){
    _pageController?.animateToPage(page, duration: const Duration(microseconds:300),curve: Curves.ease);
  }
}