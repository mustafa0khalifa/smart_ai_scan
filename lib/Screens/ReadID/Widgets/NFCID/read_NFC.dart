import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:sample/Components/costumAlert.dart';
import 'package:sample/Screens/ReadID/Widgets/NFCID/result_NFC.dart';

import '../../UAEIDProvider/uaeIDProvider.dart';

class ReadNFC extends StatefulWidget {
  const ReadNFC({Key? key}) : super(key: key);

  @override
  _ReadNFCState createState() => _ReadNFCState();
}

class _ReadNFCState extends State<ReadNFC> {
  bool isAvailable = false;
  bool listenerRunning = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAvailable = false;
    listenerRunning = false;
    UAEIdProvider.successResult = Future<bool>.value(false);
    UAEIdProvider.tempResultHandel = 'test empty';
    _listenForNFCEvents();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    NfcManager.instance.stopSession();
    print('NFC stopSession');
  }
  //...example code
  Future<void> _listenForNFCEvents() async {
    print('_listenForNFCEvents');
    //Always run this for ios but only once for android
    if (Platform.isAndroid && listenerRunning == false || Platform.isIOS) {
      //Android supports reading nfc in the background, starting it one time is all we need
      if (Platform.isAndroid) {
        print('NFC listener running in background now, approach tag(s)');
        //Update button states
        setState(() {
          listenerRunning = true;
        });
      }

      debugPrint('NFC Start');
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          bool succses = false;
          //Try to convert the raw tag data to NDEF
          final ndefTag = Ndef.from(tag);
          //If the data could be converted we will get an object
          if (ndefTag != null) {

            //The NDEF Message was already parsed, if any
            if (ndefTag.cachedMessage != null) {
              var ndefMessage = ndefTag.cachedMessage!;
              //Each NDEF message can have multiple records, we will use the first one in our example
              if (ndefMessage.records.isNotEmpty &&
                  ndefMessage.records.first.typeNameFormat ==
                      NdefTypeNameFormat.nfcWellknown) {
                //If the first record exists as 1:Well-Known we consider this tag as having a value for us
                final wellKnownRecord = ndefMessage.records.first;

                ///Payload for a 1:Well Known text has the following format:
                ///[Encoding flag 0x02 is UTF8][ISO language code like en][content]
                if (wellKnownRecord.payload.first == 0x02) {
                  //Now we know the encoding is UTF8 and we can skip the first byte
                  final languageCodeAndContentBytes =
                  wellKnownRecord.payload.skip(1).toList();
                  //Note that the language code can be encoded in ASCI, if you need it be carfully with the endoding
                  final languageCodeAndContentText =
                  utf8.decode(languageCodeAndContentBytes);
                  print('languageCodeAndContentText');
                  print(languageCodeAndContentText);
                  //Cutting of the language code
                  final payload = languageCodeAndContentText.substring(2);
                  print('payload');
                  print(payload);
                  //Parsing the content to int
                  //final storedCounters = int.tryParse(payload);
                  final storedCounters = payload;
                  if (storedCounters != null) {
                    succses = true;
                    print('Data restored from tag');
                    setState(() {
                      UAEIdProvider.tempResultHandel=storedCounters;
                      UAEIdProvider.successResult = Future<bool>.value(true);
                    });
                  }
                }
              }
            }
          }
          //Due to the way ios handles nfc we need to stop after each tag
          if (Platform.isIOS) {
            NfcManager.instance.stopSession();
            print('nfc stopSession');
          }
          if (succses == false) {
            print('Tag was not valid');

          }
        },
        // Required for iOS to define what type of tags should be noticed
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
        },
      );
    }
  }
//...example code

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;



    void _tagRead() {
      debugPrint('NFC Start');
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        UAEIdProvider.tempResultData = tag.data;
        UAEIdProvider.tempResultHandel = tag.handle;

        //////////////////////////
        print('tag.data');
        print(tag.data);
        print('tag.handle');
        print(tag.handle);
        print(tag.runtimeType);
        ////////////////////////

        NfcManager.instance.stopSession();
        debugPrint('NFC Stop');
        setState(() {
          UAEIdProvider.successResult = Future<bool>.value(true);
        });
      });
    }
/*
    Future<void> _tagRead() async {
      debugPrint('NFC Start');
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        print('ohhh');
      }

      // timeout only works on Android, while the latter two messages are only for iOS
      var tag = await FlutterNfcKit.poll(
          iosMultipleTagMessage: "Multiple tags found!",
          iosAlertMessage: "Scan your tag",);

      print('jsonEncode(tag)');
      print(jsonEncode(tag));
      if (tag.type == NFCTagType.iso7816) {
        var result = await FlutterNfcKit.transceive("00B0950000",
            timeout: Duration(
                seconds:
                    5)); // timeout is still Android-only, persist until next change
        print('result NFCTagType');
        print(result);
      }
      // iOS only: set alert message on-the-fly
      // this will persist until finish()
      await FlutterNfcKit.setIosAlertMessage("hi there!");

      // read NDEF records if available
      /*
      if (tag.ndefAvailable) {
        /// decoded NDEF records (see [ndef.NDEFRecord] for details)
        /// `UriRecord: id=(empty) typeNameFormat=TypeNameFormat.nfcWellKnown type=U uri=https://github.com/nfcim/ndef`
        for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
          print(record.toString());
        }

        /// raw NDEF records (data in hex string)
        /// `{identifier: "", payload: "00010203", type: "0001", typeNameFormat: "nfcWellKnown"}`
        for (var record
            in await FlutterNfcKit.readNDEFRawRecords(cached: false)) {
          print(jsonEncode(record).toString());
        }
      }
      */

      // write NDEF records if applicable
      /*
      if (tag.ndefWritable) {
        // decoded NDEF records
        await FlutterNfcKit.writeNDEFRecords([
          new ndef.UriRecord.fromUriString(
              "https://github.com/nfcim/flutter_nfc_kit")
        ]);
        // raw NDEF records
        await FlutterNfcKit.writeNDEFRawRecords([
          new NDEFRawRecord(
              "00", "0001", "0002", "0003", ndef.TypeNameFormat.unknown)
        ]);
      }
      */

      // Call finish() only once
      await FlutterNfcKit.finish();
      // iOS only: show alert/error message on finish
      await FlutterNfcKit.finish(iosAlertMessage: "Success");
      // or
      await FlutterNfcKit.finish(iosErrorMessage: "Failed");
    }
*/
    return Scaffold(
      backgroundColor: Colors.yellow[350],
      appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text(
            "Read NFC ID",
            style: TextStyle(color: Colors.black54),
          ),
          backgroundColor: Colors.amber,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back))),
      body: FutureBuilder<bool>(
        future: UAEIdProvider.successResult,
        builder: (context, ss) => ss.data != true
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome in Read NFC ID',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.only(top: height * 0.1)),


                    Padding(padding: EdgeInsets.all( width * 0.05),
                    child: Text(
                      'NFC is now activated, please swipe the ID to read the information',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: width * 0.05,),
                    ), ),
                  ],
                ),
              )
            : ResultNFC(
                UAEIdProvider.tempResultData!, UAEIdProvider.tempResultHandel!),
      ),
      /*
      floatingActionButton: FutureBuilder<bool>(
        future: UAEIdProvider.successResult,
        builder: (context, ss) => ss.data == true
            ? SizedBox()
            : Padding(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 0.4, height * 0.05),
                    backgroundColor: Colors.amber, // background (button) color
                    foregroundColor: Colors.white, // foreground (text) color
                  ),
                  child: Text(
                    "Read NFC",
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () async => {
                    // Check availability
                    isAvailable = await NfcManager.instance.isAvailable(),
                    if (isAvailable)
                      {
                        _listenForNFCEvents(),
                      }
                    else
                      {
                        showDialog(
                          barrierColor: Colors.black26,
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              title: "NFC Not Available",
                              description:
                                  "Please turn on NFC in your device before performing the NFC data reading process",
                            );
                          },
                        )
                      }
                  },
                ),
                padding: const EdgeInsets.only(bottom: 16.0)),
      ),
       */
    );
  }
}
