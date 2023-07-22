import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/views/block_info/Info_help.dart';
import 'package:acfashion_store/ui/views/block_info/info_company.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    _isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                    color: _isDarkMode
                        ? Colors.tealAccent
                        : Colors.yellow.shade800,
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
                        _isDarkMode = !_isDarkMode;
                        if (_isDarkMode) {
                          theme.setTheme(ThemeData.dark());
                        } else {
                          theme.setTheme(ThemeData.light());
                        }
                      });
                    },
                  ),
                ),
                ListTile(
                    leading: Icon(Icons.info),
                    title: Text(
                      '¿Quienes somos?',
                      style: TextStyle(
                        color: _isDarkMode ? Colors.white : Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoCompany()));
                    }),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text(
                    'Ayuda',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => InfoHelp()));
                  },
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
                  textOne: 'Creditos a: ',
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

    void _launchURL(String url) async {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  if (isLink) {
                    if (textOne == 'Git Hub:') {
                      _launchURL(
                          'https://github.com/VictorArdila?tab=repositories'); // Reemplaza "tu_usuario" con tu nombre de usuario de GitHub
                    } else if (textOne == 'Contacto: ') {
                      _launchURL(
                          'mailto:victoradila@gmail.com?subject=Asunto%20del%20mensaje'); // Reemplaza el correo por el que desees y opcionalmente el asunto del mensaje
                    }
                  } else {
                    // Lógica a ejecutar al presionar el botón cuando no es un enlace
                  }
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
                                color: modeColor,
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
