import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_icons/simple_icons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

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
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    _isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                    color: _isDarkMode ? Colors.grey : Colors.black,
                  ),
                  title: Text(
                    _isDarkMode ? 'Modo oscuro' : 'Modo claro',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text(
                    'Idioma',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text(
                    'Ayuda',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.28,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NewRow(
                  mode: _isDarkMode ? Colors.white : Colors.black,
                  icon: SimpleIcons.codeberg,
                  colorIcon: Colors.green,
                  textOne: 'Desarrollado por: ',
                  textTwo: "Victor Ardila",
                  type: 'text',
                ),
                NewRow(
                  mode: _isDarkMode ? Colors.white : Colors.black,
                  icon: SimpleIcons.gmail,
                  colorIcon: Colors.red,
                  textOne: 'Contacto: ',
                  textTwo: "victoradila@gmail.com",
                  type: 'link',
                ),
                NewRow(
                  mode: _isDarkMode ? Colors.white : Colors.black,
                  icon: SimpleIcons.git,
                  colorIcon: Colors.orange,
                  textOne: 'Git Hub:',
                  textTwo: "Aqui",
                  type: 'link',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NewRow extends StatelessWidget {
  final Color mode;
  final IconData icon;
  final Color colorIcon;
  final String textOne;
  final String textTwo;
  final String type;

  NewRow({
    Key? key,
    required this.mode,
    required this.icon,
    required this.colorIcon,
    required this.textOne,
    required this.textTwo,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color modeColor = this.mode;
    bool isLink = this.type == 'link';
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  // Lógica a ejecutar al presionar el botón
                },
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            icon,
                            color: colorIcon,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              textOne,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              textTwo,
                              style: TextStyle(
                                color: isLink ? Colors.blue : modeColor,
                                fontSize: 16,
                                decoration: isLink
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
