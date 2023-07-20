import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

import 'package:provider/provider.dart';

class InfoCompany extends StatefulWidget {
  const InfoCompany({super.key});

  @override
  State<InfoCompany> createState() => _InfoCompanyState();
}

class _InfoCompanyState extends State<InfoCompany>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  String _infoCompanyText = '';
  double _scrollSpeed = 0.5;

  bool _isDarkMode = false; // Velocidad de desplazamiento ajustable

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadManualText(); // Cargar el contenido del archivo de texto al iniciar la vista
    _startScrolling(); // Iniciar la animación de desplazamiento
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Método para cargar el contenido del archivo de texto
  Future<void> _loadManualText() async {
    try {
      String data = await rootBundle.loadString('assets/texts/InfoCompany.txt');
      setState(() {
        _infoCompanyText = data;
      });
    } catch (e) {
      print('Error al cargar el archivo de texto: $e');
    }
  }

  // Método para iniciar la animación de desplazamiento
  void _startScrolling() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (_scrollController.offset <
          _scrollController.position.maxScrollExtent) {
        _scrollController.animateTo(
          _scrollController.offset + _scrollSpeed,
          duration: Duration(milliseconds: 50),
          curve: Curves.linear,
        );
      } else {
        timer.cancel();
        _showEndIndicator();
      }
    });
  }

  // Método para mostrar la indicación de finalización
  void _showEndIndicator() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Final'),
        content: TextButton(
          onPressed: () {
            _scrollController.jumpTo(0);
            _startScrolling();
            Navigator.of(context).pop();
          },
          child: Text('Volver a leer',
              style: TextStyle(
                  color: _isDarkMode ? Colors.white : Colors.grey[900])),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    var temaActual = theme.getTheme();
    if (temaActual == ThemeData.dark()) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Información de la empresa'),
        centerTitle: true,
        backgroundColor: _isDarkMode ? Colors.grey[900] : MyColors.myPurple,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                _infoCompanyText,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Cuando se presiona el botón, se inicia la animación
                  setState(() {
                    _scrollSpeed =
                        30.0; // Reiniciar la velocidad de desplazamiento a su valor original
                  });
                  _startScrolling();
                },
                child: Text('Comenzar a leer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
