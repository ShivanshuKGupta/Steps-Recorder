import 'package:flutter/material.dart';

import '../../globals.dart';
import '../../models/events/script.dart';
import '../../models/extensions/datetime_extension.dart';
import '../../utils/widgets/loading_icon_button.dart';

class ScriptWidget extends StatelessWidget {
  final Script script;
  const ScriptWidget({
    required this.script,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                text: script.title,
                style: textTheme.titleLarge!.copyWith(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: '   ${script.updatedAt.timeAgo()}',
                    style: textTheme.bodySmall!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Text(
                  script.description ?? 'No description',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.end,
                runAlignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  LoadingIconButton(
                    onPressed: () async {
                      await script.delete();
                    },
                    icon: const Icon(
                      Icons.delete_rounded,
                      color: Colors.red,
                    ),
                  ),
                  LoadingIconButton(
                    onPressed: () async {
                      // TODO: edit
                    },
                    icon: const Icon(
                      Icons.edit_rounded,
                      color: Colors.blue,
                    ),
                  ),
                  LoadingIconButton(
                    onPressed: () async {
                      // TODO: play
                    },
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
