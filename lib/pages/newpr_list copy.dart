import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pruksa/models/newspr_model.dart';
import 'package:pruksa/utility/my_constant.dart';
import 'package:pruksa/wigets/check_permission.dart';
import 'package:pruksa/wigets/directory_path.dart';

class NewPrList extends StatefulWidget {
  const NewPrList({Key? key}) : super(key: key);

  @override
  State<NewPrList> createState() => _NewPrListState();
}

class _NewPrListState extends State<NewPrList> {
  bool load = true;
  bool? haveData;
  List<NewsprModel> newsmodels = [];
  bool isPermission = false;
  var checkAllPermissions = CheckPermission();

  checkPermission() async {
    var permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadvaluefromapi();
    checkPermission();
    // initialFile();
  }

  Future<Null> loadvaluefromapi() async {
    if (newsmodels.length != 0) {
      newsmodels.clear();
    } else {}

    String apigetactivelist =
        '${MyConstant.domain}/dopa/api/getnewspr.php?isAdd=true';
    await Dio().get(apigetactivelist).then((value) {
      print('value ==> $value');
      // print('value ==> $id');
      if (value.toString() == 'null') {
        // No Data
        setState(() {
          load = false;
          haveData = false;
        });
      } else {
        for (var item in json.decode(value.data)) {
          NewsprModel model = NewsprModel.fromMap(item);
          print('name of titel =${model.book_name}');

          setState(() {
            load = false;
            haveData = true;
            newsmodels.add(model);
          });
        }
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข่าวประชาสัมพันธ์ ประกาศ'),
      ),
      body: isPermission
          ? ListView.builder(
              itemCount: newsmodels.length,
              itemBuilder: (BuildContext context, int index) {
                return TileList(
                  fileUrl:
                      '${MyConstant.domain}/document/pr/${newsmodels[index].doc_key}',
                  title: newsmodels[index].book_name,
                );
              })
          : TextButton(
              onPressed: () {
                checkPermission();
              },
              child: const Text("Permission issue")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () {
          Navigator.pushNamed(context, MyConstant.routeAddpr)
              .then((value) => loadvaluefromapi());
        },

        //.then((value) => loadValueFromAPI()),
        child: Text('เพิ่ม'),
      ),
    );
  }
}

class TileList extends StatefulWidget {
  TileList({Key? key, required this.fileUrl, required this.title});
  final String fileUrl;
  final String title;

  @override
  State<TileList> createState() => _TileListState();
}

class _TileListState extends State<TileList> {
  bool dowloading = false;
  bool fileExists = false;
  double progress = 0;
  String fileName = "";
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

  startDownload() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    setState(() {
      dowloading = true;
      progress = 0;
    });

    try {
      await Dio().download(widget.fileUrl, filePath,
          onReceiveProgress: (count, total) {
        setState(() {
          progress = (count / total);
        });
      }, cancelToken: cancelToken);
      setState(() {
        dowloading = false;
        fileExists = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        dowloading = false;
      });
    }
  }

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      dowloading = false;
    });
  }

  checkFileExit() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/$fileName';
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
    });
  }

  openfile() {
    OpenFile.open(filePath);
    print("fff $filePath");
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      //fileName = Path.basename(widget.fileUrl);
      fileName = widget.fileUrl;
    });
    checkFileExit();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.grey.shade100,
      child: ListTile(
          title: Text(widget.title),
          leading: IconButton(
              onPressed: () {
                fileExists && dowloading == false
                    ? openfile()
                    : cancelDownload();
              },
              icon: fileExists && dowloading == false
                  ? const Icon(
                      Icons.window,
                      color: Colors.green,
                    )
                  : const Icon(Icons.close)),
          trailing: IconButton(
              onPressed: () {
                fileExists && dowloading == false
                    ? openfile()
                    : startDownload();
              },
              icon: fileExists
                  ? const Icon(
                      Icons.save,
                      color: Colors.green,
                    )
                  : dowloading
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 3,
                              backgroundColor: Colors.grey,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.blue),
                            ),
                            Text(
                              "${(progress * 100).toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        )
                      : const Icon(Icons.download))),
    );
  }

}
