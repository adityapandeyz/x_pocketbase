import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_pocketbase/features/auth/controller/auth_controller.dart';
import 'package:x_pocketbase/features/auth/view/signup_view.dart';
import 'package:x_pocketbase/theme/app_theme.dart';

import 'common/common.dart';
import 'features/home/view/home_view.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAuthTokenProvider).when(
            data: (token) {
              if (token == null) {
                return const SignUpView();
              }
              return const HomeView();
            },
            error: (error, st) => ErrorPage(
              error: error.toString(),
            ),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
