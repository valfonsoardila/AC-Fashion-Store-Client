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
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ajustes',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        icon: Icon(
                          Icons.brightness_4,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Tema',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        onPressed: () {
                          // Lógica a ejecutar al presionar el botón
                          var temaActual = theme.getTheme();
                          print(temaActual);
                          if (temaActual == ThemeData.light()) {
                            theme.setTheme(ThemeData.dark());
                          } else {
                            if (temaActual == ThemeData.dark()) {
                              theme.setTheme(ThemeData.light());
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        icon: Icon(
                          Icons.language,
                          color: Colors.black,
                        ),
                        label: Text('Idioma',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        onPressed: () {
                          // Lógica a ejecutar al presionar el botón
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextButton.icon(
                        icon: Icon(
                          Icons.help,
                          color: Colors.black,
                        ),
                        label: Text('Ayuda',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        onPressed: () {
                          // Lógica a ejecutar al presionar el botón
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomRight,
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                NewRow(
                    icon: SimpleIcons.codeberg,
                    colorIcon: Colors.green,
                    textOne: 'Desarrollado por: ',
                    textTwo: ""),
                NewRow(
                    icon: SimpleIcons.gmail,
                    colorIcon: Colors.red,
                    textOne: 'Contacto: ',
                    textTwo: ""),
                NewRow(
                    icon: SimpleIcons.git,
                    colorIcon: Colors.orange,
                    textOne: 'Git Hub:',
                    textTwo: ""),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NewRow extends StatelessWidget {
  final IconData icon;
  final Color colorIcon;
  final String textOne;
  final String textTwo;

  NewRow({
    Key? key,
    required this.icon,
    required this.colorIcon,
    required this.textOne,
    required this.textTwo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                color: Colors.white,
                                fontSize: 16,
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
