import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/shared/cubit/state.dart';

import '../../shared/cubit/cubit.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialAppCubit, SocialAppState>(
      listener: (context, state) {},

      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Welcome Back', style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          bottomNavigationBar: BottomNavigationBar(
              currentIndex: SocialAppCubit.get(context).index,
              onTap: (index) {
                SocialAppCubit.get(context).changeBottomNav(index: index);
              },
              selectedItemColor: Colors.amber,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
              ]),

          body: IndexedStack(
            index: SocialAppCubit.get(context).index,
            children: [
              FeedsScreen(),
              ChatsScreen(),
              SettingsScreen(),
            ],
          ),
        );
      },
    );
  }
}
