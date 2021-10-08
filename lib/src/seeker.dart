import 'package:kana_kit/kana_kit.dart';

import '../objectbox.g.dart';
import 'entities.dart';

class JMDictSeeker {

  final KanaKit _kanaKit = KanaKit();

  List<JMDictEntryImpl>? search({
    required String keyword,
    required Store store,
    // Set<KanjiInfo>? kanjiInfo,
    // Set<String>? kanjiPriorities,
    // bool includeReadingRestrictions = false,
    // Set<ReadingInfo>? readingInfo,
    // Set<String>? readingPriorities,
    // bool lookupGlossaries = false,
    // Set<SenseLanguage>? glossaryLanguages,
    // Set<GlossaryType>? glossaryTypes,
    // bool lookupKanjiSenseRestrictions = false,
    // bool lookupReadingSenseRestrictions = false,
    // bool lookupCrossReferences = false,
    // bool lookupAntonyms = false,
    // Set<PartOfSpeech>? partOfSpeeches,
    // Set<SenseField>? fields,
    // Set<MiscellaneousEntity>? misc,
    // bool lookupSenseInfo = false,
    // bool includeSourceLanguage = false,
    // Set<SenseLanguage>? sourceLanguageFilters,
    // Set<SourceLanguageType>? sourceLanguageTypeFilters,
    // bool lookupWasei = false,
    // Set<Dialect>? dialects,
    int? offset,
    int? limit,
  }) {
    keyword = keyword.replaceAll(
      RegExp(r"(=>)|(::)|(&&)",),
      "",
    );
    if (keyword.isEmpty) {
      return null;
    }
    final box = store.box<JMDictEntryImpl>();
    Condition<JMDictEntryImpl> condition = JMDictEntryImpl_.kanaTexts.contains(keyword,).orAny(
      [
        JMDictEntryImpl_.romajiTexts.contains(
          _kanaKit.toRomaji(keyword,),
        ),
        JMDictEntryImpl_.kanaTexts.contains(
          keyword,
        ),
        JMDictEntryImpl_.kanjiTexts.contains(
          keyword,
        ),
        JMDictEntryImpl_.glossaries.contains(
          keyword,
        ),
      ],
    );

    // if (kanjiInfo != null && kanjiInfo.isNotEmpty) {
    //   condition = condition.orAny(
    //     kanjiInfo.map(
    //       (info) => JMDictEntry_.kanjiInfo.contains(
    //         describeEnum(info,),
    //       ),
    //     ).toList(growable: false,),
    //   );
    // }

    // if (kanjiPriorities != null && kanjiPriorities.isNotEmpty) {
    //   condition = condition.orAny(
    //     kanjiPriorities.map(
    //       (pri) => JMDictEntry_.kanjiPriorities.contains(pri,),
    //     ).toList(growable: false,),
    //   );
    // }

    // if (includeReadingRestrictions) {
    //   condition = condition.or(
    //     JMDictEntryImpl_.readingRestrictions.contains(keyword,),
    //   );
    // }

    // if (readingInfo != null && readingInfo.isNotEmpty) {
    //   condition = condition.orAny(
    //     readingInfo.map(
    //       (info) => JMDictEntry_.readingInfo.contains(
    //         describeEnum(info,),
    //       ),
    //     ).toList(growable: false,),
    //   );
    // }

    // if (readingPriorities != null && readingPriorities.isNotEmpty) {
    //   condition = condition.orAny(
    //     readingPriorities.map(
    //       (pri) => JMDictEntry_.readingPriorities.contains(pri,),
    //     ).toList(growable: false,),
    //   );
    // }

    // if (lookupGlossaries) {
    //   condition = condition.or(
    //     JMDictEntryImpl_.glossaries.contains(keyword,),
    //   );
    // }

    // if (lookupKanjiSenseRestrictions) {
    //   condition = condition.or(
    //     JMDictEntryImpl_.kanjiSenseRestrictions.contains(keyword,),
    //   );
    // }

    // if (lookupReadingSenseRestrictions) {
    //   condition = condition.or(
    //     JMDictEntryImpl_.readingSenseRestrictions.contains(keyword,),
    //   );
    // }

    // if (lookupCrossReferences) {
    //   condition = condition.or(
    //     JMDictEntry_.crossReferences.contains(keyword,),
    //   );
    // }

    // if (lookupAntonyms) {
    //   condition = condition.or(
    //     JMDictEntry_.antonyms.contains(keyword,),
    //   );
    // }

    // if (partOfSpeeches != null && partOfSpeeches.isNotEmpty) {
    //   condition = condition.orAny(
    //     partOfSpeeches.map(
    //       (pos) => JMDictEntry_.partOfSpeeches.contains(
    //         describeEnum(pos,).replaceAll("_", "-",),
    //       ),
    //     ).toList(growable: false,),
    //   );
    // }

    // if (fields != null && fields.isNotEmpty) {
    //   condition = condition.orAny(
    //     fields.map(
    //       (field) => JMDictEntry_.fields.contains(
    //         describeEnum(field,),
    //       ),
    //     ).toList(growable: false,),
    //   );
    // }

    // if (misc != null && misc.isNotEmpty) {
    //   condition = condition.orAny(
    //     misc.map(
    //       (misc) => JMDictEntry_.miscellaneous.contains(
    //         describeEnum(misc,).replaceAll("_", "-",),
    //       ),
    //     ).toList(growable: false,),
    //   );
    // }

    // if (lookupSenseInfo) {
    //   condition = condition.or(
    //     JMDictEntry_.senseInfo.contains(keyword,),
    //   );
    // }

    // return box.query(condition,).build().find();

    final query = box.query(condition,).build();
    if (offset != null && offset != 0) {
      query.offset = offset.abs();
    }
    if (limit != null && limit != 0) {
      query.limit = limit.abs();
    }
    return query.find();
  }
}