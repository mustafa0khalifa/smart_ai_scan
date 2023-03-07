import 'dart:convert';
import 'package:flutter/material.dart';

class ResultPassport extends StatefulWidget {

  final Map<String,dynamic> result;
  final String fullDocumentFrontImageBase64 ;
  final String fullDocumentBackImageBase64 ;
  final String faceImageBase64 ;
  final String signatureImageBase64;

  const ResultPassport({super.key, required this.result, required this.fullDocumentFrontImageBase64, required this.fullDocumentBackImageBase64, required this.faceImageBase64, required this.signatureImageBase64});


  @override
  State<StatefulWidget> createState() {
    return _ResultPassportState();
  }
}

class _ResultPassportState extends State<ResultPassport> {
  String firstName = 'Please re-scan more clearly';
  String lastName = 'Please re-scan more clearly';
  String docNumber = 'Please re-scan more clearly';
  String sex = 'Please re-scan more clearly';
  String birth = 'Please re-scan more clearly';
  String expiry = 'Please re-scan more clearly';

/*

  String nationality = 'Please re-scan more clearly';
  String age = 'Please re-scan more clearly';
  String expiryPermanent = 'Please re-scan more clearly';
  String idNumber = 'Please re-scan more clearly';
  String idText = 'Please re-scan more clearly';*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splitResult();
  }

  void splitResult() {
    firstName = widget.result['First name'];
    lastName = widget.result['Last name'];
    docNumber = widget.result['Document number'];
    sex = widget.result['Sex'];
    birth = widget.result['Date of birth'];
    expiry = widget.result['Date of expiry'];

/*
    nationality = widget.result['Nationality'];
    age = widget.result['Age'];
    expiryPermanent = widget.result['Date of expiry permanent'];
    idNumber = widget.result['Personal Id Number'];
    idText = widget.result['Text'];*/

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
    if (widget.fullDocumentFrontImageBase64 != null &&
        widget.fullDocumentFrontImageBase64 != "") {
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
                      .convert(widget.fullDocumentFrontImageBase64!),
                )
              ],
            ),
          ));
    }
    //This widget will show the user image obtained from the passport or national id
    Widget faceImage = Container();
    if (widget.faceImageBase64 != null &&
        widget.faceImageBase64 != "") {
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
                  const Base64Decoder().convert(widget.faceImageBase64!),
                )
              ],
            ),
          ));
    }

    Widget signatureImage = Container();
    if (widget.signatureImageBase64 != null &&
        widget.signatureImageBase64 != "") {
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
                      .convert(widget.signatureImageBase64!),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'First name : ',
                        style: infoTitleStyle,
                      ),
                      Text(
                        firstName,
                        style: infoTextStyle,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last name : ',
                        style: infoTitleStyle,
                      ),
                      Text(
                        lastName,
                        style: infoTextStyle,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Document number : ',
                        style: infoTitleStyle,
                      ),
                      Text(
                        docNumber,
                        style: infoTextStyle,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sex : ',
                        style: infoTitleStyle,
                      ),
                      Text(
                        sex,
                        style: infoTextStyle,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date of birth : ',
                        style: infoTitleStyle,
                      ),
                      Text(
                        birth,
                        style: infoTextStyle,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: paddingInfo)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date of expiry : ',
                        style: infoTitleStyle,
                      ),
                      Text(
                        expiry,
                        style: infoTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: paddingInfo * 2)),

          fullDocumentFrontImage,
          Padding(padding: EdgeInsets.only(top: paddingInfo * 2)),
          // fullDocumentBackImage,
          faceImage,
          Padding(padding: EdgeInsets.only(top: paddingInfo * 2)),
          //   signatureImage
          signatureImage
        ],
      ),
    );
  }
}
