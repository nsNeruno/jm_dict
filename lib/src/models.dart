import 'package:flutter/foundation.dart';
import 'package:jm_dict/src/constants.dart';
import 'package:kana_kit/kana_kit.dart';

import 'enums.dart';

final RegExp _nfRegex = RegExp(r"^nf\d{2}$",);

/// The kanji element, or in its absence, the reading element, is
/// the defining component of each entry.
/// The overwhelming majority of entries will have a single kanji
/// element associated with a word in Japanese. Where there are
/// multiple kanji elements within an entry, they will be orthographical
/// variants of the same word, either using variations in okurigana, or
/// alternative and equivalent kanji. Common "mis-spellings" may be
/// included, provided they are associated with appropriate information
/// fields. Synonyms are not included; they may be indicated in the
/// cross-reference field associated with the sense element.
///
/// Quoted from JMdict:45-54
class KanjiElement {

  KanjiElement(this.element, Set<String>? keInf, Set<String>? kePri,)
      : information = _information(keInf,) {
    final pris = _priorities(kePri,);
    priorities = pris?.elementAt(0,);
    _nf = pris?.elementAt(1,);
  }

  static late final Map<String, KanjiInfo> _keInf = Map.fromEntries(
    KanjiInfo.values.map(
          (e) => MapEntry(describeEnum(e,), e,),
    ),
  );

  static Set<KanjiInfo>? _information(Set<String>? keInf,) {
    if (keInf != null) {
      return keInf.map((e) => _keInf[e],).whereType<KanjiInfo>().toSet();
    }
  }

  static List<dynamic>? _priorities(Set<String>? kePri,) {
    if (kePri != null) {
      final pris = <ReadingPriority>{};
      int? nf;
      final priorities = Map.fromEntries(
        ReadingPriority.values.map(
          (e) => MapEntry(
            describeEnum(e,), e,
          ),
        ),
      );
      kePri.forEach(
        (pri) {
          if (_nfRegex.hasMatch(pri,)) {
            nf ??= int.parse(pri.substring(2, 4,),);
            pris.add(
              ReadingPriority.nf,
            );
          } else {
            final _pri = priorities[pri];
            if (_pri != null) {
              pris.add(_pri,);
            }
          }
        },
      );
      return [pris, nf,];
    }
  }

  /// This element will contain a word or short phrase in Japanese
  /// which is written using at least one non-kana character (usually kanji,
  /// but can be other characters). The valid characters are
  /// kanji, kana, related characters such as chouon and kurikaeshi, and
  /// in exceptional cases, letters from other alphabets.
  ///
  /// Quoted from JMdict:57-61
  final String element;

  /// This is a coded information field related specifically to the
  /// orthography of the keb, and will typically indicate some unusual
  /// aspect, such as okurigana irregularity.
  ///
  /// Quoted from JMdict:64-66
  final Set<KanjiInfo>? information;

  /// Records information about the relative priority of the entry, and consist
  /// of codes indicating the word appears in various references which
  /// can be taken as an indication of the frequency with which the word
  /// is used. This field is intended for use either by applications which
  /// want to concentrate on entries of a particular priority, or to
  /// generate subset files.
  ///
  /// Quoted from JMdict:69-75
  late final Set<ReadingPriority>? priorities;

  int? _nf;
  /// See [ReadingPriority.nf]
  int? get frequencyOfUseRanking => _nf;

  @override
  String toString() => element;
}

/// The reading element typically contains the valid readings
/// of the word(s) in the kanji element using modern kanadzukai.
/// Where there are multiple reading elements, they will typically be
/// alternative readings of the kanji element. In the absence of a
/// kanji element, i.e. in the case of a word or phrase written
/// entirely in kana, these elements will define the entry.
///
/// Quoted from JMdict:101-106
class ReadingElement {

  ReadingElement(this.element, this.readingRestrictions, Set<String>? reInf, Set<String>? rePri, [this.noKanji = false])
      : information = _information(reInf,) {
    final pris = _priorities(rePri,);
    priorities = pris?.elementAt(0,);
    _nf = pris?.elementAt(1,);
  }

  static late final Map<String, ReadingInfo> _reInf = Map.fromEntries(
    ReadingInfo.values.map(
      (e) => MapEntry(
        describeEnum(e,), e,
      ),
    ),
  );

  static Set<ReadingInfo>? _information(Set<String>? reInf,) {
    if (reInf != null) {
      return reInf.map((e) => _reInf[e],).whereType<ReadingInfo>().toSet();
    }
  }

  static List<dynamic>? _priorities(Set<String>? rePri,) {
    if (rePri != null) {
      final pris = <ReadingPriority>{};
      int? nf;
      final priorities = Map.fromEntries(
        ReadingPriority.values.map(
          (e) => MapEntry(describeEnum(e,), e,),
        ),
      );
      rePri.forEach(
        (pri) {
          if (_nfRegex.hasMatch(pri,)) {
            nf ??= int.parse(pri.substring(2, 4,),);
            pris.add(
              ReadingPriority.nf,
            );
          } else {
            final _pri = priorities[pri];
            if (_pri != null) {
              pris.add(_pri,);
            }
          }
        },
      );
      return [pris,nf,];
    }
  }

  /// This element content is restricted to kana and related
  /// characters such as chouon and kurikaeshi. Kana usage will be
  /// consistent between the keb and reb elements; e.g. if the [KanjiElement.element]
  /// contains katakana, so too will the [ReadingElement.element].
  ///
  /// Quoted from JMdict:109-112
  final String element;

  /// This element is used to indicate when the reading only applies
  /// to a subset of the [KanjiElement.element] elements in the entry. In its absence, all
  /// readings apply to all kanji elements. The contents of this element
  /// must exactly match those of one of the [KanjiElement.element] elements.
  ///
  /// Quoted from JMdict:122-125
  final Set<String>? readingRestrictions;

  /// General coded information pertaining to the specific reading.
  /// Typically it will be used to indicate some unusual aspect of
  /// the reading.
  ///
  /// Quoted from JMdict:128-130
  final Set<ReadingInfo>? information;

  /// See [KanjiElement.priorities]
  late final Set<ReadingPriority>? priorities;

  /// This element, which will usually have a null value, indicates
  /// that the reb, while associated with the [KanjiElement.element], cannot be regarded
  /// as a true reading of the kanji. It is typically used for words
  /// such as foreign place names, gairaigo which can be in kanji or
  /// katakana, etc.
  ///
  /// Quoted from JMdict:115-119
  /// Current implementation defaults to false when this element is not defined
  final bool noKanji;

  int? _nf;

  /// See [KanjiElement.frequencyOfUseRanking]
  int? get frequencyOfUseRanking => _nf;

  @override
  String toString() => element;

  /// Romaji reading of this element
  String get toRomaji => KanaKit().toRomaji(element,);
}

late final Map<String, SenseLanguage> _lang = Map.fromEntries(
  SenseLanguage.values.map(
    (e) => MapEntry(describeEnum(e,), e,),
  ),
);

SenseLanguage _language(String? lang,) {
  if (lang != null) {
    final sLang = _lang[lang];
    if (sLang != null) {
      return sLang;
    }
  }
  return SenseLanguage.eng;
}

/// This element records the information about the source
/// language(s) of a loan-word/gairaigo. If the source language is other
/// than English, the language is indicated by the [SenseLanguageSource.language] attribute.
/// The element value (if any) is the source word or phrase.
///
/// Quoted from JMdict:174-177
class SenseLanguageSource {

  SenseLanguageSource(this.source, String? lang, String? lsType, [this.isWasei = false,])
      : language = _language(lang,),
        type = _type(lsType,);

  static late final Map<String, SourceLanguageType> _lsType = Map.fromEntries(
    SourceLanguageType.values.map(
      (e) => MapEntry(describeEnum(e,), e,),
    ),
  );

  static SourceLanguageType _type(String? lsType,) {
    if (lsType != null) {
      final __type = _lsType[lsType];
      if (__type != null) {
        return __type;
      }
    }
    return SourceLanguageType.full;
  }

  /// The source word or phrase
  final String source;

  /// Defines the language(s) from which
  /// a loanword is drawn. It will be coded using the three-letter language
  /// code from the ISO 639-2 standard. When absent, the value [SenseLanguage.eng]
  /// (i.e. English) is the default value. The bibliographic (B) codes are used.
  ///
  /// Quoted from JMdict:180-183
  final SenseLanguage language;

  /// Indicates whether the lsource element
  /// fully or partially describes the source word or phrase of the
  /// loanword. If absent, it will have the implied value of [SourceLanguageType.full].
  /// Otherwise it will contain [SourceLanguageType.part].
  ///
  /// Quoted from JMdict:185-188
  final SourceLanguageType type;

  /// Indicates that the Japanese word
  /// has been constructed from words in the source language, and
  /// not from an actual phrase in that language. Most commonly used to
  /// indicate "waseieigo".
  ///
  /// Quoted from JMdict:190-193
  final bool isWasei;

  @override
  String toString() => "(${describeEnum(language,)}) $source";
}

/// Within each sense will be one or more "glosses", i.e.
/// target-language words or phrases which are equivalents to the
/// Japanese word. This element would normally be present, however it
/// may be omitted in entries which are purely for a cross-reference.
///
/// Quoted from JMdict:199-202
class SenseGlossary {

  SenseGlossary(this.text, String? lang, String? gType,)
      : language = _language(lang,),
        type = gType != null ? _gType[gType] : null;

  static late final Map<String, GlossaryType> _gType = Map<String, GlossaryType>.fromEntries(
    GlossaryType.values.map(
      (e) => MapEntry(describeEnum(e,), e,),
    ),
  );

  /// The words or phrase of the glossary
  final String text;

  /// Defines the target language of the glossary.
  /// It will be coded using the three-letter language code from
  /// the ISO 639 standard. When absent, the value [SenseLanguage.eng]
  /// (i.e. English) is the default value.
  ///
  /// Quoted from JMdict:205-208
  final SenseLanguage language;

  /// Specifies that the glossary is of a particular type
  /// See [GlossaryType]
  final GlossaryType? type;

  @override
  String toString() => "${describeEnum(language,)} $text";
}

/// The sense element will record the translational equivalent
/// of the Japanese word, plus other related information. Where there
/// are several distinctly different meanings of the word, multiple
/// sense elements will be employed.
///
/// Quoted from JMdict:135-138
class SenseElement {

  SenseElement(
      this.kanjiRestrictions,
      this.readingRestrictions,
      this.crossReferences,
      this.antonyms,
      Set<String>? pos,
      Set<String>? field,
      Set<String>? misc,
      this.information,
      Set<String>? lSource,
      Set<String>? dial,
      Set<String> gloss,
      )
      : partOfSpeeches = _partOfSpeeches(pos,),
        fields = _fields(field,),
        miscellaneous = _miscellaneous(misc,),
        dialects = _dialects(dial,),
        languageSources = _lSource(lSource,),
        glossaries = _glossaries(gloss,);

  static late final Map<String, PartOfSpeech> _pos = Map<String, PartOfSpeech>.fromEntries(
    PartOfSpeech.values.map(
      (e) => MapEntry(describeEnum(e,).replaceAll("_", "-"), e,),
    ),
  );

  static Set<PartOfSpeech>? _partOfSpeeches(Set<String>? pos,) {
    if (pos != null) {
      return Set<PartOfSpeech>.from(
        pos.map((e) => _pos[e],).whereType<PartOfSpeech>(),
      );
    }
  }

  static late final Map<String, SenseField> _field = Map<String, SenseField>.fromEntries(
    SenseField.values.map(
      (e) => MapEntry(describeEnum(e,), e,),
    ),
  );

  static Set<SenseField>? _fields(Set<String>? field,) {
    if (field != null) {
      return Set<SenseField>.from(
        field.map((e) => _field[e],).whereType<SenseField>(),
      );
    }
  }

  static late final Map<String, SenseMiscellaneous> _misc = Map<String, SenseMiscellaneous>.fromEntries(
    SenseMiscellaneous.values.map(
      (e) => MapEntry(describeEnum(e,).replaceAll("_", "-"), e,),
    ),
  );

  static Set<SenseMiscellaneous>? _miscellaneous(Set<String>? misc,) {
    if (misc != null) {
      return Set<SenseMiscellaneous>.from(
        misc.map((e) => _misc[e],).whereType<SenseMiscellaneous>(),
      );
    }
  }

  static late final Map<String, Dialect> _dial = Map<String, Dialect>.fromEntries(
    Dialect.values.map(
      (e) => MapEntry(describeEnum(e,), e,),
    ),
  );

  static Set<Dialect>? _dialects(Set<String>? dial,) {
    if (dial != null) {
      return Set<Dialect>.from(
        dial.map((e) => _dial[e],).whereType<Dialect>(),
      );
    }
  }

  static Set<SenseLanguageSource>? _lSource(Set<String>? lSource,) {
    if (lSource != null) {
      final languageSources = <SenseLanguageSource>{};
      for (String _lSource in lSource) {
        String? source;
        String? lang;
        String? lsType;
        bool isWasei = false;
        final lSourceSplit = _lSource.split(ATTR_DELIMITER,);
        for (String item in lSourceSplit) {
          if (item.indexOf("lang=") == 0) {
            lang ??= item.replaceFirst("lang=", "",);
          } else if (item.indexOf("type=") == 0) {
            lsType ??= item.replaceFirst("type=", "",);
          } else if (item == "_wasei_") {
            isWasei = true;
          } else if (item.isNotEmpty) {
            source ??= item;
          }
          if (source != null && lang != null && lsType != null && isWasei) {
            break;
          }
        }
        if (source != null) {
          languageSources.add(
            SenseLanguageSource(source, lang, lsType, isWasei,),
          );
        }
      }
      return languageSources;
    }
  }

  static Set<SenseGlossary> _glossaries(Set<String> gloss,) {
    final glossaries = <SenseGlossary>{};
    for (String _gloss in gloss) {
      String? text;
      String? lang;
      String? gType;
      final glossSplit = _gloss.split(ATTR_DELIMITER,);
      for (String item in glossSplit) {
        if (item.indexOf("lang=") == 0) {
          lang ??= item.replaceFirst("lang=", "",);
        } else if (item.indexOf("type=") == 0) {
          gType ??= item.replaceFirst("type=", "",);
        } else if (item.isNotEmpty) {
          text ??= item;
        }
        if (text != null && lang != null && gType != null) {
          break;
        }
      }
      if (text != null) {
        glossaries.add(
          SenseGlossary(text, lang, gType,),
        );
      }
    }
    return glossaries;
  }

  /// These elements, if present, indicate that the sense is restricted
  /// to the lexeme represented by the [KanjiElement.element] and/or [ReadingElement.element].
  ///
  /// Quoted from JMdict:142-143
  final Set<String>? kanjiRestrictions;
  final Set<String>? readingRestrictions;

  /// This element is used to indicate a cross-reference to another
  /// entry with a similar or related meaning or sense. The content of
  /// this element is typically a [KanjiElement.element] or
  /// [ReadingElement.element] element in another entry. In some
  /// cases a [KanjiElement.element] will be followed by a
  /// [ReadingElement.element] and/or a sense number to provide
  /// a precise target for the cross-reference. Where this happens, a JIS
  /// "centre-dot" (0x2126) is placed between the components of the
  /// cross-reference. The target [KanjiElement.element] or
  /// [ReadingElement.element] must not contain a centre-dot.
  ///
  /// Quoted from JMdict:145-151
  final Set<String>? crossReferences;

  /// This element is used to indicate another entry which is an
  /// antonym of the current [JMDictEntry]/[SenseElement]. The content of
  /// this element must exactly match that of a [KanjiElement.element] or
  /// [ReadingElement.element] in another entry.
  ///
  /// Quoted from JMdict:154-156
  final Set<String>? antonyms;

  /// Part-of-speech information about the [JMDictEntry]/[SenseElement]. Should use
  /// appropriate entity codes. In general where there are multiple senses
  /// in an entry, the part-of-speech of an earlier sense will apply to
  /// later [SenseElement]s unless there is a new part-of-speech indicated.
  ///
  /// Quoted from JMdict:159-162
  final Set<PartOfSpeech>? partOfSpeeches;

  /// Information about the field of application of the [JMDictEntry]/[SenseElement].
  /// When absent, general application is implied. Entity coding for
  /// specific fields of application.
  ///
  /// Quoted from JMdict:165-167
  final Set<SenseField>? fields;
  bool get isGeneral => fields?.isNotEmpty != true;

  /// This element is used for other relevant information about
  /// the [JMDictEntry]/[SenseElement]. As with part-of-speech,
  /// information will usually apply to several senses.
  ///
  /// Quoted from JMdict:169-171
  final Set<SenseMiscellaneous>? miscellaneous;

  /// The sense-information elements provided for additional
  /// information to be recorded about a [SenseElement]. Typical usage would
  /// be to indicate such things as level of currency of a sense, the
  /// regional variations, etc.
  ///
  /// Quoted from JMdict:225-228
  final Set<String>? information;

  /// This element records the information about the source
  /// language(s) of a loan-word/gairaigo. If the source language is other
  /// than English, the language is indicated by the [SenseLanguageSource.language] attribute.
  /// The [SenseLanguageSource.source] value (if any) is the source word or phrase.
  ///
  /// Quoted from JMdict:174-177
  final Set<SenseLanguageSource>? languageSources;

  /// For words specifically associated with regional dialects in
  /// Japanese, the entity code for that dialect, e.g. [Dialect.ksb] for Kansaiben.
  ///
  /// Quoted from JMdict:195-196
  final Set<Dialect>? dialects;

  /// See [SenseGlossary]
  final Set<SenseGlossary> glossaries;
}

/// Entries consist of kanji elements, reading elements,
/// general information and sense elements. Each entry must have at
/// least one reading element and one sense element. Others are optional.
///
/// Quoted from JMdict:37-39
abstract class JMDictEntry {

  /// A unique numeric sequence number for each entry (unsigned integer)
  int get entrySequence;

  /// An entry may or may not contains [KanjiElement]s
  Set<KanjiElement>? get kanjiElements;

  /// An entry must have at least one [ReadingElement]
  Set<ReadingElement> get readingElements;

  /// An entry must have at least one [SenseElement] with at least one [SenseGlossary]
  Set<SenseElement> get senseElements;
}