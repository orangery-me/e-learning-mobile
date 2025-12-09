import 'package:e_learning_mobile/presentation/core/widgets/crystal_bottom_navigation_bar.dart';
import 'package:e_learning_mobile/presentation/payment/views/order_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:e_learning_mobile/presentation/core/bloc/root_bloc.dart';
import 'package:e_learning_mobile/presentation/core/widgets/app_bottom_navigation_bar.dart';
import 'package:e_learning_mobile/presentation/core/widgets/slide_lazy_indexed_stack.dart';
import 'package:e_learning_mobile/presentation/home/home.dart';
import 'package:e_learning_mobile/presentation/progress/my_learning.dart';
import 'package:e_learning_mobile/presentation/notification/notification.dart';
import 'package:e_learning_mobile/presentation/profile/profile.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => RootBloc(), child: const _RootView());
  }
}

class _RootView extends StatelessWidget {
  const _RootView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocBuilder<RootBloc, RootState>(
        builder: (context, state) {
          return SlideIndexedStack(
            index: state.currentIndex,
            children: [
              HomePage(),
              MyLearningPage(),
              NotificationPage(),
              OrderPage(),
              ProfilePage(),
            ],
          );
        },
        buildWhen: (previous, current) {
          return previous.currentIndex != current.currentIndex;
        },
      ),
      bottomNavigationBar: const CrystalBottomNavigationBar(),
    );
  }
}
