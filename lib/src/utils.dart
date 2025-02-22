import 'package:flutter/foundation.dart';
import 'package:twemoji/twemoji.dart';

/// Will always return [TwemojiFormat.svg] unless flutter web html renderer
TwemojiFormat getTwemojiFormat() {
  const isSkia = bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');
  if (kIsWeb && !isSkia) {
    return TwemojiFormat.png;
  } else {
    return TwemojiFormat.svg;
  }
}

/// Converts emoji to unicode 😀 => "1F600"
String emojiToUnicode(String input) {
  if (input.length == 1) {
    return input.codeUnits.first.toString();
  } else if (input.length > 1) {
    final pairs = <int>[];
    for (var i = 0; i < input.length; i++) {
      if (
          // high surrogate
          input.codeUnits[i] >= 0xd800 && input.codeUnits[i] <= 0xdbff) {
        if (input.codeUnits[i + 1] >= 0xdc00 &&
            input.codeUnits[i + 1] <= 0xdfff) {
          // low surrogate
          pairs.add((input.codeUnits[i] - 0xd800) * 0x400 +
              (input.codeUnits[i + 1] - 0xdc00) +
              0x10000);
        }
      } else if (input.codeUnits[i] < 0xd800 || input.codeUnits[i] > 0xdfff) {
        // modifiers and joiners
        pairs.add(input.codeUnitAt(i));
      }
    }
    return pairs.map((e) => e.toRadixString(16)).toList().join('-');
  }

  return '';
}
