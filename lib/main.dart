import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Text File Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Simple Text Storage App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controlText = TextEditingController();
  final TextEditingController _controlLongText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                controller: _controlText,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton.filled(
                      onPressed: () async {
                        String? path;
                        try {
                          path = await FilePicker.platform.getDirectoryPath();
                          _controlText.text = path!;
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                        try {
                          var dir = Directory(path!);
                          var dirList = dir.list();
                          await for (final FileSystemEntity f in dirList) {
                            if (f is File) {
                              debugPrint('Found file ${f.path}');
                              var extension = p.extension(f.path); // '.dart'
                              debugPrint(extension);
                            } else if (f is Directory) {
                              debugPrint('Found dir ${f.path}');
                            }
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      },
                      child: Text('Browse')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton.filled(
                      child: Text('Open File'),
                      onPressed: () async {
                        String? path;
                        FilePickerResult? targetFile;
                        try {
                          targetFile = await FilePicker.platform.pickFiles();
                          File _file = File(targetFile!.paths[0]!);
                          _controlLongText.text = await _file.readAsString();
                          _controlText.text = _file.path;
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                        try {
                          var dir = Directory(path!);
                          var dirList = dir.list();
                          await for (final FileSystemEntity f in dirList) {
                            if (f is File) {
                              debugPrint('Found file ${f.path}');
                              var extension = p.extension(f.path); // '.dart'
                              debugPrint(extension);
                            } else if (f is Directory) {
                              debugPrint('Found dir ${f.path}');
                            }
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoButton.filled(
                      child: Text('Save File'),
                      onPressed: () async {
                        String? path;
                        FilePickerResult? targetFile;
                        try {
                          path = await FilePicker.platform.saveFile(
                              allowedExtensions: ['.txt'],
                              type: FileType.custom,
                              fileName: 'untitled.txt');
                          // final Directory dir = Directory(path!);
                          final File file = File(path!);
                          await file.writeAsString(_controlLongText.text);
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                        try {
                          var dir = Directory(path!);
                          var dirList = dir.list();
                          await for (final FileSystemEntity f in dirList) {
                            if (f is File) {
                              debugPrint('Found file ${f.path}');
                              var extension = p.extension(f.path); // '.dart'
                              debugPrint(extension);
                            } else if (f is Directory) {
                              debugPrint('Found dir ${f.path}');
                            }
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                      }),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300),
                child: CupertinoTextField(
                  maxLines: 500,
                  controller: _controlLongText,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

bool isTxt(String str) {
  if (str == '.txt') {
    return true;
  }
  return false;
}
