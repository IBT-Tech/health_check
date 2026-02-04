import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const PathologyLoginApp());
}

class PathologyLoginApp extends StatelessWidget {
  const PathologyLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pathology Login',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF137fec),
        scaffoldBackgroundColor: const Color(0xFFF6F7F8),
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF137fec),
        scaffoldBackgroundColor: const Color(0xFF101922),
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.system,
      home: const PathologyLoginPage(),
    );
  }
}

class PathologyLoginPage extends StatefulWidget {
  const PathologyLoginPage({super.key});

  @override
  State<PathologyLoginPage> createState() => _PathologyLoginPageState();
}

class _PathologyLoginPageState extends State<PathologyLoginPage> {
  Map<String, dynamic>? config;
  List roles = [];
  List fields = [];
  Map<String, dynamic>? welcome;
  Map<String, dynamic>? signInButton;

  String selectedRole = '';
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  Future<void> loadConfig() async {
    final response = await rootBundle.loadString('assets/all.json');
    final decoded = json.decode(response);

    setState(() {
      config = decoded['common_login_screen'];

      roles = config?['roles'] ?? [];
      fields = config?['fields'] ?? [];
      welcome = config?['welcome'];
      signInButton = config?['sign_in_button'];

      if (roles.isNotEmpty) {
        selectedRole = roles.first.toString();
      }
    });
  }

  Icon getIcon(String iconName) {
    switch (iconName) {
      case 'mail':
        return const Icon(Icons.mail);
      case 'lock':
        return const Icon(Icons.lock);
      case 'login':
        return const Icon(
          Icons.login,
          color: Colors.white, // 👈 icon white
        );

      case 'biotech':
        return const Icon(
          Icons.biotech,
          color: Color(0xFF137FEC),
          size: 39, // 👈 yahan size badhao (24, 28, 32 jo chaho)
        );
      default:
        return const Icon(Icons.help_outline);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final brightness = Theme.of(context).brightness;
    final textDark = Colors.black87;
    final textLight = Colors.white;
    final subTextLight = const Color(0xFF4c739a);

    if (config == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              /// Top App Bar
              Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(Icons.chevron_left,
                        color: brightness == Brightness.light
                            ? textDark
                            : textLight),
                  ),
                  Expanded(
                    child: Text(
                      config?['app_title'] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: brightness == Brightness.light
                            ? textDark
                            : textLight,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 24),

              /// Brand / Welcome
              Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20), // 👈 small radius (rectangle feel)
                    ),
                    alignment: Alignment.center,
                    child: getIcon('biotech'),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    welcome?['title'] ?? '',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: brightness == Brightness.light
                          ? textDark
                          : textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 280,
                    child: Text(
                      welcome?['subtitle'] ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: brightness == Brightness.light
                            ? subTextLight
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              /// Role Selector
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: brightness == Brightness.light
                      ? const Color(0xFFE7EDF3)
                      : Colors.grey[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(roles.length, (index) {
                    final role = roles[index].toString();
                    final selected = selectedRole == role;

                    return GestureDetector(
                      onTap: () => setState(() => selectedRole = role),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 34,              // 👈 height kam
                          padding: const EdgeInsets.symmetric(
                            horizontal: 80,        // 👈 width control yahin se
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected
                                ? (brightness == Brightness.light
                                ? Colors.white
                                : primary)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            role,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: selected
                                  ? (brightness == Brightness.light
                                  ? textDark
                                  : textLight)
                                  : brightness == Brightness.light
                                  ? subTextLight
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),

              /// Input Fields
              ...List.generate(fields.length, (index) {
                final field = fields[index];
                final bool isPassword = field['isPassword'] ?? false;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        field['label'] ?? '',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      TextField(
                        obscureText: isPassword && !passwordVisible,
                        decoration: InputDecoration(
                          prefixIcon: getIcon(field['icon'] ?? ''),
                          suffixIcon: isPassword
                              ? IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(() =>
                            passwordVisible = !passwordVisible),
                          )
                              : null,
                          hintText: field['hint'] ?? '',
                          filled: true,
                          fillColor: brightness == Brightness.light
                              ? Colors.white
                              : Colors.grey[900],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      if (field['forgotPassword'] == true)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text("Forgot password?",
                                style:
                                TextStyle(color: primary, fontSize: 14)),
                          ),
                        ),
                    ],
                  ),
                );
              }),

              /// Sign In Button
              ElevatedButton.icon(
                onPressed: () {},
                icon: getIcon(signInButton?['icon'] ?? ''),
                label: Text(
                  signInButton?['text'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),const SizedBox(height: 24),

              /// Don't have account + Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: brightness == Brightness.light
                          ? const Color(0xFF4C739A)
                          : Colors.grey[400],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Register screen navigation
                    },
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

