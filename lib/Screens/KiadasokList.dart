import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_crud/Screens/AddKiadas.dart';
import 'package:hive_crud/Models/Kiadasok.dart';
import 'package:hive/hive.dart';
import 'package:hive_crud/l10n/app_localizations.dart';
import 'package:hive_crud/main.dart';
import 'package:path_provider/path_provider.dart';

class KiadasokListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return KiadasokListScreenState();
  }
}

class KiadasokListScreenState extends State<KiadasokListScreen> with TickerProviderStateMixin{
  List<Kiadasok> listKiadasok = [];
  late String imgurl;

  void getKiadasok() async {
    final box = await Hive.openBox<Kiadasok>('kiadasok');
    setState(() {
      listKiadasok = box.values.toList();
    });
  }

  Future<String> get _localPath async{
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  @override
  void initState() {
    getKiadasok();
    super.initState();
  }

  late final AnimationController _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn
  );

  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {

    _localPath.then((String result){
      setState(() {
        imgurl=result;
      });
    });

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
                  return ListTile(
                    title: Text("${getKiadas.price} Ft"),
                    subtitle: Text("${getKiadas.date}"),
                    onTap: () async{
                      showModalBottomSheet(
                          context: context,
                          elevation: 5,
                          isScrollControlled: true,
                          builder: (_) => Container(
                            padding: EdgeInsets.only(
                              top: 15,
                              left: 15,
                              right: 15,
                              bottom: MediaQuery.of(context).viewInsets.bottom+120,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${AppLocalizations.of(context)!.expenditure}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                SizedBox(height: 20,),
                                Text("${AppLocalizations.of(context)!.date}: ${getKiadas.date}"),
                                SizedBox(height: 10,),
                                Text("${AppLocalizations.of(context)!.place}: ${getKiadas.place}"),
                                SizedBox(height: 10,),
                                Text("${AppLocalizations.of(context)!.expenditure}: ${getKiadas.price} Ft"),
                                SizedBox(height: 10,),
                                Text("${AppLocalizations.of(context)!.withwho}: ${getKiadas.kivel}"),
                                SizedBox(height: 10,),
                              ],
                            ),
                          )
                      );
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
                                setState(() {
                                  listKiadasok.removeAt(position);
                                });
                              },
                              icon: Icon(Icons.delete)),
                        ],
                      ),
                    ),
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
