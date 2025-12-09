import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:e_learning_mobile/presentation/core/bloc/root_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class CrystalBottomNavigationBar extends StatelessWidget {
  const CrystalBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(
      builder: (context, state) {
        return CrystalNavigationBar(
          currentIndex: state.currentIndex,
          // indicatorColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.black.withValues(alpha: 0.8),
          outlineBorderColor: Colors.black.withValues(alpha: 0.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              spreadRadius: 4,
              offset: Offset(0, 10),
            ),
          ],
          borderWidth: 2,
          // outlineBorderColor: Colors.white,
          onTap: (int newIndex) {
            context.read<RootBloc>().add(
                  RootBottomTabChange(newIndex: newIndex),
                );
          },
          items: [
            /// Home
            CrystalNavigationBarItem(
              icon: IconlyBold.home,
              unselectedIcon: IconlyLight.home,
              selectedColor: Colors.white,
              badge: Badge(
                label: Text(
                  "9+",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            /// Learning
            CrystalNavigationBarItem(
              icon: IconlyBold.play,
              unselectedIcon: IconlyLight.play,
              selectedColor: Colors.white,
            ),

            /// Search
            CrystalNavigationBarItem(
                icon: IconlyBold.plus,
                unselectedIcon: IconlyLight.plus,
                selectedColor: Colors.white),

            /// Orders
            CrystalNavigationBarItem(
              icon: IconlyBold.bag2,
              unselectedIcon: IconlyLight.bag2,
              selectedColor: Colors.red,
            ),

            /// Profile
            CrystalNavigationBarItem(
              icon: IconlyBold.user2,
              unselectedIcon: IconlyLight.user2,
              selectedColor: Colors.white,
            ),
          ],
        );
      },
    );
  }
}
