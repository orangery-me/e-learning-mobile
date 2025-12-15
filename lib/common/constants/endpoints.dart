import 'package:e_learning_mobile/flavors.dart';

abstract class Endpoints {
  static String apiUrl = '${AppFlavor.apiBaseUrl}/v1';

  // auth api
  static String login = '$apiUrl/oauth/token';
  static String logout = '$apiUrl/oauth/revoke';

  // user api
  static String getUser = '$apiUrl/user';

  // course api
  static String courses = '$apiUrl/courses';
  static String coursesListByIds = '$apiUrl/courses/list-ids';

  // section api
  static String sections = '$apiUrl/sections';

  // lecture api
  static String lectures = '$apiUrl/lectures';

  // note api
  static String notes = '$apiUrl/notes';

  // events apit
  static String videoEvents = '$apiUrl/events';

  // code exercise api
  static String codeExercises = '$apiUrl/code-exercises';

  // review api
  static String reviews = '$apiUrl/reviews';

  // cart api
  static String cart = '$apiUrl/cart';

  // orders api
  static String orders = '$apiUrl/orders';

  // payments api
  static String payments = '$apiUrl/payments';

  // enrollments api
  static String enrollments = '$apiUrl/enrollments';

  // quizz api
  static String quizzes = '$apiUrl/quizzes';

  // quizz-submission
  static String quizzSubmissions = '$apiUrl/quiz-submissions';

  // career plans api
  static String careerPlans = '$apiUrl/career-plans/me';
}
