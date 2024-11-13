import 'package:flutter/material.dart';


class SettingsDrawer extends StatelessWidget {
  final Function(String) onLanguageChanged;
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const SettingsDrawer({
    super.key,
    required this.onLanguageChanged,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF4CA0D1),
            ),
            child: Text(
              'Pengaturan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ListTile(
            title: const Text('Bahasa'),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          ListTile(
            title: Text(isDarkMode ? 'Mode Terang' : 'Mode Gelap'),
            onTap: () {
              onThemeChanged(!isDarkMode);
            },
          ),
          ListTile(
            title: const Text('Login'),
            onTap: () {
              // Tambahkan fungsi navigasi atau login di sini
              Navigator.pop(context); // Tutup drawer
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Bahasa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Bahasa Indonesia'),
                onTap: () {
                  onLanguageChanged('id');
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Bahasa Inggris'),
                onTap: () {
                  onLanguageChanged('en');
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
