import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:jm_dict/objectbox.g.dart';
import 'package:jm_dict/src/entities.dart';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jm_dict/src/utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:xml/xml_events.dart';

List<int>? _getDictionaryFile(Uint8List bytes,) {
  return GZipDecoder().decodeBytes(bytes, verify: true,);
}

Future<File?> _unarchive(Uint8List bytes,) async {
  final dictFile = await compute<Uint8List, List<int>?>(
    _getDictionaryFile,
    bytes,
  );
  if (dictFile != null) {
    final dir = await getTemporaryDirectory();
    File file = File("${dir.uri.toFilePath()}JMdict",);
    return file.writeAsBytes(
      Uint8List.fromList(dictFile,),
    );
  }
}

class JMDictLoader {

  bool _popAndInsert(List<JMDictEntryImpl> entries, Store store,) {
    JMDictLogUtils.log(
      "Writing ${entries.length} items...",
    );
    final start = DateTime.now();
    final ids = store.box<JMDictEntryImpl>().putMany(entries,);
    final end = DateTime.now();
    final elapsedTime = (end.difference(start,).inMilliseconds.abs()) / 1000;
    final isInserted = ids.isNotEmpty;
    if (isInserted) {
      JMDictLogUtils.log(
        "Written ${entries.length} entries ($elapsedTime seconds)",);
    }
    entries.clear();
    return isInserted;
  }

  bool _isLoading = false;

  String _handleStartElementEvent(XmlStartElementEvent event, Map<String, dynamic> entry,) {
    final name = event.name;
    if (name == "JMdict") {
      _isLoading = true;
      return name;
    }
    if (!_isLoading) {
      JMDictLogUtils.log(
        "Skipping <$name>, no JMdict Element found yet.",
      );
      return name;
    }
    switch (name) {
      case "entry":
        entry.clear();
        break;
      case "k_ele":
        entry["k_ele"] ??= <Map<String, dynamic>>[];
        (entry["k_ele"] as List).add(<String, dynamic>{},);
        break;
      case "r_ele":
        entry["r_ele"] ??= <Map<String, dynamic>>[];
        (entry["r_ele"] as List).add(<String, dynamic>{},);
        break;
      case "sense":
        entry["sense"] ??= <Map<String, dynamic>>[];
        (entry["sense"] as List).add(<String, dynamic>{},);
        break;
      case "re_nokanji":
        entry["r_ele"].last["re_nokanji"] = true;
        break;
      case "lsource":
      case "gloss":
        final Map<String, dynamic> sense = entry["sense"].last;
        final attributes = event.attributes;
        final map = <String, String>{};
        attributes.forEach((attribute) {
          map[attribute.name] = attribute.value;
        },);

        sense[name] ??= <Map<String, String>>[];
        sense[name].add(map,);
        break;
    }
    return name;
  }

  void _insertToList(String text, Map<String, dynamic> entry, String name,) {
    entry[name] ??= <String>[];
    final list = entry[name];
    if (list is List<String>) {
      list.add(text,);
    }
  }

  void _handleTextEvent(XmlTextEvent event, Map<String, dynamic> entry,) {
    if (!_isLoading) {
      return;
    }
    final parentEvent = event.parent;
    if (parentEvent != null) {
      final text = event.text;
      final name = parentEvent.name;
      switch (name) {
        case "ent_seq":
          entry["ent_seq"] = text;
          break;
        case "keb":
          (entry["k_ele"] as List<Map<String, dynamic>>).last["keb"] = text;
           break;
        case "ke_inf":
        case "ke_pri":
          _insertToList(text, entry["k_ele"].last, name,);
          break;
        case "reb":
          (entry["r_ele"] as List<Map<String, dynamic>>).last["reb"] = text;
          break;
        case "re_restr":
        case "re_inf":
        case "re_pri":
          _insertToList(text, entry["r_ele"].last, name,);
          break;
        case "stagk":
        case "stagr":
        case "pos":
        case "xref":
        case "ant":
        case "field":
        case "misc":
        case "s_inf":
        case "dial":
          _insertToList(text, entry["sense"].last, name,);
          break;
        case "lsource":
        case "gloss":
          final List<Map<String, dynamic>> lg = entry["sense"].last[name];
          lg.last["text"] = text;
         break;
      }
    }
  }

  int _handleEndElementEvent(XmlEndElementEvent event, Map<String, dynamic> entry,) {
    if (event.name == "entry") {
      return 0;
    } else if (event.name == "JMdict") {
      _isLoading = false;
      JMDictLogUtils.log("End of JMdict reached",);
      return 1;
    }
    return -1;
  }

  Future<void> load(File xmlFile, Store store,) async {
    final entries = <JMDictEntryImpl>[];
    Map<String, dynamic> entry = {};
    final start = DateTime.now();
    JMDictLogUtils.log("Begin reading xml...",);
    await xmlFile
        .openRead()
        .transform(utf8.decoder,)
        .toXmlEvents()
        .normalizeEvents()
        .withParentEvents()
        .forEachEvent(
      onStartElement: (event) {
        _handleStartElementEvent(event, entry,);
      },
      onText: (event) {
        _handleTextEvent(event, entry,);
      },
      onEndElement: (event) {
        final resultCode = _handleEndElementEvent(event, entry,);
        if (resultCode == 0) {
          final dictEntry = JMDictEntryImpl.map(entry,);
          if (dictEntry != null) {
            entries.add(dictEntry,);
            JMDictLogUtils.log(
              "Processed entry #${dictEntry.entrySequence}",
            );
            if (entries.length == 1000) {
              _popAndInsert(entries, store,);
            }
          }
        }
      },
    );
    _popAndInsert(entries, store,);
    final end = DateTime.now();
    final elapsedTime = (end.difference(start,).inMilliseconds.abs()) / 1000;
    JMDictLogUtils.log("JMdict loaded in $elapsedTime seconds",);
  }

  Future<void> loadFromAsset(String assetPath, Store store,) async {
    final gz = await rootBundle.load(assetPath,);
    final file = await _unarchive(
      gz.buffer.asUint8List(),
    );
    if (file != null) {
      await load(file, store,);
    }
  }
}

class _JMDictDownloader {

  static const _LATEST_FILE_URL = "http://ftp.edrdg.org/pub/Nihongo/JMdict.gz";
  static String? _fileUrl;

  final int? timeout;

  _JMDictDownloader(this.timeout, [String? fileUrl,]) {
    _fileUrl = fileUrl;
  }

  static void processDownload(Map<String, dynamic> message,) {
    final SendPort sendPort = message["sendPort"];
    final int? timeout = message["timeout"];
    final String path = message["path"];

    FutureOr<Null> _handleError(dynamic e,) {
      sendPort.send(
        <String, String?>{
          "error": e.runtimeType.toString(),
          "message": e.toString().replaceAll(e.runtimeType.toString(), "",),
          "stackTrace": e is Error ? e.stackTrace?.toString() : "",
        },
      );
    }

    HttpClient().getUrl(
      Uri.parse(_fileUrl ?? _LATEST_FILE_URL,),
    ).then(
      (request) {
        (timeout != null ? request.close().timeout(Duration(seconds: timeout,),) : request.close()).then(
          (response) {
            final tempFile = File(path,);
            if (!tempFile.existsSync()) {
              tempFile.createSync();
            }
            response.pipe(
              tempFile.openWrite(),
            ).then((_) {
              sendPort.send(
                tempFile.readAsBytesSync(),
              );
              // sendPort.send(tempFile.path,);
            },).catchError(_handleError,);
          },
        ).catchError(_handleError,);
      },
    );
  }

  Future<Uint8List?> download() async {
    final completer = Completer<Uint8List?>();
    final receivePort = ReceivePort();
    final gzPath = "${(await getTemporaryDirectory()).uri.toFilePath()}JMdict.gz";
    JMDictLogUtils.debugLog("Downloading into $gzPath...",);
    Isolate.spawn<Map<String, dynamic>>(
      processDownload,
      {
        "sendPort": receivePort.sendPort,
        "timeout": this.timeout,
        "path": gzPath,
      },
    );
    late StreamSubscription downloadListener;
    downloadListener = receivePort.listen(
      (message) {
        if (!completer.isCompleted) {
          if (message is Uint8List) {
            JMDictLogUtils.log("Download completed",);
            completer.complete(message,);
          } else {
            completer.completeError(message.toString(),);
          }
          downloadListener.cancel();
        }
      },
    );
    return completer.future;
  }
}

class JMDictUpdater {

  static Future<Uint8List?> _downloadAndProcessLatestFile(int? timeout, [String? downloadUrl,]) async {
    return _JMDictDownloader(timeout, downloadUrl,).download();
  }

  Future<bool> update({
    required JMDictLoader loader,
    required Store store,
    String? alternativeDownloadUrl,
    int? timeout,
  }) async {
    final archivedBytes = await _downloadAndProcessLatestFile(
      timeout,
      alternativeDownloadUrl,
    );
    if (archivedBytes != null) {
      JMDictLogUtils.log("Unarchiving JMdict.gz...",);
      final dictFile = await _unarchive(archivedBytes,);
      if (dictFile != null) {
        JMDictLogUtils.log("Loading downloaded JMdict.gz...",);
        await loader.load(dictFile, store,);
        return true;
      }
    }
    return false;
  }
}