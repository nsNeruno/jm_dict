import 'package:flutter/material.dart';
import 'package:jm_dict/jm_dict.dart';
import 'package:loading_alert_dialog/loading_alert_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LoadingAlertDialog.setDefaultWidgetBuilder(
    (context) => const Center(
      child: CircularProgressIndicator.adaptive(),
    ),
  );
  runApp(const JMDictDemoApp(),);
}

class JMDictDemoApp extends StatelessWidget {

  const JMDictDemoApp({Key? key,}): super(key: key,);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JMDictDemoPage(),
    );
  }
}

class JMDictDemoPage extends StatelessWidget {

  const JMDictDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("JMDict Mobile",),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                LoadingAlertDialog.showLoadingAlertDialog(
                  context: context,
                  computation: JMDict().initFromAsset(
                    assetPath: "assets/raw/JMdict.gz",
                  ),
                );
              },
              child: const Text("Init Local",),
            ),
            ElevatedButton(
              onPressed: () {
                LoadingAlertDialog.showLoadingAlertDialog(
                  context: context,
                  computation: JMDict().initFromNetwork(
                    forceUpdate: true,
                  ),
                );
              },
              child: const Text("Init Network",),
            ),
            ElevatedButton(
              onPressed: () {
                if (JMDict().isNotEmpty) {
                  Navigator.of(context,).push(
                    MaterialPageRoute(
                      builder: (_) => const JMDictDemoSearchPage(),
                    ),
                  );
                }
              },
              child: const Text("Go to Search",),
            ),
          ],
        ),
      ),
    );
  }
}

class JMDictDemoSearchPage extends StatefulWidget {

  const JMDictDemoSearchPage({Key? key}) : super(key: key);

  @override
  State<JMDictDemoSearchPage> createState() => _JMDictDemoSearchPageState();
}

class _JMDictDemoSearchPageState extends State<JMDictDemoSearchPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Demo",),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0,),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search",
                prefixIcon: Icon(Icons.search,),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) {
                FocusScope.of(context,).unfocus();
                _search();
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              separatorBuilder: (_, __,) => const SizedBox(
                width: double.infinity,
                child: Divider(
                  height: 1.0,
                ),
              ),
              itemBuilder: (_, index,) {
                final result = _searchResult?[index];
                if (result != null) {
                  return _DictEntry(
                    entry: result,
                  );
                }
                return Container();
              },
              itemCount: _searchResult?.length ?? 0,
            ),
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _search() {
    final keyword = searchController.text;
    if (keyword.isNotEmpty) {
      setState(() {
        _searchResult = JMDict().search(keyword: keyword, limit: 100,);
      });
    }
  }

  late final searchController = TextEditingController();

  List<JMDictEntry>? _searchResult;
}

class _DictEntry extends StatelessWidget {

  final JMDictEntry entry;

  const _DictEntry({Key? key, required this.entry,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final kanjiElements = entry.kanjiElements;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0,),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          kanjiElements != null ? SizedBox(
            width: double.infinity,
            child: Text(
              kanjiElements.map((e) => e.element,).join(", ",),
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ) : Container(),
          SizedBox(
            width: double.infinity,
            child: Text(
              entry.readingElements.map((e) => e.element,).join(", ",),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              entry.senseElements.map(
                (e) => e.glossaries.map((e) => e.text,).join(", ",),
              ).join(", ",),
            ),
          ),
        ],
      ),
    );
  }
}