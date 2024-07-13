import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../models/script/script.dart';
import '../../services/notification_service.dart';
import '../../utils/extensions/datetime_extension.dart';
import '../../widgets/play_script_button.dart';
import 'script_edit_screen.dart';

class ScriptWidget extends StatelessWidget {
  final Script script;
  const ScriptWidget({
    required this.script,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final color =
        colorsForScripts[script.createdAt.hashCode % colorsForScripts.length];

    return Card(
      key: ValueKey(script.createdAt),
      elevation: 0,
      color: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
        onTap: _edit,
        title: RichText(
          text: TextSpan(
            text: script.displayTitle,
            style: textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: '   ${script.updatedAt.timeAgo()}',
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              script.description == null || script.description!.isEmpty
                  ? 'No description'
                  : script.description!,
            ),
            Wrap(
              spacing: 10,
              runSpacing: 5,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 15, color: color),
                    Text(
                      ' ${script.createdAt.toMonthString()} ${script.createdAt.amPmTime}',
                      style: textTheme.bodySmall!.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.update_rounded, size: 15, color: color),
                    Text(
                      ' ${script.updatedAt.toMonthString()} ${script.updatedAt.amPmTime}',
                      style: textTheme.bodySmall!.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        trailing: PlayScriptButton(script: script),
      ),
    );
  }

  Future<void> _edit() async {
    if (!await script.scriptFile.exists()) {
      showError('Can\'t edit the script as the file does not exist!');
      return;
    }
    await Navigator.of(appContext).push(
      MaterialPageRoute(
        builder: (context) => ScriptEditScreen(
          script: script,
        ),
      ),
    );
  }
}
