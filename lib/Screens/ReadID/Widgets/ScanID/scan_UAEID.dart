import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:flutter/material.dart';
import 'package:sample/Components/costumAlert.dart';
import 'package:sample/Screens/ReadID/Widgets/ScanID/result_scan_UAEID.dart';

import '../../UAEIDProvider/uaeIDProvider.dart';


class ScanID extends StatefulWidget {
  const ScanID({Key? key}) : super(key: key);

  @override
  _ScanIDState createState() => _ScanIDState();
}

class _ScanIDState extends State<ScanID> {

  Future<void> scan() async {
    String license;
    // Set the license key depending on the target platform you are building for.
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      license =
      "";
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      license ="sRwAAAAVY29tLm1pY3JvYmxpbmsuc2FtcGxlU9kJdZhZkGlTu9XHPeNBZ8SdUyn2cTOLJBfTXzw6PyBVyxUnOiqBBEXQ4C9Kbfh0bTMiI/T/WKiv7eC/tbkkrDTdqLtrG790DcI0GtXs0hsPZgMfRH9t67tZJYjv2MSftS4M+LznoPkcUQSY6oKxcZkzn9+MhTDiTdpefJdzjSG/n+xQcQMsx5vgIuHWiE+UtLHzhLiLszApK4pWUba8PWRsgn7c5R1IruXoe9p4yNuIZWgJIKaID5pCX5UY/kTTR4stvjxrpouoM+9S14veMocRCoFyJqquLmgQQqL4KiWIQpFEvtuQfh3IoAJ0wksNOXv+k9pc54PPihTU5knQp4KQvA==";
    } else {
      license =
      "sRwAAAEGMDAxMTAwszJS4XqSzXriXOCWfNhbn6iXBcuOkThYDmj8jJ5on3MGunqRXtRTvtj09UqiE/Ex0CGSd0/WAsA83b9DxB5d79j/WL8FqFLJqp3PlXPEAdw8A0KOwVrzdUW4j1xsbCjvK56NEZxyF7Hrclsyi2KtYfW33Tupja+CN46TjthwUqflplr8Ifcy/R1KGFhb9GYvUFcdmXsgehcAFoJULkAegI/cxNEJ//BsgjZ0gRuNXdc=";
    }

    var idRecognizer = BlinkIdCombinedRecognizer();
    idRecognizer.returnFullDocumentImage = true;
    idRecognizer.returnFaceImage = true;
    idRecognizer.returnSignatureImage = true;

    BlinkIdOverlaySettings settings = BlinkIdOverlaySettings();

    var results = await MicroblinkScanner.scanWithCamera(
        RecognizerCollection([idRecognizer]), settings, license);

    if (!mounted) {
      return;
    }
      // When the scan is cancelled, the result is null therefore we return to the the main screen.
      if (results.isEmpty) {
        return;
      }
      //When the result is not null, we check if it is a passport then obtain the details using the `getPassportDetails` method and display them in the UI. If the document type is a national id, we get the details using the `getIdDetails` method and display them in the UI.
      for (var result in results) {
        if (result is BlinkIdCombinedRecognizerResult) {
          if (result.mrzResult?.documentType == MrtdDocumentType.Passport) {
            //UAEIdProvider.resultString = getPassportResultString(result);
            return;
          } else {
            UAEIdProvider.resultString = getIdResultString(result);
            print('resultString');
            print(UAEIdProvider.resultString);
          }

          setState(() {
            UAEIdProvider.resultString = UAEIdProvider.resultString;
            UAEIdProvider.fullDocumentFrontImageBase64 = result.fullDocumentFrontImage ?? "";
            UAEIdProvider.faceImageBase64 = result.faceImage ?? "";
            UAEIdProvider.signatureImageBase64 = result.signatureImage ?? "";

          });

          isScan=true;
          UAEIdProvider.successResult = Future<bool>.value(true);
          return;
        }
      }


    }

  //This method is used to obtain the specific user details from the national id from the scan result object.
  Map<String,dynamic> getIdResultString(BlinkIdCombinedRecognizerResult result) {
    // The information below will be otained from the natioal id if they are available.
    // In the case a field is not found, then it is skipped. For example, some national ids do not have the profession field.

    return
      {
        "Full name"  :result.fullName != ''?buildResult(result.fullName):
                      result.mrzResult!.mrzVerified!? buildResult(result.mrzResult!.primaryId)
                          :buildResult(result.lastName),
        "Document number" :result.documentNumber!=''?buildResult(result.documentNumber)
                      : result.mrzResult!.mrzVerified!?buildResult(result.mrzResult!.documentNumber):'',
        "Sex":result.sex!=''?buildResult(result.sex) :
                      result.mrzResult!.mrzVerified!?buildResult(result.mrzResult!.gender):'',
        "Nationality":result.nationality!=''?buildResult(result.nationality)
                : result.mrzResult!.mrzVerified!?buildResult(result.mrzResult!.nationality):'',
        "Date of birth":buildDateResult(result.dateOfBirth),
        "Age":buildIntResult(result.age),
        "Date of expiry":buildDateResult(result.dateOfExpiry),
        "Date of expiry permanent":buildResult(result.dateOfExpiryPermanent.toString()),
        "Personal Id Number":result.personalIdNumber!=''?buildResult(result.personalIdNumber) :
               result.mrzResult!.mrzVerified!?buildResult(result.mrzResult!.opt1):'',
        "Text":result.mrzResult!.mrzVerified!?result.mrzResult!.mrzText:'',
      };
  }

  String buildResult(String? result) {
    if (result == null || result.isEmpty) {
      return "";
    }

    return result.replaceAll('\n', ' ');
  }

  String buildDateResult(Date? result) {
    if (result == null || result.year == 0) {
      return "";
    }

    return buildResult(
        "${result.day}.${result.month}.${result.year}");
  }

  String buildIntResult(int? result) {
    if (result == null || result < 0) {
      return "";
    }

    return buildResult(result.toString());
  }


  bool isScan=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UAEIdProvider.successResult = Future<bool>.value(false);
    isScan=false;

  }

  // This widget will display a complete image of the scanned passport or national id.
  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return
      Scaffold(
        backgroundColor: Colors.yellow[350],
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text(
            "Scan UAE ID ",
            style: TextStyle(color: Colors.black54),
          ),
          backgroundColor: Colors.amber,
            leading: IconButton(onPressed:() {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back))
        ),
        body:
        FutureBuilder<bool>(
        future: UAEIdProvider.successResult,
    builder: (context, ss) => ss.data != true
    ?
    Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome in Scane UAE ID',style: TextStyle(color: Colors.black54,fontSize: width*0.05,fontWeight: FontWeight.bold),),
              Padding(padding: EdgeInsets.only(top: height*0.1)),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text('''
After pressing the scan button
Please follow the instructions that will appear on the screen:


  1- Scan the front side of the ID
  
  2- After completion, Scan the back side of the ID
                ''',style: TextStyle(color: Colors.black54,fontSize: width*0.04),),
              ),
            ],
          ),
        ):
    ResultUEAID(result: UAEIdProvider.resultString!,faceImageBase64: UAEIdProvider.faceImageBase64,
                            fullDocumentBackImageBase64: UAEIdProvider.fullDocumentBackImageBase64,
    fullDocumentFrontImageBase64: UAEIdProvider.fullDocumentFrontImageBase64,
    signatureImageBase64: UAEIdProvider.signatureImageBase64,
    )),

        floatingActionButton:
    FutureBuilder<bool>(
    future: UAEIdProvider.successResult,
    builder: (context, ss) => ss.data != true
    ?
        Padding(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(width*0.4,height*0.05),
                backgroundColor: Colors.amber, // background (button) color
                foregroundColor: Colors.white, // foreground (text) color
              ),
              child:  Text("Scan ID",style:  TextStyle(color: Colors.black54),),
              onPressed: () async => {
                await scan(),
                if(!isScan){
                  showDialog(
                    barrierColor: Colors.black26,
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        title: "Scan Error",
                        description: "The identity has not been properly identified",
                      );
                    },
                  )

                }
              },
            ),
            padding: const EdgeInsets.only(bottom: 16.0)):
    SizedBox())

      );
  }
}