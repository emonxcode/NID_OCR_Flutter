import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_mrz_scanner/flutter_mrz_scanner.dart';
import 'package:inapp_flutter_kyc/inapp_flutter_kyc.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'NID Scan'),
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
  File? selfieImage;
  ExtractedDataFromId? extractedDataFromId;
  bool? isMatchFace;
  bool isloading = false;
  bool faceMatchButtonPressed = false;
  Map<String, bool> keyWordData = {
    'Name:': true,
    'Date of Birth:': true,
    'ID NO:': true
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // TextButton(
            //   onPressed: () {
            //     EkycServices().livenessDetct().then((result) {
            //       if (result != null) {
            //         print("File path: $result");
            //         setState(() {
            //           selfieImage = result;
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) =>
            //                     ShowImage(selfieImage: selfieImage)),
            //           );
            //         });
            //       } else {
            //         print("Liveness detection failed.");
            //       }
            //     }).catchError((error) {
            //       print("Error occurred during liveness detection: $error");
            //     });
            //   },
            //   style: TextButton.styleFrom(
            //     foregroundColor: Colors.white,
            //     padding: const EdgeInsets.all(16.0),
            //     backgroundColor: Colors.blue,
            //     elevation: 9.0,
            //     textStyle: const TextStyle(
            //       fontSize: 20,
            //     ),
            //   ),
            //   child: const Text("Liveness Detection"),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            TextButton(
              onPressed: () async {
                extractedDataFromId =
                    await EkycServices().openImageScanner(keyWordData);

                if (extractedDataFromId?.extractedText != null) {
                  debugPrint(extractedDataFromId!.extractedText!.toString());
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowScannedText(
                          scannedText: extractedDataFromId!.extractedText!,
                          keyNvalue: extractedDataFromId?.keywordNvalue,
                        ),
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                backgroundColor: Colors.blue,
                elevation: 9.0,
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              child: const Text("Scan NID"),
            ),
            const SizedBox(
              height: 10,
            ),
            // TextButton(
            //     onPressed: () async {
            //       if (selfieImage == null) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(
            //             content: Text(
            //                 'Capture a selfie first using liveness detection'),
            //             duration: Duration(seconds: 3),
            //           ),
            //         );
            //       } else if (extractedDataFromId?.imagePath == null) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(
            //             content: Text('There is no face detected in Id card'),
            //             duration: Duration(seconds: 3),
            //           ),
            //         );
            //       } else {
            //         isloading = true;
            //         setState(() {
            //           faceMatchButtonPressed = true;
            //         });

            //         isMatchFace = await EkycServices().runFaceMatch(
            //             "http://10.0.3.50:5000",
            //             selfieImage?.path,
            //             extractedDataFromId?.imagePath);
            //         setState(() {
            //           isloading = false;
            //         });
            //       }
            //     },
            //     style: TextButton.styleFrom(
            //       foregroundColor: Colors.white,
            //       padding: const EdgeInsets.all(16.0),
            //       backgroundColor: Colors.blue,
            //       elevation: 9.0,
            //       textStyle: const TextStyle(
            //         fontSize: 20,
            //       ),
            //     ),
            //     child: const Text("Face match with Id")),

            // Visibility(
            //   visible: faceMatchButtonPressed,
            //   child: SizedBox(
            //     width: double.infinity,
            //     // padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
            //     child: Card(
            //       shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(15))),
            //       color: const Color(0xFFe3e6f5),
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const SizedBox(
            //             height: 15,
            //           ),
            //           Row(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               const SizedBox(
            //                 width: 10,
            //               ),
            //               (isloading == true)
            //                   ? const SizedBox(
            //                       height: 50.0,
            //                       width: 50.0,
            //                       child: CircularProgressIndicator(
            //                         strokeWidth: 2,
            //                         valueColor:
            //                             AlwaysStoppedAnimation(Colors.white),
            //                       ),
            //                     )
            //                   : (isMatchFace == true)
            //                       ? const Icon(
            //                           Icons.check_circle_sharp,
            //                           size: 40,
            //                           color: Color(0xff9677eca),
            //                         )
            //                       : Transform.rotate(
            //                           angle: 45 * pi / 180,
            //                           child: const Icon(
            //                             Icons.add_circle,
            //                             size: 40,
            //                             color: Colors.red,
            //                           ),
            //                         ),
            //               const SizedBox(
            //                 width: 5,
            //               ),
            //               Expanded(
            //                 child: Text(
            //                     (isloading == true)
            //                         ? '  Running face match...'
            //                         : (isMatchFace == true)
            //                             ? "Successful!!! ID Face matches with Selfie"
            //                             : (isMatchFace == false)
            //                                 ? "Something is wrong! Please try again! "
            //                                 : 'NID Face does not match with Selfie',
            //                     maxLines: 3,
            //                     textAlign: TextAlign.left,
            //                     style: const TextStyle(
            //                         fontSize: 17,
            //                         height: 1.5,
            //                         fontWeight: FontWeight.w400)),
            //               ),
            //               const SizedBox(
            //                 width: 10,
            //               ),
            //             ],
            //           ),
            //           const SizedBox(
            //             height: 20,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// class ShowImage extends StatelessWidget {
//   File? selfieImage;
//   ShowImage({super.key, this.selfieImage});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Liveness Detect succesful!"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Image.file(selfieImage!),
//             const SizedBox(
//               height: 20,
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.all(16.0),
//                 backgroundColor: Colors.blue,
//                 elevation: 9.0,
//                 textStyle: const TextStyle(
//                   fontSize: 20,
//                 ),
//               ),
//               child: const Text("Retake"),
//             ),
//           ],
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

class FormFieldData {
  final String label;
  String value;

  FormFieldData({required this.label, required this.value});
}

class ShowScannedText extends StatefulWidget {
  String scannedText;
  Map<String, dynamic>? keyNvalue;

  ShowScannedText({super.key, required this.scannedText, this.keyNvalue});

  @override
  State<ShowScannedText> createState() => _ShowScannedTextState();
}

class _ShowScannedTextState extends State<ShowScannedText> {
  List<FormFieldData> formFields = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.keyNvalue != null) {
      widget.keyNvalue?.forEach((key, value) {
        formFields.add(FormFieldData(label: key, value: value.toString()));
      });
    }
    print(widget.keyNvalue);
    print("-------------");
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.scannedText.toString());
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
          onPressed: () {
            print("asdfasdf");
          },
          child: const Text("Sccaned Text"),
        ),
      ),
      body: GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: widget.keyNvalue != null,
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: formFields.length,
                  itemBuilder: (context, index) {
                    FormFieldData fieldData = formFields[index];
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextFormField(
                        initialValue: fieldData.value,
                        decoration: InputDecoration(labelText: fieldData.label),
                        onChanged: (value) {
                          formFields[index].value = value;
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const Text(
              "Extracted Text",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text("Name: ${extractNameFromBottom(widget.scannedText)}"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                  "NID NO: ${extractNidNumber_WithSpace(widget.scannedText)}"),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text("DOB: ${extractDateFormat(widget.scannedText)}"),
            ),
          ],
        ),
      ),
    );
  }

  String? extractNidNumber_WithSpace(String inputString) {
    RegExp nidPattern = RegExp(r'\b(\d{3} \d{3} \d{4})\b');

    Match? match = nidPattern.firstMatch(inputString);

    if (match != null) {
      return match.group(1);
    } else {
      var result = extractNID_WithoutSpace(inputString);
      if (result != null) {
        return result;
      } else {
        return null;
      }
    }
  }

  String? extractNID_WithoutSpace(String inputString) {
    RegExp nidPattern = RegExp(r'\b(\d{10})\b');

    Match? match = nidPattern.firstMatch(inputString);

    if (match != null) {
      return match.group(1);
    } else {
      return null;
    }
  }

  String? extractDateFormat(String inputString) {
    RegExp datePattern = RegExp(r'\b(\d{1,2} \w{3} \d{4})\b');

    Match? match = datePattern.firstMatch(inputString);

    if (match != null) {
      return match.group(1);
    } else {
      return null;
    }
  }

  String? extractNameFromBottom(String inputString) {
    RegExp namePattern = RegExp(r'Name\s+(.+)');

    Match? match = namePattern.firstMatch(inputString);

    if (match != null) {
      return match.group(1);
    } else {
      var result = extractNameFromSide(inputString);
      if (result != null) {
        return result;
      } else {
        return null;
      }
    }
  }

  String? extractNameFromSide(String inputString) {
    RegExp namePattern = RegExp(r'Name:\s*([^,]+)');

    Match? match = namePattern.firstMatch(inputString);

    if (match != null) {
      return match.group(1)?.trim();
    } else {
      return null;
    }
  }
}