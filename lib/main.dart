import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muhamad_tpa_apps/data/datasources/auth_local_datasource.dart';
import 'package:muhamad_tpa_apps/data/models/response/auth_response_model.dart';
import 'package:muhamad_tpa_apps/presentation/home/pages/dashboard_page.dart';
import 'package:muhamad_tpa_apps/presentation/onboarding/pages/onboarding_pages.dart';

import 'data/datasources/onboarding_local_datasource.dart';
import 'presentation/auth/bloc/login/login_bloc.dart';
import 'presentation/auth/bloc/logout/logout_bloc.dart';
import 'presentation/auth/bloc/register/register_bloc.dart';
import 'presentation/auth/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RegisterBloc(),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder<AuthResponseModel>(
          future: AuthLocalDatasource().getAuthData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const DashboardPage();
            } else {
              return FutureBuilder<bool>(
                  future: OnboardingLocalDatasource().getIsFirstTime(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!
                          ? const LoginPage()
                          : const OnboardingPage();
                    } else {
                      return const OnboardingPage();
                    }
                  });
            }
          },
        ),
      ),
    );
  }
}
