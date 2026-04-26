import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/theme/theme_cubit.dart';
import 'features/events/presentation/bloc/events_bloc.dart';
import 'features/events/presentation/bloc/events_event.dart';
import 'features/events/presentation/screens/home_screen.dart';
import 'features/events/presentation/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  runApp(const EventFinderApp());
}

class EventFinderApp extends StatelessWidget {
  const EventFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => getIt<EventsBloc>()..add(const FetchEvents()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Event Finder',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,

            // ── Light Theme ──
            theme: ThemeData(
              brightness: Brightness.light,
              colorSchemeSeed: const Color(0xFF1A1A2E),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFFF5F6FA),
              cardColor: Colors.white,
            ),

            // ── Dark Theme ──
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorSchemeSeed: const Color(0xFF1A1A2E),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFF0D0D1A),
              cardColor: const Color(0xFF1E1E2E),
            ),

            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}