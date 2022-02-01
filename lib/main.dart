import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_crud/Blocs/application_block.dart';
import 'package:hive_crud/Blocs/locale_provider.dart';
import 'package:hive_crud/Blocs/text_provider.dart';
import 'package:hive_crud/Models/Kiadasok.dart';
import 'package:hive_crud/Models/Velemenyek.dart';
import 'package:hive_crud/Screens/AddKiadas.dart';
import 'package:hive_crud/Screens/KiadasokList.dart';
import 'package:hive_crud/Screens/VelemenyekList.dart';
import 'package:hive_crud/l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart' as pathProvide;
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'l10n/l10n.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Directory directory = await pathProvide.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(KiadasokAdapter());
  Hive.registerAdapter(VelemenyekAdapter());

  final cameras = await availableCameras();
  final camera = cameras.length > 0 ? cameras.first : null;

  runApp(MultiProvider(
    providers: [
      Provider.value(value: camera),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Applicationbloc>(
            create: (_) => Applicationbloc()),
        ChangeNotifierProvider<TextProvider>(create: (_) => TextProvider()),
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(),
        )
      ],
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Kiadás management app',
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: L10n.all,
            home: const HomePage());
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _HomePageState? state = context.findAncestorStateOfType<_HomePageState>();
    state?.changeLanguage(newLocale);
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late Locale _locale;
  TextEditingController controllerOpinion = new TextEditingController();

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 2), vsync: this)
        ..repeat(reverse: true);
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.easeIn);

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = Locale('hu');

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("${AppLocalizations.of(context)!.expenditure} App"),
        ),
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
              title: Text('${AppLocalizations.of(context)!.expenditures}'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => KiadasokListScreen()));
              },
            ),
            ListTile(
              title: Text('${AppLocalizations.of(context)!.opinions}'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => VelemenyekList()));
              },
            )
          ],
        ),
      ),
      body: Container(
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: FadeTransition(
                    opacity: _animation,
                    child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Image(
                          image: AssetImage('assets/image/money.png'),
                        ))),
              ),
              SizedBox(
                height: 40,
              ),
              Text('${AppLocalizations.of(context)!.welcome}'),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: EdgeInsets.all(15),
                  child: Text('${AppLocalizations.of(context)!.description}'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      onPressed: () {
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
                                          box.add(velemenydata);
                                          controllerOpinion.text = '';
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            '${AppLocalizations.of(context)!.send}'),
                                      )
                                    ],
                                  ),
                                ));
                      },
                      child:
                          Text('${AppLocalizations.of(context)!.addopinion}'),
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
