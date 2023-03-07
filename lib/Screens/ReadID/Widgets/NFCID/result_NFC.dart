import 'dart:convert';
import 'package:flutter/material.dart';

import '../../UAEIDProvider/uaeIDProvider.dart';

class ResultNFC extends StatefulWidget {
  static String rout = '/resultUEAIDScreen';


  ///////////////////////
  final Map<String,dynamic> tempData ;
  final String tempHandel ;

  ResultNFC(this.tempData, this.tempHandel);

  @override
  State<StatefulWidget> createState() {
    return _ResultNFCState();
  }
}

class _ResultNFCState extends State<ResultNFC> {
  String fullName = 'Please re-scan more clearly';
  String docNumber = 'Please re-scan more clearly';
  String sex = 'Please re-scan more clearly';
  String nationality = 'Please re-scan more clearly';
  String birth = 'Please re-scan more clearly';
  String age = 'Please re-scan more clearly';
  String expiry = 'Please re-scan more clearly';
  String expiryPermanent = 'Please re-scan more clearly';
  String idNumber = 'Please re-scan more clearly';
  String idText = 'Please re-scan more clearly';

  ///////////////////////
  Map<String,dynamic> _testData = {
    "Last name"  :'t',
    "Full name"  :'t',
    "Document number" : 't',
    "Sex":'t',
    "Nationality":'t',
    "Date of birth":'t',
    "Age":'t',
    "Date of expiry":'t',
    "Date of expiry permanent":'t',
    "Personal Id Number":'t',
    "Text":'t'
  };
  String _testHandel='t' ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splitResult();
  }

  void splitResult() {
    fullName = UAEIdProvider.resultString!['Full name'];
    docNumber = UAEIdProvider.resultString!['Document number'];
    sex = UAEIdProvider.resultString!['Sex'];
    nationality = UAEIdProvider.resultString!['Nationality'];
    birth = UAEIdProvider.resultString!['Date of birth'];
    age = UAEIdProvider.resultString!['Age'];
    expiry = UAEIdProvider.resultString!['Date of expiry'];
    expiryPermanent = UAEIdProvider.resultString!['Date of expiry permanent'];
    idNumber = UAEIdProvider.resultString!['Personal Id Number'];
    idText = UAEIdProvider.resultString!['Text'];
    _testData = widget.tempData;
    _testHandel = widget.tempHandel;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextStyle infoTextStyle =
    TextStyle(color: Colors.black45, fontSize: width * 0.03);
    TextStyle infoTitleStyle = TextStyle(
        color: Colors.black45,
        fontSize: width * 0.04,
        fontWeight: FontWeight.bold);
    var paddingInfo = height * 0.01;

    Widget fullDocumentFrontImage = Container();
    if (UAEIdProvider.fullDocumentFrontImageBase64 != null &&
        UAEIdProvider.fullDocumentFrontImageBase64 != "") {
      fullDocumentFrontImage = Card(
          elevation: 50,
          shadowColor: Colors.black,
          color: Colors.white70,
          child: Container(
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Document Front Image:",
                      style: infoTitleStyle,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: paddingInfo)),
                Image.memory(
                  const Base64Decoder()
                      .convert(UAEIdProvider.fullDocumentFrontImageBase64!),
                )
              ],
            ),
          ));
    }
    //This widget will show the user image obtained from the passport or national id
    Widget faceImage = Container();
    if (UAEIdProvider.faceImageBase64 != null &&
        UAEIdProvider.faceImageBase64 != "") {
      faceImage = Card(
          elevation: 50,
          shadowColor: Colors.black,
          color: Colors.white70,
          child: Container(
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Face Image:",
                      style: infoTitleStyle,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: paddingInfo)),
                Image.memory(
                  const Base64Decoder().convert(UAEIdProvider.faceImageBase64!),
                )
              ],
            ),
          ));
    }

    Widget signatureImage = Container();
    if (UAEIdProvider.signatureImageBase64 != null &&
        UAEIdProvider.signatureImageBase64 != "") {
      signatureImage = Card(
          elevation: 50,
          shadowColor: Colors.black,
          color: Colors.white70,
          child: Container(
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Signature Image:",
                      style: infoTitleStyle,
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: paddingInfo)),
                Image.memory(
                  const Base64Decoder()
                      .convert(UAEIdProvider.signatureImageBase64!),
                )
              ],
            ),
          ));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 50,
            shadowColor: Colors.black,
            color: Colors.white70,
            child: Container(
              padding: EdgeInsets.all(width * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /*Text(
                    'data : ',
                    style: infoTitleStyle,
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo)),
                  Text(
                    _testData.toString(),
                    style: infoTextStyle,
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo*2)),
*/
                  Text(
                    'handel data : ',
                    style: infoTitleStyle,
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo)),
                  Text(
                    _testHandel,
                    style: infoTextStyle,
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo*2)),

                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: paddingInfo * 2)),

        ],
      ),
    );
  }
}
