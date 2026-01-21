import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'provider/addsytleprovider.dart';
import 'provider/menuprovidercategory.dart';
import 'provider/provider.dart';
import 'ui/trade/trade_landing_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuCategoryProvider()),
        ChangeNotifierProvider(create: (_) => MenuItemProvider()),
        ChangeNotifierProvider(create: (_) => ItemStyleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      debugShowCheckedModeBanner: false,
      home: POSLandingPage(),
    );
  }
}
