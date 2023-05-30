import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'juego.dart';
import 'puntaje.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Juego del granjero, la oveja, la col y el lobo',
      home: Inicio(
        datos: [],
      ),
    );
  }
}

class Inicio extends StatefulWidget {
  final List<List<dynamic>> datos;
  Inicio({required this.datos});
  @override
  inicioState createState() => inicioState();
}

class inicioState extends State<Inicio> {
  final nombreController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<List<dynamic>> datos = [];

  @override
  void dispose() {
    nombreController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    final usuarios = await getUsuarios();
    print(usuarios);
    datos = usuarios;
  }

  void _sendMessageToWhatsApp() async {
    String phoneNumber = "573003155203";
    String message = "hola";
    //String url = "whatsapp://send?phone=$phoneNumber&text=" + message;
    String url = "https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}";
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Crusar el rio',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 16.0),
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: nombreController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ingrese su nombre',
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.contains("'") ||
                            value.contains('"')) {
                          return 'Por favor ingrese un nombre válido';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Juego(
                              nombre: nombreController.text,
                              count: 0,
                              time: 0,
                            ),
                          ),
                        );
                        if (result != null) {
                          final nombre = result[0];
                          final count = result[1];
                          final time = result[2];
                          createUser(nombre, count, time);
                          widget.datos.add([nombre, count, time]);
                        }
                      }
                    },
                    child: Text('Comenzar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          heroTag: 'unique_tag11',
          onPressed: () {
            cargarUsuarios();
            print(datos);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Record(lista: datos)),
            );
          },
          child: Text('Record'),
        ),
        SizedBox(width: 16.0),
        FloatingActionButton(
            heroTag: 'unique_tag132',
            onPressed: () {
              _sendMessageToWhatsApp();
            },
            child: Icon(Icons.help_sharp)),
      ]),
    );
  }
}

final url = Uri.parse('http://localhost:3000/users');

Future<http.Response> createUser(String nombre, int puntaje, int time) async {
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"nombre": nombre, "puntaje": puntaje, "time": time}),
  );
  return response;
}

Future<List<List<dynamic>>> getUsuarios() async {
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;

      final datos = jsonData
          .map((item) => [item['nombre'], item['puntaje'], item['time']])
          .toList();

      return datos;
    } else {
      return [];
    }
  } catch (e) {
    print('Error al conectarse al servidor: $e');
    return Future.value([]); // aquí se retorna una Future vacía
  }
}
