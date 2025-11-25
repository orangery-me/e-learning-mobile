import 'dart:async';

import 'package:e_learning_mobile/app/app_bloc_observer.dart';
import 'package:e_learning_mobile/common/helpers/firebase_messaging_service.dart';
import 'package:e_learning_mobile/common/helpers/local_notification_service.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/flavors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

typedef BootstrapBuilder = FutureOr<Widget> Function();

Future<void> bootstrap(BootstrapBuilder builder, Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  AppFlavor.appFlavor = flavor;

  await initializeApp();

  runApp(
    await builder(),
  );
}

Future<void> initializeApp() async {
  await Hive.initFlutter();

  await Future.wait([
    EasyLocalization.ensureInitialized(),
    configureDependencies(),
    //  AdsConfig.instance.init(); // Uncomment this line to enable ads
    Firebase.initializeApp(options: AppFlavor.firebaseOptions),
  ]);
  EasyLocalization.logger.enableBuildModes = [];
  // setUpDependencies();

  await LocalNotificationService.init();
  await FirebaseMessagingService.init();

  Bloc.observer = AppBlocObserver();
}
