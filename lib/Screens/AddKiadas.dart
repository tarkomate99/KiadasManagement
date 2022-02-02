import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_crud/Blocs/text_provider.dart';
import 'package:hive_crud/Models/Kiadasok.dart';
import 'package:hive/hive.dart';
import 'package:hive_crud/Models/take_nyugta_picture.dart';
import 'package:hive_crud/Screens/ContactList.dart';
import 'package:hive_crud/Screens/KiadasokList.dart';
import 'package:hive_crud/Screens/Map.dart';
import 'package:hive_crud/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AddOrUpdateKiadas extends StatefulWidget {
  bool isEdit;
  int position = -1;
  Kiadasok? kiadasokModel = null;

  AddOrUpdateKiadas(this.isEdit, this.position, this.kiadasokModel);

  @override
  State<StatefulWidget> createState() {
    return AddOrUpdateKiadasState();
  }
}

class AddOrUpdateKiadasState extends State<AddOrUpdateKiadas> {
  TextEditingController controllerDate = new TextEditingController();
  TextEditingController controllerPlace = new TextEditingController();
  TextEditingController controllerPrice = new TextEditingController();
  TextEditingController controllerKivel = new TextEditingController();
  TextEditingController controllerImagepath = new TextEditingController();

  File? image;

  TextEditingController dateCtl = TextEditingController();
  late DateTime date;
  var formatter = new DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    initImage();
  }

  Future<void> initImage() async {
    final path = join(
      (await getApplicationDocumentsDirectory()).path,
      'nyugtaPicture.png',
    );

    final file = File(path);
    if (file.existsSync()) {
      setState(() {
        image = file;
      });
    }
  }

  void setImage(File newImage) {
    setState(() {
      image = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text_provider = Provider.of<TextProvider>(context);
    String place = text_provider.setText();
    String name = text_provider.setName();
    if (widget.isEdit) {
      dateCtl.text = widget.kiadasokModel!.date;
      controllerPlace.text = widget.kiadasokModel!.place;
      controllerPrice.text = widget.kiadasokModel!.price;
      controllerKivel.text = widget.kiadasokModel!.kivel;
      controllerImagepath.text = widget.kiadasokModel!.image_path;
    } else {
      controllerPlace.text = place;
      controllerKivel.text = name;
    }
    DateTime selectDate = DateTime.now();
    final camera = Provider.of<CameraDescription>(context);
    String path = text_provider.setPath();

    _selectDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2025),
      );
      if (selected != null && selected != selectDate) {
        setState(() {
          selectDate = selected;
        });
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
                '${widget.isEdit == true ? AppLocalizations.of(context)!.modify : AppLocalizations.of(context)!.add}')),
        body: SingleChildScrollView(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 768) {
                return Container(
                  margin: EdgeInsets.all(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: [
                          Text('${AppLocalizations.of(context)!.date}:',
                              style: TextStyle(fontSize: 15)),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                              height: 35,
                              width: 250,
                              child: Container(
                                child: TextFormField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0))),
                                    textAlign: TextAlign.center,
                                    controller: dateCtl,
                                    onTap: () async {
                                      date = (await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now()
                                              .subtract(Duration(days: 2)),
                                          lastDate: DateTime.now()
                                              .add(Duration(days: 2))))!;
                                      if (date == null) {
                                        date = DateTime.now();
                                      } else {
                                        dateCtl.text = formatter.format(date);
                                      }
                                    }),
                              )),
                        ],
                      ),
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("${AppLocalizations.of(context)!.place}:",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(width: 20),
                          Expanded(
                              child: SizedBox(
                            height: 35,
                            width: 250,
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              controller: controllerPlace,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Google_Map()));
                              },
                            ),
                          ))
                        ],
                      ),
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("${AppLocalizations.of(context)!.expenditure}:",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(width: 20),
                          Expanded(
                              child: SizedBox(
                            height: 35,
                            width: 250,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              key: Key("expenditure"),
                              controller: controllerPrice,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                            ),
                          ))
                        ],
                      ),
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("${AppLocalizations.of(context)!.withwho}:",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(width: 20),
                          Expanded(
                              child: SizedBox(
                            height: 35,
                            width: 250,
                            child: TextFormField(
                              readOnly: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              controller: controllerKivel,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ContactList()));
                              },
                            ),
                          )),
                        ],
                      ),
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("${AppLocalizations.of(context)!.receipt}:",
                              style: TextStyle(fontSize: 18)),
                          SizedBox(width: 20),
                          RaisedButton(
                            child:
                                Text("${AppLocalizations.of(context)!.camera}"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          TakeNyugtaPicture(camera: camera)));
                            },
                          ),
                        ],
                      ),
                      Text(
                        "$path${controllerImagepath.text}",
                        key: Key("imgpath"),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Stack(
                        children: <Widget>[
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                color: Colors.white,
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.white,
                                    backgroundImage: image?.existsSync() == true
                                        ? Image.memory(
                                            image!.readAsBytesSync(),
                                            fit: BoxFit.fill,
                                          ).image
                                        : null,
                                    child: image?.existsSync() != true
                                        ? Icon(
                                            Icons.account_circle_outlined,
                                            size: 100,
                                            color: Colors.black,
                                          )
                                        : null),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      MaterialButton(
                        key: Key("addButton"),
                        color: Colors.deepOrange,
                        child: Text(
                          "${AppLocalizations.of(context)!.upload}",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        onPressed: () async {
                          var getDate = dateCtl.text;
                          var getPlace = controllerPlace.text;
                          var getPrice = controllerPrice.text;
                          var getKivel = controllerKivel.text;
                          var getImagePath = controllerImagepath.text;
                          var total = int.parse(getPrice);

                          if (getDate.isNotEmpty &
                              getPlace.isNotEmpty &
                              getPrice.isNotEmpty &
                              getKivel.isNotEmpty) {
                            Kiadasok kiadasokdata = new Kiadasok(
                                date: getDate,
                                place: getPlace,
                                price: getPrice,
                                kivel: getKivel,
                                image_path: getImagePath);
                            if (widget.isEdit) {
                              var box =
                                  await Hive.openBox<Kiadasok>('kiadasok');
                              box.putAt(widget.position, kiadasokdata);
                            } else {
                              var box =
                                  await Hive.openBox<Kiadasok>('kiadasok');
                              box.add(kiadasokdata);
                              text_provider.getTotal(total);
                            }
                            text_provider.getPath('');
                            text_provider.getText('');
                            text_provider.getName('');
                            image = null;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => KiadasokListScreen()));
                          }
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.all(25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: [
                            Text('${AppLocalizations.of(context)!.date}:',
                                style: TextStyle(fontSize: 15)),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                height: 35,
                                width: 250,
                                child: Container(
                                  child: TextFormField(
                                      textAlign: TextAlign.center,
                                      controller: dateCtl,
                                      onTap: () async {
                                        date = (await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now()
                                                .subtract(Duration(days: 2)),
                                            lastDate: DateTime.now()
                                                .add(Duration(days: 2))))!;
                                        if (date == null) {
                                          date = DateTime.now();
                                        } else {
                                          dateCtl.text = formatter.format(date);
                                        }
                                      }),
                                )),
                          ],
                        ),
                        SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "${AppLocalizations.of(context)!.place}:${controllerPlace.text}",
                                style: TextStyle(fontSize: 18)),
                            SizedBox(width: 20),
                            Expanded(child: Text("$place"))
                          ],
                        ),
                        RaisedButton(
                            child: Text("Google Map"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Google_Map()));
                            }),
                        SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "${AppLocalizations.of(context)!.expenditure}:",
                                style: TextStyle(fontSize: 18)),
                            SizedBox(width: 20),
                            Expanded(
                                child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              controller: controllerPrice,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                            ))
                          ],
                        ),
                        SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "${AppLocalizations.of(context)!.withwho}:${controllerKivel.text}",
                                style: TextStyle(fontSize: 18)),
                            SizedBox(width: 20),
                            Expanded(child: Text("$name")),
                          ],
                        ),
                        RaisedButton(
                          child: Text(
                              "${AppLocalizations.of(context)!.contactlist}"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactList()));
                          },
                        ),
                        SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("${AppLocalizations.of(context)!.receipt}:",
                                style: TextStyle(fontSize: 18)),
                            SizedBox(width: 20),
                            RaisedButton(
                              child: Text(
                                  "${AppLocalizations.of(context)!.camera}"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            TakeNyugtaPicture(camera: camera)));
                              },
                            ),
                          ],
                        ),
                        Text("$path${controllerImagepath.text}"),
                        SizedBox(
                          height: 60,
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(150),
                                color: Colors.white,
                              ),
                              child: GestureDetector(
                                onTap: () {},
                                child: CircleAvatar(
                                    radius: 70,
                                    backgroundColor: Colors.white,
                                    backgroundImage: image?.existsSync() == true
                                        ? Image.memory(
                                            image!.readAsBytesSync(),
                                            fit: BoxFit.fill,
                                          ).image
                                        : null,
                                    child: image?.existsSync() != true
                                        ? Icon(
                                            Icons.account_circle_outlined,
                                            size: 100,
                                            color: Colors.black,
                                          )
                                        : null),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 100,
                        ),
                        MaterialButton(
                          color: Colors.deepOrange,
                          child: Text(
                            "${AppLocalizations.of(context)!.upload}",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          onPressed: () async {
                            var getDate = dateCtl.text;
                            var getPlace = text_provider.setText();
                            var getPrice = controllerPrice.text;
                            var getKivel = name;
                            var getImagePath = text_provider.setPath();

                            if (getDate.isNotEmpty &
                                getPlace.isNotEmpty &
                                getPrice.isNotEmpty &
                                getKivel.isNotEmpty) {
                              Kiadasok kiadasokdata = new Kiadasok(
                                  date: getDate,
                                  place: getPlace,
                                  price: getPrice,
                                  kivel: getKivel,
                                  image_path: getImagePath);
                              if (widget.isEdit) {
                                var box =
                                    await Hive.openBox<Kiadasok>('kiadasok');
                                box.putAt(widget.position, kiadasokdata);
                              } else {
                                var box =
                                    await Hive.openBox<Kiadasok>('kiadasok');
                                box.add(kiadasokdata);
                              }
                              text_provider.getPath('');
                              text_provider.getText('');
                              text_provider.getName('');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => KiadasokListScreen()));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
