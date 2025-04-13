import 'package:fit_track/widgets/loader.dart';

import '../common_libs.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? _user;

  Future<void> _getAuth() async {
    setState(() {
      _user = Supabase.instance.client.auth.currentUser;
    });
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() {
        _user = data.session?.user;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), _checkAuth);
  }

  void _checkAuth() async {
    await _getAuth();
    if (mounted) {
      if (_user == null) {
        AppNavigator.push(context, AppRoutes.login);
      } else {
        AppNavigator.push(context, AppRoutes.home);
      }
    }
    Logger().i(_user?.toJson().toString());
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: AppLoader()));
  }
}
