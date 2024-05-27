import 'dart:io';

import 'package:flutter/foundation.dart';

final pythonScriptsFolderPath = kDebugMode
    ? 'F:/S_Data/Flutter_Projects/steps_recorder/python'
    : '${Directory.current.absolute.path}${Platform.pathSeparator}python';

final scriptsFolder = '$pythonScriptsFolderPath/scripts';
