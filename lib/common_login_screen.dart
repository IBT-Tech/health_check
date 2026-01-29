import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PathologyLoginApp());
}

class PathologyLoginApp extends StatelessWidget {
  const PathologyLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  String selectedRole = '';
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    loadConfig();
  }

  Future<void> loadConfig() async {
    final data = await rootBundle.loadString('assets/login_config.json');
    final jsonData = json.decode(data);
    setState(() {
      config = jsonData;
      selectedRole = jsonData['roles'][0];
    });
  }

  /// 🔹 Icon mapper (string → IconData)
  IconData getIcon(String name) {
    switch (name) {
      case 'mail':
        return Icons.mail_outline;
      case 'lock':
        return Icons.lock_outline;
      case 'visibility':
        return Icons.visibility;
      case 'biotech':
        return Icons.biotech;
      case 'login': // 👈 YAHAN
        return Icons.login;
      default:
        return Icons.help;
    }
  }


  @override
  Widget build(BuildContext context) {
    if (config == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final primary = const Color(0xFF137fec);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              /// 🔹 TOP BAR (same)
              Row(
                children: const [
                  Icon(Icons.chevron_left),
                  Spacer(),
                  Text(
                    "Pathology Login",
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                ],
              ),

              const SizedBox(height: 24),

              /// 🔹 BRAND ICON (same, now JSON driven)
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    getIcon(config!['brandIcon']),
                    size: 40,
                    color: primary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: Text(
                  config!['welcomeTitle'],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  config!['welcomeSubtitle'],
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),

              /// 🔹 ROLE SELECTOR (rectangle with small round radius)
              Container(
                height: 50,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8), // 🔹 small radius
                ),
                child: Row(
                  children: config!['roles'].map<Widget>((role) {
                    final isSelected = selectedRole == role;

                    return Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8), // 🔹 small radius
                          splashColor: Colors.white.withOpacity(0.3),
                          highlightColor: Colors.white.withOpacity(0.1),
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.hovered) ||
                                  states.contains(MaterialState.pressed)) {
                                return Colors.white.withOpacity(0.1); // always white
                              }
                              return null;
                            },
                          ),
                          onTap: () {
                            setState(() {
                              selectedRole = role;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(8), // 🔹 small radius
                            ),
                            child: Text(
                              role,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),


              /// 🔹 EMAIL
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config!['email']['label'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: config!['email']['hint'],
                      prefixIcon: Icon(getIcon(config!['email']['icon'])),
                      filled: true,
                      fillColor: Colors.white,

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),



              /// 🔹 PASSWORD
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config!['password']['label'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12), // gap
                  TextField(
                    obscureText: !passwordVisible,
                    decoration: InputDecoration(
                      hintText: config!['password']['hint'],
                      prefixIcon: Icon(getIcon(config!['password']['icon'])),
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? getIcon(config!['password']['toggleIcon'])
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() => passwordVisible = !passwordVisible);
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,

                      // Small rectangle borders
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8), // small radius
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),


              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: primary, // 🔹 blue color
                    textStyle: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  child: Text(config!['buttons']['forgot']),
                ),
              ),


              const SizedBox(height: 16),

        // 🔹 Sign In Button - Rectangle with Small Round Radius
        SizedBox(
          width: double.infinity,
          height: 50, // rectangle height
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(
              getIcon(config!['buttons']['login']['icon']),
              color: Colors.white,
            ),
            label: Text(
              config!['buttons']['login']['text'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 🔹 small radius
              ),
              elevation: 2, // subtle shadow
            ),
          ),
        ),

        const SizedBox(height: 16),

// 🔹 Footer - Register
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              config!['buttons']['footerText'],
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 6),
            TextButton(
              onPressed: () {},
              child: Text(
                config!['buttons']['register'],
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
          ),),),);}}
