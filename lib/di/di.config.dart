// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:e_learning_mobile/common/helpers/dio_helper.dart' as _i896;
import 'package:e_learning_mobile/data/datasources/code_exercise/code_exercise_datasource.dart'
    as _i1004;
import 'package:e_learning_mobile/data/datasources/code_exercise/remote/code_exercise_remote_datasource.dart'
    as _i899;
import 'package:e_learning_mobile/data/datasources/course/course_datasource.dart'
    as _i201;
import 'package:e_learning_mobile/data/datasources/course/remote/course_datasource.dart'
    as _i759;
import 'package:e_learning_mobile/data/datasources/lecture/lecture_datasource.dart'
    as _i895;
import 'package:e_learning_mobile/data/datasources/lecture/remote/lecture_datasource.dart'
    as _i789;
import 'package:e_learning_mobile/data/datasources/note/note_datasource.dart'
    as _i84;
import 'package:e_learning_mobile/data/datasources/note/remote/note_remote_datasource.dart'
    as _i277;
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
import 'package:e_learning_mobile/presentation/home/bloc/home_bloc.dart'
    as _i375;
import 'package:e_learning_mobile/presentation/learn/bloc/code_exercise/code_exercise_bloc.dart'
    as _i280;
import 'package:e_learning_mobile/presentation/learn/bloc/courses/courses_bloc.dart'
    as _i148;
import 'package:e_learning_mobile/presentation/learn/bloc/lectures/lectures_bloc.dart'
    as _i770;
import 'package:e_learning_mobile/presentation/learn/bloc/notes/notes_bloc.dart'
    as _i171;
import 'package:e_learning_mobile/presentation/learn/bloc/sections/sections_bloc.dart'
    as _i399;
import 'package:e_learning_mobile/presentation/learn/bloc/video_play/video_play_bloc.dart'
    as _i902;
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
  gh.lazySingleton<_i719.GlobalKey<_i719.NavigatorState>>(
      () => localModule.navigatorKey);
  await gh.singletonAsync<_i986.Box<dynamic>>(
    () => localModule.authBox,
    instanceName: 'auth_box',
    preResolve: true,
  );
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
  gh.lazySingleton<_i277.NoteRemoteDatasource>(
      () => _i277.NoteRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i759.CourseRemoteDatasource>(
      () => _i759.CourseRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i629.SectionRemoteDatasource>(
      () => _i629.SectionRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i812.UserRemoteDataSource>(
      () => _i812.UserRemoteDataSource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i899.CodeExerciseRemoteDatasource>(() =>
      _i899.CodeExerciseRemoteDatasource(dioHelper: gh<_i896.DioHelper>()));
  gh.lazySingleton<_i84.NoteDatasource>(
      () => _i84.NoteDatasource(remote: gh<_i277.NoteRemoteDatasource>()));
  gh.lazySingleton<_i1056.UserDataSource>(() => _i1056.UserDataSource(
        remoteDataSource: gh<_i812.UserRemoteDataSource>(),
        localDataSource: gh<_i591.UserLocalDataSource>(),
      ));
  gh.singleton<_i734.VideoEventsDatasource>(() => _i734.VideoEventsDatasource(
      remoteDatasource: gh<_i184.VideoEventsRemoteDatasource>()));
  gh.lazySingleton<_i201.CourseDatasource>(() => _i201.CourseDatasource(
      remoteDatasource: gh<_i759.CourseRemoteDatasource>()));
  gh.factory<_i148.CoursesBloc>(
      () => _i148.CoursesBloc(datasource: gh<_i201.CourseDatasource>()));
  gh.lazySingleton<_i439.SectionDatasource>(() => _i439.SectionDatasource(
      remoteDatasource: gh<_i629.SectionRemoteDatasource>()));
  gh.lazySingleton<_i1004.CodeExerciseDatasource>(() =>
      _i1004.CodeExerciseDatasource(
          remote: gh<_i899.CodeExerciseRemoteDatasource>()));
  gh.lazySingleton<_i895.LectureDatasource>(() => _i895.LectureDatasource(
      remoteDatasource: gh<_i789.LectureRemoteDatasource>()));
  gh.factory<_i280.CodeExerciseBloc>(() => _i280.CodeExerciseBloc(
      codeExerciseDatasource: gh<_i1004.CodeExerciseDatasource>()));
  gh.lazySingleton<_i979.UserRepository>(
      () => _i979.UserRepository(dataSource: gh<_i1056.UserDataSource>()));
  gh.factory<_i171.NotesBloc>(
      () => _i171.NotesBloc(datasource: gh<_i84.NoteDatasource>()));
  gh.factory<_i399.SectionsBloc>(() => _i399.SectionsBloc(
        datasource: gh<_i439.SectionDatasource>(),
        lectureDatasource: gh<_i895.LectureDatasource>(),
      ));
  gh.factory<_i375.HomeBloc>(
      () => _i375.HomeBloc(courseDatasource: gh<_i201.CourseDatasource>()));
  gh.factory<_i770.LecturesBloc>(
      () => _i770.LecturesBloc(datasource: gh<_i895.LectureDatasource>()));
  gh.factory<_i902.VideoPlayBloc>(() => _i902.VideoPlayBloc(
        gh<_i734.VideoEventsDatasource>(),
        gh<_i1004.CodeExerciseDatasource>(),
      ));
  return getIt;
}

class _$LocalModule extends _i414.LocalModule {}

class _$NetworkModule extends _i220.NetworkModule {}
