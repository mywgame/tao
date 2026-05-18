import os

def create_structure():
    folders = [
        "android",
        "ios",
        "web",
        "lib/core/config",
        "lib/core/di",
        "lib/core/error",
        "lib/core/extensions",
        "lib/core/helpers",
        "lib/core/network",
        "lib/core/routes",
        "lib/core/theme",
        "lib/core/utils",
        "lib/features/auth/data",
        "lib/features/auth/domain",
        "lib/features/auth/presentation/bloc",
        "lib/features/auth/presentation/pages",
        "lib/features/auth/presentation/widgets",
        "lib/features/auth/presentation/screens",
        "lib/features/dashboard",
        "lib/features/staking",
        "lib/features/referral",
        "lib/features/k1_club",
        "lib/features/transactions",
        "lib/features/profile",
        "lib/features/notifications",
        "lib/shared/widgets",
        "lib/shared/models",
        "lib/shared/utils",
        "lib/data",
        "lib/domain",
        "assets/images",
        "assets/icons",
        "assets/animations",
    ]
    
    for folder in folders:
        os.makedirs(folder, exist_ok=True)
        print(f"✅ Created: {folder}")
    
    # Important files
    files = [
        "lib/main.dart",
        "lib/core/config/app_config.dart",
        "lib/core/theme/app_colors.dart",
        "lib/core/theme/app_theme.dart",
        "lib/core/routes/app_router.dart",
        "pubspec.yaml"
    ]
    
    for file_path in files:
        # Directory ensure karo
        dir_name = os.path.dirname(file_path)
        if dir_name:
            os.makedirs(dir_name, exist_ok=True)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            if file_path == "lib/main.dart":
                f.write('''import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TAO Boost',
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(child: Text('TAO Boost - Welcome')),
      ),
    );
  }
}
''')
            else:
                f.write('// TODO: Add code here\n')
        print(f"📄 Created file: {file_path}")

if __name__ == "__main__":
    create_structure()
    print("\n🎉 Saari structure successfully ban gayi hai!")