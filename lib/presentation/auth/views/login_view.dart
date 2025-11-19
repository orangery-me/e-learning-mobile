import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/common/extensions/context_extension.dart';
import 'package:e_learning_mobile/common/extensions/string_extension.dart';
import 'package:e_learning_mobile/common/theme/app_size.dart';
import 'package:e_learning_mobile/common/utils/toast_util.dart';
import 'package:e_learning_mobile/data/repositories/user_repository.dart';
import 'package:e_learning_mobile/di/di.dart';
import 'package:e_learning_mobile/generated/locale_keys.g.dart';
import 'package:e_learning_mobile/presentation/auth/bloc/auth/auth_bloc.dart';
import 'package:e_learning_mobile/presentation/auth/bloc/login/login_bloc.dart';
import 'package:e_learning_mobile/presentation/auth/widgets/login_form.dart';
import 'package:e_learning_mobile/presentation/widgets/common_rounded_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        authBloc: context.read<AuthBloc>(),
        userRepository: getIt.get<UserRepository>(),
      ),
      child: BlocListener<LoginBloc, LoginState>(
        listener: _listenLoginStateChanged,
        child: _LoginView(),
      ),
    );
  }

  void _listenLoginStateChanged(BuildContext context, LoginState state) {
    if (state is LoginNotSuccess && state.error.isNullOrEmpty) {
      ToastUtil.showError(context);
    }
  }
}

class _LoginView extends StatelessWidget {
  _LoginView();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailEditController = TextEditingController();
  final TextEditingController _passwordEditController = TextEditingController();

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(
        LoginSubmit(
          email: _emailEditController.text,
          password: _passwordEditController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppSize.horizontalSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.auth_welcome_back.tr(),
                    // style: context.textStyles.subHeading1,
                    style: context.textStyles.subHeading1,
                  ),
                  LoginForm(
                    formKey: _formKey,
                    emailEditController: _emailEditController,
                    passwordEditController: _passwordEditController,
                  ),
                  BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      return CommonRoundedButton(
                        key: const ValueKey('sign_in_button'),
                        onPressed: () => _submitLogin(context),
                        isLoading: state is LoginLoading,
                        content: LocaleKeys.auth_sign_in.tr(),
                        width: double.infinity,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
