import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_management/core/theme/app_theme.dart';
import 'package:user_management/core/utils/responsive_layout.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English (US)';

  final List<Map<String, dynamic>> _languages = [
    {'title': 'English (US)', 'group': 'Suggested'},
    {'title': 'English (UK)', 'group': 'Suggested'},
    {'title': 'Mandarin', 'group': 'Language'},
    {'title': 'Hindi', 'group': 'Language'},
    {'title': 'Spanish', 'group': 'Language'},
    {'title': 'French', 'group': 'Language'},
    {'title': 'Arabic', 'group': 'Language'},
    {'title': 'Bengali', 'group': 'Language'},
    {'title': 'Russian', 'group': 'Language'},
    {'title': 'Indonesia', 'group': 'Language'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    // Group languages by their group
    final Map<String, List<Map<String, dynamic>>> groupedLanguages = {};
    for (var language in _languages) {
      final group = language['group'];
      if (!groupedLanguages.containsKey(group)) {
        groupedLanguages[group] = [];
      }
      groupedLanguages[group]!.add(language);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Language',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => context.pop(),
        ),
      ),
      body: ResponsiveContainer(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ...groupedLanguages.entries.map((entry) {
              final group = entry.key;
              final languages = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...languages.map(
                    (language) => _buildLanguageOption(language['title']),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            _selectedLanguage == language
                ? Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryColor,
                  ),
                  child: const Center(
                    child: Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                )
                : Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
