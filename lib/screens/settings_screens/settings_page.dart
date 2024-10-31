import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/l10n.dart';
import '../../main.dart';
import '../../values/app_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = 'en';
  String _selectedThemeMode = 'light';
  bool _notificationsEnabled = true;
  bool _isLoading = true;
  bool _isUpdating = false;

  late AppPreferences appPreferences;

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    appPreferences = AppPreferences(prefs);

    setState(() {
      _selectedLanguage = appPreferences.getPreferredLanguage();
      _selectedThemeMode = appPreferences.getThemeMode();
      _notificationsEnabled = appPreferences.getNotificationsEnabled();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _updateLanguage(String language) async {
    setState(() {
      _isUpdating = true;
    });

    await appPreferences.setPreferredLanguage(language);

    setState(() {
      _selectedLanguage = language;
      _isUpdating = false;
    });

    // Update the app's locale
    if(mounted) MyApp.of(context)?.setLocale(Locale(language));
  }

  Future<void> _updateThemeMode(String themeMode) async {
    setState(() {
      _isUpdating = true;
    });

    await appPreferences.setThemeMode(themeMode);

    setState(() {
      _selectedThemeMode = themeMode;
      _isUpdating = false;
    });

    if (mounted) {
      MyApp.of(context)?.updateThemeMode(
          themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              DropdownButton<String>(
                value: _selectedLanguage,
                onChanged: (String? newLocale) {
                  if (newLocale != null) {
                    _updateLanguage(newLocale);
                  }
                },
                items: [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'fr', child: Text('French')),
                  DropdownMenuItem(value: 'ar', child: Text('العربية')),
                ],
              ),
              ListTile(
                title: Text(S.of(context).themeMode), // Localized 'Theme Mode'
                subtitle: Text('${S.of(context).justCurrent}: $_selectedThemeMode'), // Localized 'Current:'
                trailing: DropdownButton<String>(
                  value: _selectedThemeMode,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _updateThemeMode(newValue);
                    }
                  },
                  items: <String>['light', 'dark'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value), // Localized theme mode options
                    );
                  }).toList(),
                ),
              ),
              SwitchListTile(
                title: Text(S.of(context).enableNotifications), // Localized 'Enable Notifications'
                value: _notificationsEnabled,
                onChanged: (bool newValue) {
                  _toggleNotifications(newValue);
                },
              ),

            ],
          ),
          if (_isUpdating)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Future<void> _toggleNotifications(bool isEnabled) async {
    setState(() {
      _isUpdating = true;
    });

    await appPreferences.setNotificationsEnabled(isEnabled);

    setState(() {
      _notificationsEnabled = isEnabled;
      _isUpdating = false;
    });
  }
}
