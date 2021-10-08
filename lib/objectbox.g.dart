// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'src/entities.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 5895155159702023710),
      name: 'JMDictEntryImpl',
      lastPropertyId: const IdUid(20, 2847522676703792946),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 4556635360748609234),
            name: 'entSeq',
            type: 6,
            flags: 129),
        ModelProperty(
            id: const IdUid(2, 8850298636454433633),
            name: 'kanjiTexts',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3218597854944474342),
            name: 'kanjiInfo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 973845293046916820),
            name: 'kanjiPriorities',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 7621751207634904144),
            name: 'kanaTexts',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 2727289413458210334),
            name: 'romajiTexts',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 2471675354972544902),
            name: 'readingRestrictions',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(8, 8612883416310561671),
            name: 'readingInfo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(9, 2001848516641193630),
            name: 'readingPriorities',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(10, 1593604051266556830),
            name: 'glossaries',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(11, 6530649734976684893),
            name: 'kanjiSenseRestrictions',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(12, 5661613116726740451),
            name: 'readingSenseRestrictions',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(13, 1962002477115001886),
            name: 'crossReferences',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(14, 7285819227342349623),
            name: 'antonyms',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(15, 3644624740124513866),
            name: 'partOfSpeeches',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(16, 4581524987165470681),
            name: 'fields',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(17, 3463111275484677886),
            name: 'miscellaneous',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(18, 2064373312976902866),
            name: 'senseInfo',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(19, 7932172145512563623),
            name: 'sourceLanguages',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(20, 2847522676703792946),
            name: 'dialects',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(1, 5895155159702023710),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    JMDictEntryImpl: EntityDefinition<JMDictEntryImpl>(
        model: _entities[0],
        toOneRelations: (JMDictEntryImpl object) => [],
        toManyRelations: (JMDictEntryImpl object) => {},
        getId: (JMDictEntryImpl object) => object.entSeq,
        setId: (JMDictEntryImpl object, int id) {
          if (object.entSeq != id) {
            throw ArgumentError('Field JMDictEntryImpl.entSeq is read-only '
                '(final or getter-only) and it was declared to be self-assigned. '
                'However, the currently inserted object (.entSeq=${object.entSeq}) '
                "doesn't match the inserted ID (ID $id). "
                'You must assign an ID before calling [box.put()].');
          }
        },
        objectToFB: (JMDictEntryImpl object, fb.Builder fbb) {
          final kanjiTextsOffset = object.kanjiTexts == null
              ? null
              : fbb.writeString(object.kanjiTexts!);
          final kanjiInfoOffset = object.kanjiInfo == null
              ? null
              : fbb.writeString(object.kanjiInfo!);
          final kanjiPrioritiesOffset = object.kanjiPriorities == null
              ? null
              : fbb.writeString(object.kanjiPriorities!);
          final kanaTextsOffset = fbb.writeString(object.kanaTexts);
          final romajiTextsOffset = fbb.writeString(object.romajiTexts);
          final readingRestrictionsOffset = object.readingRestrictions == null
              ? null
              : fbb.writeString(object.readingRestrictions!);
          final readingInfoOffset = object.readingInfo == null
              ? null
              : fbb.writeString(object.readingInfo!);
          final readingPrioritiesOffset = object.readingPriorities == null
              ? null
              : fbb.writeString(object.readingPriorities!);
          final glossariesOffset = fbb.writeString(object.glossaries);
          final kanjiSenseRestrictionsOffset =
              object.kanjiSenseRestrictions == null
                  ? null
                  : fbb.writeString(object.kanjiSenseRestrictions!);
          final readingSenseRestrictionsOffset =
              object.readingSenseRestrictions == null
                  ? null
                  : fbb.writeString(object.readingSenseRestrictions!);
          final crossReferencesOffset = object.crossReferences == null
              ? null
              : fbb.writeString(object.crossReferences!);
          final antonymsOffset = object.antonyms == null
              ? null
              : fbb.writeString(object.antonyms!);
          final partOfSpeechesOffset = object.partOfSpeeches == null
              ? null
              : fbb.writeString(object.partOfSpeeches!);
          final fieldsOffset =
              object.fields == null ? null : fbb.writeString(object.fields!);
          final miscellaneousOffset = object.miscellaneous == null
              ? null
              : fbb.writeString(object.miscellaneous!);
          final senseInfoOffset = object.senseInfo == null
              ? null
              : fbb.writeString(object.senseInfo!);
          final sourceLanguagesOffset = object.sourceLanguages == null
              ? null
              : fbb.writeString(object.sourceLanguages!);
          final dialectsOffset = object.dialects == null
              ? null
              : fbb.writeString(object.dialects!);
          fbb.startTable(21);
          fbb.addInt64(0, object.entSeq);
          fbb.addOffset(1, kanjiTextsOffset);
          fbb.addOffset(2, kanjiInfoOffset);
          fbb.addOffset(3, kanjiPrioritiesOffset);
          fbb.addOffset(4, kanaTextsOffset);
          fbb.addOffset(5, romajiTextsOffset);
          fbb.addOffset(6, readingRestrictionsOffset);
          fbb.addOffset(7, readingInfoOffset);
          fbb.addOffset(8, readingPrioritiesOffset);
          fbb.addOffset(9, glossariesOffset);
          fbb.addOffset(10, kanjiSenseRestrictionsOffset);
          fbb.addOffset(11, readingSenseRestrictionsOffset);
          fbb.addOffset(12, crossReferencesOffset);
          fbb.addOffset(13, antonymsOffset);
          fbb.addOffset(14, partOfSpeechesOffset);
          fbb.addOffset(15, fieldsOffset);
          fbb.addOffset(16, miscellaneousOffset);
          fbb.addOffset(17, senseInfoOffset);
          fbb.addOffset(18, sourceLanguagesOffset);
          fbb.addOffset(19, dialectsOffset);
          fbb.finish(fbb.endTable());
          return object.entSeq;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = JMDictEntryImpl(
              entSeq:
                  const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0),
              kanjiTexts: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 6),
              kanjiInfo: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 8),
              kanjiPriorities: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 10),
              kanaTexts:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 12, ''),
              romajiTexts:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 14, ''),
              readingRestrictions: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 16),
              readingInfo: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 18),
              readingPriorities: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 20),
              glossaries:
                  const fb.StringReader().vTableGet(buffer, rootOffset, 22, ''),
              kanjiSenseRestrictions: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 24),
              readingSenseRestrictions: const fb.StringReader()
                  .vTableGetNullable(buffer, rootOffset, 26),
              crossReferences: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 28),
              antonyms: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 30),
              partOfSpeeches: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 32),
              fields: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 34),
              miscellaneous: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 36),
              senseInfo: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 38),
              sourceLanguages: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 40),
              dialects: const fb.StringReader().vTableGetNullable(buffer, rootOffset, 42));

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [JMDictEntryImpl] entity fields to define ObjectBox queries.
class JMDictEntryImpl_ {
  /// see [JMDictEntryImpl.entSeq]
  static final entSeq =
      QueryIntegerProperty<JMDictEntryImpl>(_entities[0].properties[0]);

  /// see [JMDictEntryImpl.kanjiTexts]
  static final kanjiTexts =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[1]);

  /// see [JMDictEntryImpl.kanjiInfo]
  static final kanjiInfo =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[2]);

  /// see [JMDictEntryImpl.kanjiPriorities]
  static final kanjiPriorities =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[3]);

  /// see [JMDictEntryImpl.kanaTexts]
  static final kanaTexts =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[4]);

  /// see [JMDictEntryImpl.romajiTexts]
  static final romajiTexts =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[5]);

  /// see [JMDictEntryImpl.readingRestrictions]
  static final readingRestrictions =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[6]);

  /// see [JMDictEntryImpl.readingInfo]
  static final readingInfo =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[7]);

  /// see [JMDictEntryImpl.readingPriorities]
  static final readingPriorities =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[8]);

  /// see [JMDictEntryImpl.glossaries]
  static final glossaries =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[9]);

  /// see [JMDictEntryImpl.kanjiSenseRestrictions]
  static final kanjiSenseRestrictions =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[10]);

  /// see [JMDictEntryImpl.readingSenseRestrictions]
  static final readingSenseRestrictions =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[11]);

  /// see [JMDictEntryImpl.crossReferences]
  static final crossReferences =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[12]);

  /// see [JMDictEntryImpl.antonyms]
  static final antonyms =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[13]);

  /// see [JMDictEntryImpl.partOfSpeeches]
  static final partOfSpeeches =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[14]);

  /// see [JMDictEntryImpl.fields]
  static final fields =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[15]);

  /// see [JMDictEntryImpl.miscellaneous]
  static final miscellaneous =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[16]);

  /// see [JMDictEntryImpl.senseInfo]
  static final senseInfo =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[17]);

  /// see [JMDictEntryImpl.sourceLanguages]
  static final sourceLanguages =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[18]);

  /// see [JMDictEntryImpl.dialects]
  static final dialects =
      QueryStringProperty<JMDictEntryImpl>(_entities[0].properties[19]);
}
