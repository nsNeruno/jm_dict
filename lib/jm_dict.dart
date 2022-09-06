library jm_dict;

import 'dart:io';

import 'package:jm_dict/objectbox.g.dart';
import 'package:jm_dict/src/entities.dart';
import 'package:jm_dict/src/loader.dart';
import 'package:jm_dict/src/models.dart';
import 'package:jm_dict/src/seeker.dart';
import 'package:jm_dict/src/utils.dart';
import 'package:path_provider/path_provider.dart';

export 'src/enums.dart';
export 'src/models.dart';

class JMDict {

  JMDict._();

  static late final JMDict _instance = JMDict._();

  factory JMDict() => _instance;

  bool _isInitialized = false;
  bool _isLoading = false;
  late Store _store;

  late JMDictSeeker _seeker = JMDictSeeker();
  late JMDictLoader _loader = JMDictLoader();
  late JMDictUpdater _updater = JMDictUpdater();

  void _warnAlreadyInitialized() {
    JMDictLogUtils.log("JMDict already initialized",);
  }

  void _warnNotInitialized() {
    JMDictLogUtils.log("JMDict not initialized yet",);
  }

  bool _checkInit() {
    if (!_isInitialized) {
      _warnNotInitialized();
    }
    return _isInitialized;
  }

  /// Load pre-existing JMdict.gz file from existing Flutter [assetPath]
  ///
  /// Enabling [forceUpdate] will append/update into existing local Database
  /// if exists
  Future<void> initFromAsset({required String assetPath, bool forceUpdate = false,}) async {
    if (_isInitialized || _isLoading) {
      _warnAlreadyInitialized();
      return;
    }
    _isLoading = true;
    try {
      final store = await openStore();
      final box = store.box<JMDictEntryImpl>();
      if (box.isEmpty() || !box.isEmpty() && forceUpdate) {
        await _load(assetPath, store,);
      }
      _store = store;
      _isInitialized = true;
    } catch (err) {
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  /// Load using JMdict XML file
  ///
  /// [xmlFile] references to existing, accessible JMdict file (extracted from
  /// JMDict.gz, a valid XML file)
  /// Enabling [forceUpdate] will append/update into existing local Database
  /// if exists
  Future<void> initFromFile({required File xmlFile, bool forceUpdate = false,}) async {
    if (_isInitialized || _isLoading) {
      _warnAlreadyInitialized();
      return;
    }
    _isLoading = true;
    final store = await openStore();
    final box = store.box<JMDictEntryImpl>();
    if (await xmlFile.exists()) {
      if (box.isEmpty() || !box.isEmpty() && forceUpdate) {
        await _loader.load(xmlFile, store,);
      }
    } else {
      _isInitialized = false;
      _isLoading = false;
      return;
    }
    _store = store;
    _isInitialized = true;
    _isLoading = false;
  }

  /// Load from downloaded JMdict.gz file
  ///
  /// Defaults to downloading JMdict.gz file from http://ftp.edrdg.org/pub/Nihongo/JMdict.gz
  /// Enabling [forceUpdate] will append/update into existing local Database
  /// if exists
  /// No [timeout] is enforced during the download process by default.
  /// The [timeout] itself is represented in seconds.
  Future<void> initFromNetwork({
    Uri? archiveUri,
    bool forceUpdate = false,
    int? timeout,
  }) async {
    if (_isInitialized || _isLoading) {
      _warnAlreadyInitialized();
      return;
    }
    _isLoading = true;
    final store = await openStore();
    final box = store.box<JMDictEntryImpl>();
    if (box.isEmpty() || (!box.isEmpty() && forceUpdate)) {
      await _updater.update(
        loader: _loader,
        store: store,
        alternativeDownloadUrl: archiveUri?.toString(),
        timeout: timeout,
      );
    }
    _store = store;
    _isInitialized = true;
    _isLoading = false;
  }

  /// Search the local database for [JMDictEntry]s that contain [keyword] in
  /// kana reading, romaji reading, or the glossaries, and also include Kanji
  /// search
  ///
  /// A clear [limit] may be provided to limit search results.
  /// For paging purpose, [offset] may be provided to get results after skipping
  /// a certain amount of entries.
  /// For a better performance, it is recommended to provide both [limit] and [offset].
  ///
  /// Returns either null if the local [Store] is not initialized, or a [List]
  /// of [JMDictEntry].
  List<JMDictEntry>? search({
    required String keyword,
    int? limit,
    int? offset,
  }) {
    if (!_checkInit()) {
      return null;
    }
    return _seeker.search(
      keyword: keyword,
      store: _store,
      limit: limit,
      offset: offset,
    );
  }

  Future<void> _load(String assetPath, Store store,) async {
    await _loader.loadFromAsset(assetPath, store,);
  }

  /// Updates current database by downloading a new JMdict.gz file.
  /// Defaults to downloading JMdict.gz file from http://ftp.edrdg.org/pub/Nihongo/JMdict.gz
  ///
  /// Provide another [archiveUri] if downloading from another source.
  /// [archiveUri] must point to a downloadable JMdict.gz file.
  /// It is optional to apply download [timeout] in seconds.
  Future<bool> update({
    Uri? archiveUri,
    int? timeout,
  }) async {
    if (!_checkInit() || _isLoading) {
      _warnNotInitialized();
      return false;
    }
    _isLoading = true;
    try {
      return _updater.update(
        loader: _loader,
        store: _store,
        alternativeDownloadUrl: archiveUri?.toString(),
        timeout: timeout,
      );
    } catch (ex) {
      return false;
    } finally {
      _isLoading = false;
    }
  }

  /// Returns true if [Store] has not been initialized or is empty
  bool get isEmpty {
    if (_checkInit()) {
      return _store.box<JMDictEntryImpl>().isEmpty();
    }
    return true;
  }

  bool get isNotEmpty => !isEmpty;

  /// Closes the [Store]
  void close() {
    if (_isInitialized) {
      _store.close();
      _isInitialized = false;
    }
  }

  /// Call this manually to remove any lingering JMdict or JMdict.gz files inside
  /// the device's temporary directory
  void removeCachedFiles() async {
    final tmpDir = await getTemporaryDirectory();
    final tmpPath = tmpDir.uri.toFilePath();
    ["JMdict", "JMdict.gz",].map(
      (fileName) => File("$tmpPath$fileName",),
    ).map(
      (file) => Future<void>(
        () async {
          if (await file.exists()) {
            file.delete();
          }
        },
      ),
    );
  }
}