import 'package:kana_kit/kana_kit.dart';
import 'package:meta/meta.dart';
import 'constants.dart';
import 'utils.dart';
import 'package:objectbox/objectbox.dart';

import 'models.dart';

extension _IterableChecker<T> on Iterable<T> {

  List<T>? get nullIfEmpty => this.isEmpty ? null : this.toList(growable: false,);
}

extension _StringListDelimiter on Iterable<String> {

  String? get obJoin => this.nullIfEmpty?.join(DELIMITER,);

  String get obJoinNonNull => this.join(DELIMITER,);
}

final _htmlTrimRegex = RegExp(r"[&;]|(::)|(=>)|(&&)",);
final _delimiterTrimRegex = RegExp(r"(::)|(=>)|(&&)",);

extension _StringCleaner on String {

  String get trimHtml => this.replaceAll(_htmlTrimRegex, "",);
  String get trimDelimiter => this.replaceAll(_delimiterTrimRegex, "",);
}

@internal
@Entity()
class JMDictEntryImpl implements JMDictEntry {

  static KanaKit _kanaKit = KanaKit();

  @Id(assignable: true,)
  final int entSeq;

  @override
  @Transient()
  int get entrySequence => entSeq;
  ///
  /// Kanji
  ///
  final String? kanjiTexts;
  final String? kanjiInfo;
  final String? kanjiPriorities;

  @Transient()
  Set<KanjiElement>? _kanjiElements;

  @override
  @Transient()
  Set<KanjiElement>? get kanjiElements => _kanjiElements != null ? Set.unmodifiable(_kanjiElements!,) : null;

  static Map<int, Set<String>>? _parseMultiValue(String? data,) {
    if (data != null) {
      final map = <int, Set<String>>{};
      data.split(DELIMITER,).forEach(
        (entry) {
          final tokens = entry.split(IDX_DELIMITER,);
          if (tokens.length >= 2) {
            final index = int.tryParse(tokens[0],);
            if (index != null) {
              map[index] ??= {};
              map[index]?.add(tokens[1],);
            }
          }
        },
      );
      return map;
    }
  }

  void _prepareKanjiElements() {
    final keb = this.kanjiTexts?.split(DELIMITER,);
    if (keb != null) {
      final keInf = _parseMultiValue(this.kanjiInfo,);
      final kePri = _parseMultiValue(this.kanjiPriorities,);
      final kEle = <KanjiElement>{};
      for (int i = 0; i < keb.length; i++) {
        final element = keb[i];
        kEle.add(
          KanjiElement(
            element, keInf?[i], kePri?[i],
          ),
        );
      }
      _kanjiElements = kEle;
    }
  }

  ///
  /// Kana
  ///
  final String kanaTexts;
  final String romajiTexts;
  final List<int>? noKanjiInfo;
  final String? readingRestrictions;
  final String? readingInfo;
  final String? readingPriorities;

  @Transient()
  Set<ReadingElement>? _readingElements;

  @override
  @Transient()
  Set<ReadingElement> get readingElements => Set.unmodifiable(_readingElements ?? {},);

  void _prepareReadingElements() {
    final reb = this.kanaTexts.split(DELIMITER,);
    final rEle = <ReadingElement>{};
    final readingRestrictions = _parseMultiValue(this.readingRestrictions,);
    final reInf = _parseMultiValue(readingInfo,);
    final rePri = _parseMultiValue(readingPriorities,);
    for (int i = 0; i < reb.length; i++) {
      final element = reb[i];
      rEle.add(
        ReadingElement(element, readingRestrictions?[i], reInf?[i], rePri?[i], noKanjiInfo?.contains(i) == true,),
      );
    }
    _readingElements = rEle;
  }

  ///
  /// Sense
  ///
  final String glossaries;
  final String? kanjiSenseRestrictions;
  final String? readingSenseRestrictions;
  final String? crossReferences;
  final String? antonyms;
  final String? partOfSpeeches;
  final String? fields;
  final String? miscellaneous;
  final String? senseInfo;
  final String? sourceLanguages;
  final String? dialects;

  @Transient()
  Set<SenseElement>? _senseElements;

  @override
  @Transient()
  Set<SenseElement> get senseElements => Set.unmodifiable(_senseElements ?? {},);

  void _prepareSenseElements() {
    final senses = <SenseElement>{};
    final parsedGlossaries = _parseMultiValue(glossaries,);
    final stagK = _parseMultiValue(kanjiSenseRestrictions,);
    final stagR = _parseMultiValue(readingSenseRestrictions,);
    final xRef = _parseMultiValue(crossReferences,);
    final ant = _parseMultiValue(antonyms,);
    final pos = _parseMultiValue(partOfSpeeches,);
    final field = _parseMultiValue(fields,);
    final misc = _parseMultiValue(miscellaneous,);
    final sInf = _parseMultiValue(senseInfo,);
    final lSource = _parseMultiValue(sourceLanguages,);
    final dial = _parseMultiValue(dialects,);
    if (parsedGlossaries != null) {
      for (int i = 0; i < parsedGlossaries.length; i++) {
        final _gloss = parsedGlossaries[i];
        if (_gloss != null) {
          senses.add(
            SenseElement(
              stagK?[i],
              stagR?[i],
              xRef?[i],
              ant?[i],
              pos?[i],
              field?[i],
              misc?[i],
              sInf?[i],
              lSource?[i],
              dial?[i],
              _gloss,
            ),
          );
        }
      }
    }
    _senseElements = senses;
  }

  @internal
  JMDictEntryImpl({
    required this.entSeq,

    this.kanjiTexts,
    this.kanjiInfo,
    this.kanjiPriorities,

    required this.kanaTexts,
    required this.romajiTexts,
    this.noKanjiInfo,
    this.readingRestrictions,
    this.readingInfo,
    this.readingPriorities,

    required this.glossaries,
    this.kanjiSenseRestrictions,
    this.readingSenseRestrictions,
    this.crossReferences,
    this.antonyms,
    this.partOfSpeeches,
    this.fields,
    this.miscellaneous,
    this.senseInfo,
    this.sourceLanguages,
    this.dialects,
  }) {
    _prepareKanjiElements();
    _prepareReadingElements();
    _prepareSenseElements();
  }

  @internal
  static JMDictEntryImpl? map(Map<String, dynamic>? map,) {
    if (map != null) {
      dynamic entrySequence = map["ent_seq"];
      if (entrySequence != null && entrySequence is String) {
        entrySequence = int.tryParse(entrySequence,);
        if (entrySequence != null) {

          final List<Map<String, dynamic>> kanjiElements = map["k_ele"] ?? [];
          final kanjiTexts = <String>[];
          final kanjiInfo = <String>[];
          final kanjiPriority = <String>[];
          for (int i = 0; i < kanjiElements.length; i++) {
            final Map<String, dynamic> _element = kanjiElements[i];
            final String? keb = _element["keb"];
            if (keb != null) {
              kanjiTexts.add(keb,);
            } else { continue; }
            kanjiInfo.addAll(
              _element["ke_inf"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimHtml}",) ?? [],
            );
            kanjiPriority.addAll(
              _element["ke_pri"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimDelimiter}",) ?? [],
            );
          }

          final List<Map<String, dynamic>> readingElements = map["r_ele"] as List<Map<String, dynamic>>? ?? <Map<String, dynamic>>[];
          final readingTexts = <String>[];
          final romaji = <String>[];
          final noKanjiInfo = <int>{};
          final readingRestrictions = <String>[];
          final readingInfo = <String>[];
          final readingPriority = <String>[];
          for (int i = 0; i < readingElements.length; i++) {
            final _element = readingElements[i];
            final String? reb = _element["reb"];
            if (reb != null) {
              readingTexts.add(reb,);
              romaji.add(
                _kanaKit.toRomaji(reb,),
              );
            } else { continue; }
            if (_element["re_nokanji"] == true) {
              noKanjiInfo.add(i,);
            }
            readingRestrictions.addAll(
              _element["re_restr"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimDelimiter}",) ?? [],
            );
            readingInfo.addAll(
              _element["re_inf"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimHtml}",) ?? [],
            );
            readingPriority.addAll(
              _element["re_pri"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimDelimiter}",) ?? [],
            );
          }

          final List<Map<String, dynamic>> senses = map["sense"] as List<Map<String, dynamic>>? ?? <Map<String, dynamic>>[];
          final glosses = <String>[];
          final kanjiSenseRestrictions = <String>[];
          final readingSenseRestrictions = <String>[];
          final pos = <String>[];
          final xRef = <String>[];
          final ant = <String>[];
          final fields = <String>[];
          final misc = <String>[];
          final sInf = <String>[];
          final lSource = <String>[];
          final dialects = <String>[];
          for (int i = 0; i < senses.length; i++) {
            final Map<String, dynamic> _element = senses[i];
            final List<Map<String, String>>? gloss = _element["gloss"];
            glosses.addAll(
              gloss?.map(
                (Map<String, String> e) {
                  final String? lang = e["xml:lang"];
                  final String? type = e["g_type"];
                  final String text = e["text"]?.trimDelimiter ?? "";
                  return "$i$IDX_DELIMITER$text${lang != null ? "${ATTR_DELIMITER}lang=$lang" : ""}${type != null ? "${ATTR_DELIMITER}type=$type" : ""}";
                },
              ) ?? [],
            );
            kanjiSenseRestrictions.addAll(
              _element["stagk"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimDelimiter}",) ?? [],
            );
            readingSenseRestrictions.addAll(
              _element["stagr"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimDelimiter}",) ?? [],
            );
            pos.addAll(
              _element["pos"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimHtml}",) ?? [],
            );
            xRef.addAll(
              _element["xref"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimDelimiter}",) ?? [],
            );
            ant.addAll(
              _element["ant"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimDelimiter}",) ?? [],
            );
            fields.addAll(
              _element["field"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimHtml}",) ?? [],
            );
            misc.addAll(
              _element["misc"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimHtml}",) ?? [],
            );
            sInf.addAll(
              _element["s_inf"]?.map<String>((String e) => "$i$IDX_DELIMITER${e.trimDelimiter}",) ?? [],
            );
            final List<Map<String, String>>? _lSource = _element["lsource"];
            lSource.addAll(
              _lSource?.map(
                (Map<String, String> e) {
                  final String? lang = e["xml:lang"];
                  final String? type = e["ls_type"];
                  final isWasei = e["ls_wasei"] != null;
                  final text = e["text"]?.trimDelimiter ?? "";
                  return "$i$IDX_DELIMITER$text${lang != null ? "${ATTR_DELIMITER}lang=$lang" : ""}${type != null ? "${ATTR_DELIMITER}type=$type" : ""}${isWasei ? "${ATTR_DELIMITER}_wasei_" : ""}";
                },
              ) ?? [],
            );
            final List<String>? _dial = _element["dial"];
            dialects.addAll(
              _dial?.map((String e) => "$i$IDX_DELIMITER${e.trimHtml}",) ?? [],
            );
          }

          return JMDictEntryImpl(
            entSeq: entrySequence,

            kanjiTexts: kanjiTexts.obJoin,
            kanjiInfo: kanjiInfo.obJoin,
            kanjiPriorities: kanjiPriority.obJoin,

            kanaTexts: readingTexts.obJoinNonNull,
            romajiTexts: romaji.obJoinNonNull,
            noKanjiInfo: noKanjiInfo.toList().nullIfEmpty,
            readingRestrictions: readingRestrictions.obJoin,
            readingInfo: readingInfo.obJoin,
            readingPriorities: readingPriority.obJoin,

            glossaries: glosses.obJoinNonNull,
            kanjiSenseRestrictions: kanjiSenseRestrictions.obJoin,
            readingSenseRestrictions: readingSenseRestrictions.obJoin,
            partOfSpeeches: pos.obJoin,
            crossReferences: xRef.obJoin,
            antonyms: ant.obJoin,
            fields: fields.obJoin,
            miscellaneous: misc.obJoin,
            senseInfo: sInf.obJoin,
            sourceLanguages: lSource.obJoin,
            dialects: dialects.obJoin,
          );
        } else {
          JMDictLogUtils.log(
            "Unable to locate entry sequence",
          );
        }
      }
    }
  }
}