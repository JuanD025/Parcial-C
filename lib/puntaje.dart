import 'package:flutter/material.dart';

class Record extends StatelessWidget {
  final List<List<dynamic>> lista;

  Record({required this.lista});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage1(datos: lista));
  }
}

class MyHomePage1 extends StatefulWidget {
  final List<List<dynamic>> datos;

  MyHomePage1({required this.datos});
  @override
  lista createState() => lista();
}

class lista extends State<MyHomePage1> {
  List<List<dynamic>> d = [];

  void initState() {
    super.initState();
    d = widget.datos;
  }

  void salir() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Salir"),
          content: Text("¿Estás seguro de que quieres salir?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Puntajes registrados',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: d.isEmpty
          ? Center(
              child: Text('No hay elementos'),
            )
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Nombre',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Movimientos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      'Tiempo(s)',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ))
                  ],
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: d.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            d[index][0],
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            d[index][1].toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            d[index][2].toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: salir,
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
