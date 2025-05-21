import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plant_task/helper/provider/cropDiagnosisProvider.dart';
import 'package:plant_task/helper/provider/themeProvider.dart';
import 'package:plant_task/helper/provider/userLoginProvider.dart';
import 'package:plant_task/helper/styles/colorsRes.dart';
import 'package:plant_task/helper/utils/constant.dart';
import 'package:plant_task/helper/utils/routeGenerator.dart';
import 'package:plant_task/helper/utils/sessionManager.dart';
import 'package:plant_task/screens/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  prefs = await SharedPreferences.getInstance();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CropDiagnosisProvider>(
          create: (context) {
            return CropDiagnosisProvider();
          },
        ),
        ChangeNotifierProvider<UserLoginProvider>(
          create: (context) {
            return UserLoginProvider();
          },
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) {
            return ThemeProvider();
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SessionManager>(
      create: (_) => SessionManager(prefs: prefs),
      child: Consumer<SessionManager>(
        builder: (context, SessionManager sessionNotifier, child) {
          Constant.session = Provider.of<SessionManager>(
            context,
            listen: false,
          );
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              navigatorKey: Constant.navigatorKay,
              onGenerateRoute: RouteGenerator.generateRoute,
              initialRoute: "/",
              debugShowCheckedModeBanner: false,
              title: 'Plant Task',
              theme: ColorsRes.setAppTheme().copyWith(
                textTheme: GoogleFonts.latoTextTheme(
                  Theme.of(context).textTheme,
                ),
              ),
              home: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
