import 'package:coconut_chronicles/core/storage/preferences_model.dart';
import 'package:coconut_chronicles/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var sharedPreferences = await SharedPreferences.getInstance();

  runApp(ScopedModel<PreferencesModel>(
    model: PreferencesModel(sharedPreferences),
    child: const CoreApp(),
  ));
}

class CoreApp extends StatelessWidget {
  const CoreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return ScopedModelDescendant<PreferencesModel>(
        builder: (context, child, model) => MaterialApp(
              title: 'Coconut Chronicles',
              theme: ThemeData(
                useMaterial3: true,
                colorSchemeSeed: Colors.blue,
              ),
              debugShowCheckedModeBanner: false,
              home: const HomePage(),
            ));
  }
}