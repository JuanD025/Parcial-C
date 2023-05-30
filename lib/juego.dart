import 'package:flutter/material.dart';
import 'dart:async';
import 'videos.dart';

class Juego extends StatelessWidget {
  final String nombre;
  final int count;
  final int time;
  Juego({required this.nombre, required this.count, required this.time});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyHomePage(nombre: nombre));
  }
}

class MyHomePage extends StatefulWidget {
  final String nombre;
  MyHomePage({required this.nombre});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Item {
  final String name;
  final Image image;
  String previousColumn;
  Item({required this.name, required this.image, this.previousColumn = ''});
}

class _MyHomePageState extends State<MyHomePage> {
  String nombre = '';
  int time = 0;
  bool anuncioV = false;
  var timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {});

  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        time++;
      });
    });
    nombre = widget.nombre;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Bienvenido!'),
          content: Text(
              'Ena aplicación para cruzar el río. Toque el botón "Mover" para mover los objetos de una columna a otra. El objetivo es llevar todos los objetos a la otra orilla del río sin dejar a ningún par de objetos peligrosos juntos. Reglas: 1. EL Granjero es el único que puede conducir la balsa y sólo puede llevar a un pasajero. 2. Si el lobo y la cabra están solos en la misma orilla, el lobo se la comerá. 3. Si la obeja y la col están solos en la misma orolla, la obeja sa la comerá'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  void stopTimer() {
    timer.cancel();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        time++;
      });
    });
  }

  List<Item> items1 = [
    Item(
        name: 'Item 1',
        image: Image.asset('assets/lobo.png'),
        previousColumn: 'items1'),
    Item(
        name: 'Item 2',
        image: Image.asset('assets/oveja.png'),
        previousColumn: 'items1'),
    Item(
        name: 'Item 3',
        image: Image.asset('assets/col.png'),
        previousColumn: 'items1'),
    Item(
        name: 'Item 4',
        image: Image.asset('assets/granjero.png'),
        previousColumn: 'items1'),
  ];
  List<Item> items2 = [];
  List<Item> items3 = [];
  String titleM = "";
  String message = "";
  int count = 0;

  void moveItem() {
    if (shouldShowDangerDialog()) {
      showDangerDialog();
      return;
    }
    if (items2.isNotEmpty) {
      moveItems();
      count += 1;
      if (items3.length == 4) {
        stopTimer();
        titleM = "!Felizidades " + nombre + " has ganado!";
        message = "Ganaste con " + count.toString() + " Movimientos";
        showDangerDialog2();
      }
    } else {
      showImpossibleDialog();
    }
  }

  bool shouldShowDangerDialog() {
    if (!(items2.any((item) => item.name == 'Item 4'))) {
      titleM = "No es posible";
      message = "El granjero debería conducir la balsa";
      return true;
    }
    if ((items1.any((i) => i.name == 'Item 3') &&
            items1.any((i) => i.name == 'Item 2')) ||
        (items3.any((i) => i.name == 'Item 3') &&
            items3.any((i) => i.name == 'Item 2'))) {
      titleM = "Peligro";
      message = "La obeja se comerá la col";
      return true;
    }
    if ((items1.any((i) => i.name == 'Item 1') &&
            items1.any((i) => i.name == 'Item 2')) ||
        (items3.any((i) => i.name == 'Item 1') &&
            items3.any((i) => i.name == 'Item 2'))) {
      titleM = "Peligro";
      message = "El lobo se comerá a la obeja";
      return true;
    }
    return false;
  }

  void showDangerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleM),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void showDangerDialog2() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleM),
          content: Text(message),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        time = 0;
                        startTimer();
                        items1.addAll(items3);
                        items3.clear();
                        count = 0;
                        items1.forEach((item) {
                          item.previousColumn = 'items1';
                        });
                        setState(() {});
                      },
                      child: Text('Reiniciar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context, [nombre, count, time]);
                      },
                      child: Text('Finalizar'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void restart() {
    setState(() {
      if (items2.isNotEmpty) {
        items1.addAll(items2);
        items2.clear();
      }
      if (items3.isNotEmpty) {
        items1.addAll(items3);
        items3.clear();
      }
      items1.forEach((item) {
        item.previousColumn = 'items1';
      });
      count = 0;
    });
  }

  void moveItems() {
    setState(() {
      items2.forEach((item) {
        if (item.previousColumn == 'items1') {
          item.previousColumn = 'items3';
          items3.add(item);
        } else if (item.previousColumn == 'items3') {
          item.previousColumn = 'items1';
          items1.add(item);
        }
      });
      items2.clear();
    });
  }

  void showImpossibleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("No es posible"),
          content: Text("El granjero debería conducir la balsa"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void addItem(String item, List<Item> fromList, List<Item> toList,
      int maxItems, String title) {
    if (title == "Otro Lado") {
      if (items3.any((ite) => ite.name == 'Item 4') ||
          items2.any((ite) =>
              ite.name == 'Item 4' && ite.previousColumn == 'items3')) {
        return;
      }
    } else if (title == "Casa") {
      if (items1.any((ite) => ite.name == 'Item 4') ||
          items2.any((ite) =>
              ite.name == 'Item 4' && ite.previousColumn == 'items1')) {
        return;
      }
    }
    setState(() {
      if (toList.length < maxItems) {
        Item itemToAdd = fromList.firstWhere((element) => element.name == item);
        toList.add(itemToAdd);
        fromList.removeWhere((element) => element.name == item);
      }
    });
  }

  Widget buildColumn(
      String title, List<Item> items, List<Item> toList, int maxItems) {
    if (title == "Rio") {
      items2.forEach((item) {
        if (item.previousColumn == "items1") {
          toList = items1;
        } else if (item.previousColumn == "items3") {
          toList = items3;
        }
      });
    }
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 300,
            height: 50,
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 1,
            children: items.map((item) {
              return GestureDetector(
                onTap: () => addItem(item.name, items, toList, maxItems, title),
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  child: item.image,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
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

  void pista() {
    titleM = "Ver aununcio por ayuda";
    message = "¿Quieres ver un anuncio para obtener un ayuda?";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleM),
          content: Text(message),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('No ver'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        String videoUrl = "http://localhost:3000/video";
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoPlayerWidget(videoUrl: videoUrl),
                          ),
                        );
                        if (result == true) {
                          titleM = "Solución";
                          message =
                              "1.Granjero con la objera  2.Granjero (volver) 3. Granjero con lobo (crusar) 4. Granjero con obeja (volver) 5. Granjero con col (Cruzar) 6. Granjero (volver) 7. Granjero con obeja (cruzar)";
                          showDangerDialog();
                          anuncioV = true;
                        } else {
                          titleM = "No se vió el anuncio";
                          message = "No se obtuvo la pista";
                          showDangerDialog();
                        }
                      },
                      child: Text('Ver'),
                    ),
                  ],
                ),
              ],
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
        title: Row(
          children: [
            Text('Crusar el rio'),
            SizedBox(width: 24.0),
            Text(
              'Tiempo: $time segundos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Rio.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          children: [
            buildColumn('Otro Lado', items1, items2, 2),
            buildColumn('Rio', items2, items1, 4),
            buildColumn('Casa', items3, items2, 2),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'unique_tag',
            onPressed: moveItem,
            child: Text('Move'),
          ),
          SizedBox(width: 16.0),
          FloatingActionButton(
            heroTag: 'unique_tag1',
            onPressed: restart,
            child: Icon(Icons.refresh),
          ),
          SizedBox(width: 16.0),
          FloatingActionButton(
            heroTag: 'unique_tag11',
            onPressed: salir,
            child: Icon(Icons.arrow_back),
          ),
          SizedBox(width: 16.0),
          FloatingActionButton(
            heroTag: 'unique_tag0',
            onPressed: () {
              if (anuncioV == false) {
                pista();
              } else {
                titleM = "Solución";
                message =
                    "1.Granjero con la objera  2.Granjero (volver) 3. Granjero con lobo (crusar) 4. Granjero con obeja (volver) 5. Granjero con col (Cruzar) 6. Granjero (volver) 7. Granjero con obeja (cruzar)";
                showDangerDialog();
              }
            },
            child: Icon(Icons.lightbulb),
          ),
        ],
      ),
    );
  }
}
