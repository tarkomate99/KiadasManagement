import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_crud/Blocs/text_provider.dart';
import 'package:hive_crud/Screens/AddKiadas.dart';
import 'package:hive_crud/Models/Kiadasok.dart';
import 'package:hive/hive.dart';
import 'package:hive_crud/l10n/app_localizations.dart';
import 'package:hive_crud/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'VelemenyekList.dart';

class KiadasokListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return KiadasokListScreenState();
  }
}

class KiadasokListScreenState extends State<KiadasokListScreen>
    with TickerProviderStateMixin {
  List<Kiadasok> listKiadasok = [];
  late String imgurl;

  void getKiadasok() async {
    final box = await Hive.openBox<Kiadasok>('kiadasok');
    setState(() {
      listKiadasok = box.values.toList();
    });
  }

  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  @override
  void initState() {
    getKiadasok();
    super.initState();
  }

  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 2), vsync: this)
        ..repeat(reverse: true);
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _localPath.then((String result) {
      setState(() {
        imgurl = result;
      });
    });
    final text_provider = Provider.of<TextProvider>(context);
    int total = text_provider.setTotal();
    TextEditingController controllerLimit = new TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('${AppLocalizations.of(context)!.explist}'),
          actions: <Widget>[
            ScaleTransition(
              scale: _animation,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddOrUpdateKiadas(false, -1, null)));
                },
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 90,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.orange),
                  child: Center(child: Text("Menu")),
                ),
              ),
              ListTile(
                title: Text('${AppLocalizations.of(context)!.home}'),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                },
              ),
              ListTile(
                title: Text('${AppLocalizations.of(context)!.opinions}'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => VelemenyekList()));
                },
              ),
              SizedBox(
                height: 430,
              ),
              Container(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: <Widget>[
                      Divider(),
                      ListTile(
                        title: Text(
                          '${AppLocalizations.of(context)!.edition}: $total ${AppLocalizations.of(context)!.currency}',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: AnimatedSize(
            vsync: this,
            duration: Duration(seconds: 100),
            child: Container(
              height: double.infinity,
              child: ListView.builder(
                itemCount: listKiadasok.length,
                itemBuilder: (context, position) {
                  Kiadasok getKiadas = listKiadasok[position];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                            "${getKiadas.price} ${AppLocalizations.of(context)!.currency}"),
                        subtitle: Text("${getKiadas.date}"),
                        onTap: () async {
                          showModalBottomSheet(
                              context: context,
                              elevation: 5,
                              isScrollControlled: true,
                              builder: (_) => Container(
                                    padding: EdgeInsets.only(
                                      top: 15,
                                      left: 15,
                                      right: 15,
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          120,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${AppLocalizations.of(context)!.expenditure}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                            "${AppLocalizations.of(context)!.date}: ${getKiadas.date}"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "${AppLocalizations.of(context)!.place}: ${getKiadas.place}"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "${AppLocalizations.of(context)!.expenditure}: ${getKiadas.price} Ft"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            "${AppLocalizations.of(context)!.withwho}: ${getKiadas.kivel}"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        trailing: SizedBox(
                          width: 150,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AddOrUpdateKiadas(
                                                true, position, getKiadas)));
                                  },
                                  icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {
                                    final box = Hive.box<Kiadasok>('kiadasok');
                                    box.delete(position);
                                    text_provider
                                        .minusTotal(int.parse(getKiadas.price));
                                    setState(() {
                                      listKiadasok.removeAt(position);
                                      total = text_provider.setTotal();
                                    });
                                  },
                                  icon: Icon(Icons.delete)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
