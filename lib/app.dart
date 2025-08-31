import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:muhasaba/features/settings/settings_page.dart';
import 'core/theme.dart';
import 'features/home/home_page.dart';
import 'features/settings/settings_controller.dart';
import 'l10n/generated/app_localizations.dart';

class MuhasabaApp extends ConsumerWidget {
  const MuhasabaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'Muhasaba - Daily Action Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      routes: {'/settings': (context) => const SettingsPage()},
    );
  }
}
