import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_crud/Models/Velemenyek.dart';

class VelemenyekList extends StatefulWidget {
  const VelemenyekList({Key? key}) : super(key: key);

  @override
  _VelemenyekListState createState() => _VelemenyekListState();
}

class _VelemenyekListState extends State<VelemenyekList> {
  List<Velemenyek> listVelemenyek = [];

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
        title: Text('VelemenyekList'),
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
