import 'package:a5er_elshare3/core/utils/Constants/constants.dart';
import 'package:a5er_elshare3/features/Welcome/presentation/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/utils/Injections/dependency_injection.dart';
import 'features/GoogleMaps/Presentation/cubits/MapsCubit/maps_cubit.dart';
import 'features/Trip/data/Database/FirebaseTripStorage.dart';
import 'features/Trip/presentation/cubits/TripCubit/trip_cubit.dart';
import 'firebase_options.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding
      .ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const A5erElShare3());
}


class A5erElShare3 extends StatelessWidget {
  const A5erElShare3({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TripCubit(tripStorage: FirebaseTripStorage()),
        ),
        BlocProvider(
          create: (ctx1) => MapsCubit(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: kFontFamilyArchivo,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
