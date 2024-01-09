import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_filter_pro/named_color_filter.dart';
import 'package:image_filter_pro/photo_filter.dart';
import 'package:orc_flutter/pick_file.dart';
import 'dart:io';

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
  Map<String, bool> keyWordData = {
    'Name:': true,
    'Date of Birth:': true,
    'ID NO:': true
  };
  bool isloading = false;
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  File? v;

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
            v != null
                ? SizedBox(
                    height: 200,
                    width: 400,
                    child: Image.file(v!),
                  )
                : const SizedBox(),
            const SizedBox(height: 100),
            TextButton(
              onPressed: () async {
                setState(() {
                  isloading = true;
                });
                v = await showModalBottomSheet(
                  context: context,
                  builder: (context) => FilePicker(),
                );

                await _showImagePicker();
                setState(() {
                  isloading = false;
                });

                final inputImage = InputImage.fromFilePath(v!.path);

                final RecognizedText recognizedText =
                    await textRecognizer.processImage(inputImage);

                String? text = recognizedText.text;
                // for (TextBlock block in recognizedText.blocks) {
                //   final Rect rect = block.boundingBox;
                //   final List<Point<int>> cornerPoints = block.cornerPoints;
                //   final String text = block.text;
                //   final List<String> languages = block.recognizedLanguages;

                //   for (TextLine line in block.lines) {
                //     // Same getters as TextBlock
                //     for (TextElement element in line.elements) {
                //       // Same getters as TextBlock
                //       print(element.text);
                //     }
                //   }
                // }

                setState(() {
                  isloading = false;
                });

                debugPrint(text.toString());
                if (context.mounted) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowScannedText(
                        scannedText: text,
                      ),
                    ),
                  );
                  setState(() {
                    isloading = false;
                  });
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
              child: isloading
                  ? const CircularProgressIndicator()
                  : const Text("Scan NID"),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future _showImagePicker() async {
    // Implement your image picker logic here
    // Set the selected image as the imageFile
    // For example:
    // var pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    // setState(() {
    //   imageFile = pickedImage;
    // });
    var updatedImage = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PhotoFilter(
          image: v!,
          presets: const [
            NamedColorFilter(colorFilterMatrix: [
              0.3,
              0.59,
              0.11,
              0,
              0,
              0.3,
              0.59,
              0.11,
              0,
              0,
              0.3,
              0.59,
              0.11,
              0,
              0,
              0,
              0,
              0,
              1,
              0
            ], name: 'B&W'),
          ],
          applyIcon: Icons.check,
          backgroundColor: Colors.black,
          sliderColor: Colors.blue,
          sliderLabelStyle: const TextStyle(color: Colors.white),
          bottomButtonsTextStyle: const TextStyle(color: Colors.white),
          presetsLabelTextStyle: const TextStyle(color: Colors.white),
          applyingTextStyle: const TextStyle(color: Colors.white),
          cancelIcon: Icons.close,
        ),
      ),
    );

    if (updatedImage != null) {
      setState(() {
        v = updatedImage;
      });
    }
  }
}

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
    super.initState();

    // if (widget.keyNvalue != null) {
    //   widget.keyNvalue?.forEach((key, value) {
    //     formFields.add(FormFieldData(label: key, value: value.toString()));
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.scannedText.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanned Text"),
      ),
      body: GestureDetector(
        onTap: () {},
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Extracted Text",
                style: TextStyle(
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child:
                    Text("Name: ${extractNameFromBottom(widget.scannedText)}"),
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
