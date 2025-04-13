import 'package:fit_track/common_libs.dart';
import 'package:fit_track/models/user_model.dart';
import 'package:fit_track/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel? user;

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool isNotificationEnabled = true;

  Future getUser() async =>
      user = await UserManager.instance.fetchUserFromSupabase();

  @override
  void initState() {
    super.initState();
    getUser().then((_) {
      nameController.text = user?.name ?? '';
      emailController.text = user?.email ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFf9f9f9),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0XFFf9f9f9),
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundImage: AssetImage('assets/images/account.png'),
                ),
                const SizedBox(width: 45),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        CustomTextField(
                          label: 'Name',
                          icon: Icons.person,
                          controller: nameController,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Email',
                          icon: Icons.email_outlined,
                          enabled: false,
                          controller: emailController,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Gender",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              tileColor: Colors.white,
              title: const Text("App Settings"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: const Text("Notifications"),
                value: isNotificationEnabled,
                onChanged: (val) {
                  setState(() {
                    isNotificationEnabled = val;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: const Text(
                  "Connect Google Fit",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                title: const Text(
                  "Log Out",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
