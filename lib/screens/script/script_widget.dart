import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../models/script/script.dart';
import '../../services/notification_service.dart';
import '../../utils/extensions/datetime_extension.dart';
import '../../utils/widgets/loading_icon_button.dart';
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
    /// an auto generated bright color based on the script's creation date
    final color =
        colorsForScripts[script.createdAt.hashCode % colorsForScripts.length];

    return Card(
      key: ValueKey(script.createdAt),
      elevation: 10,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding:
            const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
        onTap: _edit,
        title: RichText(
          text: TextSpan(
            text: script.title,
            style: textTheme.titleLarge!.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: '   ${script.updatedAt.timeAgo()}',
                style: textTheme.bodySmall!.copyWith(
                  color: colorScheme.onPrimary,
                ),
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
              style: TextStyle(
                color: colorScheme.onPrimary,
              ),
            ),
            Text(
              'CreatedAt: ${script.createdAt.toMonthString()} ${script.createdAt.amPmTime}',
              style: TextStyle(color: colorScheme.onPrimary),
            ),
            Text(
              'UpdatedAt: ${script.updatedAt.toMonthString()} ${script.updatedAt.amPmTime}',
              style: TextStyle(color: colorScheme.onPrimary),
            ),
          ],
        ),
        trailing: Wrap(
          alignment: WrapAlignment.end,
          runAlignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            LoadingIconButton(
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.surface,
              ),
              tooltip: 'Delete Script',
              onPressed: _delete,
              icon: Icon(
                Icons.delete_rounded,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(width: 10),
            PlayScriptButton(script: script),
          ],
        ),
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

  Future<void> _delete() async => script.delete();
}
