import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import 'constants.dart';
import 'enums.dart';

@internal
class JMDictLogUtils {

  JMDictLogUtils._();

  static const _PREFIX = "[JMDict]:";

  static void log(String? message,) {
    print("$_PREFIX $message",);
  }

  static void debugLog(String? message,) {
    debugPrint("$_PREFIX $message",);
  }
}

@internal
class JMDictParser {

  JMDictParser._();

  static Map<int, List<String>>? parseObEntryString(String? data,) {
    if (data != null) {
      Map<int, List<String>> result = {};
      final split = data.split(
        DELIMITER,
      );
      for (String entry in split) {
        final _split = entry.split(IDX_DELIMITER,);
        if (_split.length >= 2) {
          final idx = int.tryParse(_split[0],);
          if (idx != null) {
            result[idx] ??= <String>[];
            result[idx]?.add(_split[1],);
          }
        }
      }
      return result;
    }
  }

  static int? readingPriority(List<String>? pri, Set<ReadingPriority> target,) {
    if (pri != null) {
      int? nf;
      target.addAll(
        pri.map(
          (_pri) {
            switch (_pri) {
              case "news1": return ReadingPriority.news1;
              case "news2": return ReadingPriority.news2;
              case "ichi1": return ReadingPriority.ichi1;
              case "ichi2": return ReadingPriority.ichi2;
              case "spec1": return ReadingPriority.spec1;
              case "spec2": return ReadingPriority.spec2;
              case "gai1": return ReadingPriority.gai1;
              case "gai2": return ReadingPriority.gai2;
              default:
                if (_pri.indexOf("nf") == 0 && _pri.length == 4) {
                  nf ??= int.tryParse(
                    _pri.substring(2, 4,),
                  );
                  return ReadingPriority.nf;
                }
                break;
            }
            return null;
          },
        ).whereType<ReadingPriority>(),
      );
      return nf;
    }
  }
}