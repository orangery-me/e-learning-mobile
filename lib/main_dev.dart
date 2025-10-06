import 'package:e_learning_mobile/app/app.dart';
import 'package:e_learning_mobile/bootstrap.dart';
import 'package:e_learning_mobile/flavors.dart';
Future<void> main() async {
  await bootstrap(
    () {
      return const App();
    },
    Flavor.DEV,
  );
}
