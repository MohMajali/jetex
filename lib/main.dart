import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jettaexstores/BottomBarScreen/NotifictionScreen.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Screens/AddProdcutScreen.dart';
import 'package:jettaexstores/Screens/EditProductDetials.dart';
import 'package:jettaexstores/Screens/LoginScreen.dart';
import 'package:jettaexstores/Screens/ProdcutDitalScreen.dart';
import 'package:jettaexstores/Screens/SplashScreen.dart';
import 'package:jettaexstores/Screens/SubCategory.dart';
import 'package:jettaexstores/Widget/NavBar.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/homepage.dart';
import 'package:flutter/widgets.dart';
import 'BottomBarScreen/SettingScreen.dart';
import 'Screens/InfoScreen.dart';
import 'Screens/OrderScreen.dart';
import 'Screens/CategoryScreen.dart';
import 'Screens/RevewisScreen.dart';
import 'Provider/Localapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

SharedPreferences sharedPreferences;
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  sharedPreferences = await SharedPreferences.getInstance();

  var email = sharedPreferences.getString('e');
  var pass = sharedPreferences.getString('p');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocal(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;

  setLocal(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  var lang = sharedPreferences.getString("lang");

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      localizationsDelegates: [
        AppLocale.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en", ""),
        Locale("ar", ""),
      ],
      localeResolutionCallback: (currentLang, supportLang) {
        if (currentLang != null) {
          for (Locale local in supportLang) {
            if (local.languageCode == currentLang.languageCode) {
              sharedPreferences.setString("lang", currentLang.languageCode);
              return currentLang;
            }
          }
        }
        return supportLang.first;
      },
      locale: _locale,
      theme: ThemeData(
          focusColor: SecondryColor,
          primaryColor: Color(0xffedb54f),
          canvasColor: PrimaryColor,
          buttonColor: Color(0xffedb54f),
          iconTheme: IconThemeData(color: Color(0xffedb54f))),
      debugShowCheckedModeBanner: false,
      initialRoute: null == sharedPreferences.getBool("Remember") ||
              false == sharedPreferences.getBool("Remember")
          ? 'LoginScreen'
          : 'directLogin',
      routes: {
        'EditProduct': (context) => EditProduct(),
        // 'Api_test': (context) => Api_test(),
        'LoginScreen': (context) => LoginScreen(),
        'directLogin': (context) => Home(),
        'Home': (context) => Home(),
        'SettingScreen': (context) => SetteingScreen(),
        'NoteficationScreen': (context) => NoteficationScreen(),
        'SpalshScreen': (context) => SpalshScreen(),
        'HomePage': (context) => HomePage(),
        'InfoScreen': (context) => InfoScreen(),
        'OrderScreen': (context) => OrderScreen(),
        'ProdcutScreen': (context) => ProdcutScreen(),
        'RevewiesScreen': (context) => RevewiesScreen(),
        'AddProdcut': (context) => AddProdcut(),
        'SubCategory': (context) => SubCategory(),
        'ProscutDitalScreen': (context) => ProscutDitalScreen(),
      },
    );
  }
}
