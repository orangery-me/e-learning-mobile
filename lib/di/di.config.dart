// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:e_learning_mobile/common/helpers/dio_helper.dart' as _i896;
import 'package:e_learning_mobile/common/services/websocket_service.dart'
    as _i322;
import 'package:e_learning_mobile/data/datasources/cart/cart_datasource.dart'
    as _i24;
import 'package:e_learning_mobile/data/datasources/cart/remote/cart_remote_datasource.dart'
    as _i927;
import 'package:e_learning_mobile/data/datasources/chat/chat_datasource.dart'
    as _i944;
import 'package:e_learning_mobile/data/datasources/code_exercise/code_exercise_datasource.dart'
    as _i1004;
import 'package:e_learning_mobile/data/datasources/code_exercise/remote/code_exercise_remote_datasource.dart'
    as _i899;
import 'package:e_learning_mobile/data/datasources/course/course_datasource.dart'
    as _i201;
import 'package:e_learning_mobile/data/datasources/course/remote/course_datasource.dart'
    as _i759;
import 'package:e_learning_mobile/data/datasources/enrollment/enrollment_datasource.dart'
    as _i598;
import 'package:e_learning_mobile/data/datasources/enrollment/remote/enrollment_remote_datasource.dart'
    as _i87;
import 'package:e_learning_mobile/data/datasources/lecture/lecture_datasource.dart'
    as _i895;
import 'package:e_learning_mobile/data/datasources/lecture/remote/lecture_datasource.dart'
    as _i789;
import 'package:e_learning_mobile/data/datasources/note/note_datasource.dart'
    as _i84;
import 'package:e_learning_mobile/data/datasources/note/remote/note_remote_datasource.dart'
    as _i277;
import 'package:e_learning_mobile/data/datasources/order/order_datasource.dart'
    as _i637;
import 'package:e_learning_mobile/data/datasources/order/remote/order_remote_datasource.dart'
    as _i221;
import 'package:e_learning_mobile/data/datasources/payment/payment_datasource.dart'
    as _i206;
import 'package:e_learning_mobile/data/datasources/payment/remote/payment_remote_datasource.dart'
    as _i698;
import 'package:e_learning_mobile/data/datasources/quizz/quizz_datasource.dart'
    as _i576;
import 'package:e_learning_mobile/data/datasources/quizz/remote/quizz_remote_datasource.dart'
    as _i801;
import 'package:e_learning_mobile/data/datasources/review/remote/review_remote_datasource.dart'
    as _i827;
import 'package:e_learning_mobile/data/datasources/review/review_datasource.dart'
    as _i560;
import 'package:e_learning_mobile/data/datasources/section/remote/section_datasource.dart'
    as _i629;
import 'package:e_learning_mobile/data/datasources/section/section_datasource.dart'
    as _i439;
import 'package:e_learning_mobile/data/datasources/user/local/user_datasource.dart'
    as _i591;
import 'package:e_learning_mobile/data/datasources/user/remote/user_datasource.dart'
    as _i812;
import 'package:e_learning_mobile/data/datasources/user/user_datasource.dart'
    as _i1056;
import 'package:e_learning_mobile/data/datasources/video_events/remote/video_events_remote_datasource.dart'
    as _i184;
import 'package:e_learning_mobile/data/datasources/video_events/video_events_datasource.dart'
    as _i734;
import 'package:e_learning_mobile/data/repositories/user_repository.dart'
    as _i979;
import 'package:e_learning_mobile/di/modules/local_module.dart' as _i414;
import 'package:e_learning_mobile/di/modules/network_module.dart' as _i220;
import 'package:e_learning_mobile/di/providers/dio_provider.dart' as _i958;
import 'package:e_learning_mobile/presentation/home/bloc/chat/chat_bloc.dart'
    as _i673;
import 'package:e_learning_mobile/presentation/home/bloc/home/home_bloc.dart'
    as _i597;
import 'package:e_learning_mobile/presentation/learn/bloc/code_exercise/code_exercise_bloc.dart'
    as _i280;
import 'package:e_learning_mobile/presentation/learn/bloc/courses/courses_bloc.dart'
    as _i148;
import 'package:e_learning_mobile/presentation/learn/bloc/enrollment/enrollment_bloc.dart'
    as _i741;
import 'package:e_learning_mobile/presentation/learn/bloc/lectures/lectures_bloc.dart'
    as _i770;
import 'package:e_learning_mobile/presentation/learn/bloc/notes/notes_bloc.dart'
    as _i171;
import 'package:e_learning_mobile/presentation/learn/bloc/progress/progress_bloc.dart'
    as _i905;
import 'package:e_learning_mobile/presentation/learn/bloc/quizz/quizz_bloc.dart'
    as _i914;
import 'package:e_learning_mobile/presentation/learn/bloc/reviews/reviews_bloc.dart'
    as _i275;
import 'package:e_learning_mobile/presentation/learn/bloc/sections/sections_bloc.dart'
    as _i399;
import 'package:e_learning_mobile/presentation/learn/bloc/video_play/video_play_bloc.dart'
    as _i902;
import 'package:e_learning_mobile/presentation/payment/bloc/cart/cart_bloc.dart'
    as _i78;
import 'package:e_learning_mobile/presentation/payment/bloc/order/order_bloc.dart'
    as _i470;
import 'package:e_learning_mobile/presentation/payment/bloc/payment/payment_bloc.dart'
    as _i1038;
import 'package:e_learning_mobile/presentation/payment/bloc/payment_notification/payment_notification_bloc.dart'
    as _i222;
import 'package:flutter/cupertino.dart' as _i719;
import 'package:flutter/material.dart' as _i409;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final localModule = _$LocalModule();
  final networkModule = _$NetworkModule();
  gh.factory<_i905.ProgressBloc>(() => _i905.ProgressBloc());
  gh.lazySingleton<_i719.GlobalKey<_i719.NavigatorState>>(
      () => localModule.navigatorKey);
  await gh.singletonAsync<_i986.Box<dynamic>>(
    () => localModule.authBox,
    instanceName: 'auth_box',
    preResolve: true,
  );
  gh.lazySingleton<_i322.WebSocketService>(() =>
      _i322.WebSocketService(gh<_i979.Box<dynamic>>(instanceName: 'auth_box')));
  gh.factory<_i222.PaymentNotificationBloc>(() => _i222.PaymentNotificationBloc(
      webSocketService: gh<_i322.WebSocketService>()));
  gh.lazySingleton<_i591.UserLocalDataSource>(() => _i591.UserLocalDataSource(
      authBox: gh<_i979.Box<dynamic>>(instanceName: 'auth_box')));
  gh.lazySingleton<_i958.DioProvider>(() => _i958.DioProvider(
        gh<_i979.Box<dynamic>>(instanceName: 'auth_box'),
        gh<_i409.GlobalKey<_i409.NavigatorState>>(),
      ));
  gh.lazySingleton<_i896.DioHelper>(
      () => networkModule.provideDioHelper(gh<_i958.DioProvider>()));
  gh.singleton<_i184.VideoEventsRemoteDatasource>(() =>
      _i184.VideoEventsRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i789.LectureRemoteDatasource>(
      () => _i789.LectureRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i221.OrderRemoteDatasource>(
      () => _i221.OrderRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i277.NoteRemoteDatasource>(
      () => _i277.NoteRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i759.CourseRemoteDatasource>(
      () => _i759.CourseRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i629.SectionRemoteDatasource>(
      () => _i629.SectionRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i801.QuizzRemoteDatasource>(
      () => _i801.QuizzRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i944.ChatDatasource>(
      () => _i944.ChatDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i87.EnrollmentRemoteDatasource>(
      () => _i87.EnrollmentRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i698.PaymentRemoteDatasource>(
      () => _i698.PaymentRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i812.UserRemoteDataSource>(
      () => _i812.UserRemoteDataSource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i899.CodeExerciseRemoteDatasource>(() =>
      _i899.CodeExerciseRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i827.ReviewRemoteDatasource>(
      () => _i827.ReviewRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i927.CartRemoteDatasource>(
      () => _i927.CartRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i84.NoteDatasource>(
      () => _i84.NoteDatasource(remote: gh<_i277.NoteRemoteDatasource>()));
  gh.lazySingleton<_i576.QuizzDatasource>(() => _i576.QuizzDatasource(
      remoteDatasource: gh<_i801.QuizzRemoteDatasource>()));
  gh.lazySingleton<_i1056.UserDataSource>(() => _i1056.UserDataSource(
        remoteDataSource: gh<_i812.UserRemoteDataSource>(),
        localDataSource: gh<_i591.UserLocalDataSource>(),
      ));
  gh.singleton<_i734.VideoEventsDatasource>(() => _i734.VideoEventsDatasource(
      remoteDatasource: gh<_i184.VideoEventsRemoteDatasource>()));
  gh.factory<_i914.QuizzBloc>(
      () => _i914.QuizzBloc(datasource: gh<_i576.QuizzDatasource>()));
  gh.lazySingleton<_i24.CartDatasource>(
      () => _i24.CartDatasource(remote: gh<_i927.CartRemoteDatasource>()));
  gh.lazySingleton<_i201.CourseDatasource>(() => _i201.CourseDatasource(
      remoteDatasource: gh<_i759.CourseRemoteDatasource>()));
  gh.lazySingleton<_i560.ReviewDatasource>(
      () => _i560.ReviewDatasource(remote: gh<_i827.ReviewRemoteDatasource>()));
  gh.factory<_i148.CoursesBloc>(
      () => _i148.CoursesBloc(datasource: gh<_i201.CourseDatasource>()));
  gh.factory<_i275.ReviewsBloc>(
      () => _i275.ReviewsBloc(datasource: gh<_i560.ReviewDatasource>()));
  gh.lazySingleton<_i637.OrderDatasource>(
      () => _i637.OrderDatasource(remote: gh<_i221.OrderRemoteDatasource>()));
  gh.lazySingleton<_i439.SectionDatasource>(() => _i439.SectionDatasource(
      remoteDatasource: gh<_i629.SectionRemoteDatasource>()));
  gh.lazySingleton<_i1004.CodeExerciseDatasource>(() =>
      _i1004.CodeExerciseDatasource(
          remote: gh<_i899.CodeExerciseRemoteDatasource>()));
  gh.lazySingleton<_i206.PaymentDatasource>(() =>
      _i206.PaymentDatasource(remote: gh<_i698.PaymentRemoteDatasource>()));
  gh.lazySingleton<_i598.EnrollmentDatasource>(() => _i598.EnrollmentDatasource(
      remoteDatasource: gh<_i87.EnrollmentRemoteDatasource>()));
  gh.factory<_i902.VideoPlayBloc>(
      () => _i902.VideoPlayBloc(gh<_i734.VideoEventsDatasource>()));
  gh.lazySingleton<_i895.LectureDatasource>(() => _i895.LectureDatasource(
      remoteDatasource: gh<_i789.LectureRemoteDatasource>()));
  gh.factory<_i280.CodeExerciseBloc>(() => _i280.CodeExerciseBloc(
      codeExerciseDatasource: gh<_i1004.CodeExerciseDatasource>()));
  gh.lazySingleton<_i979.UserRepository>(
      () => _i979.UserRepository(dataSource: gh<_i1056.UserDataSource>()));
  gh.factory<_i741.EnrollmentBloc>(
      () => _i741.EnrollmentBloc(datasource: gh<_i598.EnrollmentDatasource>()));
  gh.factory<_i171.NotesBloc>(
      () => _i171.NotesBloc(datasource: gh<_i84.NoteDatasource>()));
  gh.factory<_i673.ChatBloc>(
      () => _i673.ChatBloc(chatDatasource: gh<_i944.ChatDatasource>()));
  gh.factory<_i399.SectionsBloc>(() => _i399.SectionsBloc(
        datasource: gh<_i439.SectionDatasource>(),
        lectureDatasource: gh<_i895.LectureDatasource>(),
      ));
  gh.factory<_i78.CartBloc>(
      () => _i78.CartBloc(cartDatasource: gh<_i24.CartDatasource>()));
  gh.factory<_i597.HomeBloc>(
      () => _i597.HomeBloc(courseDatasource: gh<_i201.CourseDatasource>()));
  gh.factory<_i770.LecturesBloc>(
      () => _i770.LecturesBloc(datasource: gh<_i895.LectureDatasource>()));
  gh.factory<_i1038.PaymentBloc>(() =>
      _i1038.PaymentBloc(paymentDatasource: gh<_i206.PaymentDatasource>()));
  gh.factory<_i470.OrderBloc>(
      () => _i470.OrderBloc(orderDatasource: gh<_i637.OrderDatasource>()));
  return getIt;
}

class _$LocalModule extends _i414.LocalModule {}

class _$NetworkModule extends _i220.NetworkModule {}
