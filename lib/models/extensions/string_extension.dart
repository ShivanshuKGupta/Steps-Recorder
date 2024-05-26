import 'dart:math' as math;

extension StringExtensions on String {
  String toPascalCase() {
    if (isEmpty) return this;

    // Split the string by whitespace and capitalize the first letter of each word
    return split(' ').map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1)}';
      }
      return '';
    }).join(' ');
  }

  String toUnderScoreString() {
    if (isEmpty) return this;
    return split(' ').join('_');
  }

  String get removeUnderScore {
    if (isEmpty) return this;

    // Split the string by underscore and capitalize the first letter of each word
    // and join them using a space
    return split('_').map((word) {
      if (word.isNotEmpty) {
        return '${word[0].toUpperCase()}${word.substring(1)}';
      }
      return '';
    }).join(' ');
  }

  String fromPascalCase() {
    if (isEmpty) return this;
    final input = removeAllWhitespace;
    String output = '';
    for (int i = 0; i < input.length; i++) {
      if (i == 0) {
        output += input[i].toUpperCase();
      } else if (i > 0 &&
          (input[i - 1] == '_' ||
              input[i - 1] == ' ' ||
              input[i].toUpperCase() == input[i])) {
        output += ' ${input[i].toUpperCase()}';
      } else if (input[i] == '_') {
        output += ' ';
      } else {
        output += input[i];
      }
    }
    return output;
  }

  String getInitials() {
    if (isEmpty) return this;
    String initials = split(' ').map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase();
      }
      return '';
    }).join('');
    return initials.substring(0, math.min(2, initials.length));
  }

  String takeWords(int wordCount) {
    if (isEmpty) return this;
    return split(' ').take(wordCount).join(' ');
  }

  String removeAll(String pattern) {
    // Replace all occurrences of the pattern irrespective of the case with an empty string
    return replaceAll(RegExp(pattern.toLowerCase(), caseSensitive: false), '');
  }

  String get sanitised {
    String ans = this;
    ans = ans.removeAll('appwrite');
    if (ans.contains(':')) {
      // removing the first word before colon
      ans = (ans.split(':').lastOrNull ?? ans).trim();
      // removing the first word
      ans = ans.split(' ').sublist(1).join(' ');
      // Remove everything in a bracket
      ans = ans.replaceAll(RegExp(r'\(.*\)'), '');
    }
    return ans;
  }

  String get removeAllWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }
}
