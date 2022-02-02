import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_crud/Models/Velemenyek.dart';
import 'package:hive_crud/l10n/app_localizations.dart';

class VelemenyekList extends StatefulWidget {
  const VelemenyekList({Key? key}) : super(key: key);

  @override
  _VelemenyekListState createState() => _VelemenyekListState();
}

class _VelemenyekListState extends State<VelemenyekList> {
  List<Velemenyek> listVelemenyek = [];
  TextEditingController controllerOpinion = new TextEditingController();

  void getVelemenyek() async {
    final box = await Hive.openBox<Velemenyek>('opinions');
    setState(() {
      listVelemenyek = box.values.toList();
    });
  }

  @override
  void initState() {
    getVelemenyek();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context)!.opinions} List'),
      ),
      body: ListView.builder(
        itemCount: listVelemenyek.length,
        itemBuilder: (context, position) {
          Velemenyek getVelemeny = listVelemenyek[position];
          return ListTile(
            title: Text("${getVelemeny.velemeny}"),
            trailing: SizedBox(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: false,
                    child: IconButton(
                      icon: Icon(Icons.edit_attributes_outlined),
                      onPressed: () {
                        controllerOpinion.text = getVelemeny.velemeny;
                        showModalBottomSheet(
                            context: context,
                            elevation: 5,
                            builder: (_) => Container(
                                  padding: EdgeInsets.only(
                                    top: 15,
                                    left: 15,
                                    right: 15,
                                    bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom +
                                        220,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          "${AppLocalizations.of(context)!.youropinion}"),
                                      SizedBox(
                                        height: 35,
                                        width: 250,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0))),
                                          controller: controllerOpinion,
                                        ),
                                      ),
                                      RaisedButton(
                                        onPressed: () async {
                                          var getVelemeny =
                                              controllerOpinion.text;
                                          Velemenyek velemenydata =
                                              new Velemenyek(
                                                  velemeny: getVelemeny);
                                          var box =
                                              await Hive.openBox<Velemenyek>(
                                                  'opinions');
                                          box.putAt(0, velemenydata);
                                          controllerOpinion.text = '';
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            '${AppLocalizations.of(context)!.send}'),
                                      ),
                                    ],
                                  ),
                                ));
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      var box = Hive.box<Velemenyek>('opinions');
                      box.delete(position);
                      setState(() {
                        listVelemenyek.removeAt(position);
                      });
                    },
                    icon: Icon(Icons.delete_forever),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
