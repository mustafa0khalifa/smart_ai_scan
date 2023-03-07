import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:sample/Screens/ReadID/Widgets/NFCID/read_NFC.dart';
import 'package:sample/Screens/ReadID/Widgets/ScanID/scan_UAEID.dart';
import 'package:sample/Screens/ReadID/Widgets/ScanPassport/scan_passport.dart';

import '../../Components/costumAlert.dart';

class ReadID extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ReadIdState();
  }

}

class _ReadIdState extends State<ReadID>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAvailable=false;
  }
  bool isAvailable=false;

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: Colors.yellow[350],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          "Read UAE Info ",
          style: TextStyle(color: Colors.black54),
        ),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        padding: EdgeInsets.all(width*0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Text('Welcome to the Automated UAE Info Reader',style: TextStyle(color: Colors.black54,fontSize: width*0.04,fontWeight: FontWeight.bold),),
            Padding(padding: EdgeInsets.only(top: height*0.05)),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text("You have two ways to read your identification information:",textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54,fontSize: width*0.04),),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('''
1- Reading the information by scanning the ID using the camera

2- Read the information by reading the NFC on the ID
                ''',style: TextStyle(color: Colors.black54,fontSize: width*0.03),),
            ),
            ///////////passport
            Padding(
              padding: EdgeInsets.all(15),
              child: Text("to read your Passport information:",textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54,fontSize: width*0.04),),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Text('Reading the information by scanning the Passport using the camera',textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54,fontSize: width*0.03),),
            ),

          ],
        ),
      ),
      floatingActionButton:
      Padding(
        padding:  EdgeInsets.all(width*0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width*0.35,height*0.05),
                    backgroundColor: Colors.amber, // background (button) color
                    foregroundColor: Colors.white, // foreground (text) color
                  ),
                  child:  Text("Scan ID",style:  TextStyle(color: Colors.black54),),
                  onPressed: ()  => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ScanID()),
                    )
                  },
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width*0.35,height*0.05),
                    backgroundColor: Colors.amber, // background (button) color
                    foregroundColor: Colors.white, // foreground (text) color
                  ),
                  child:  Text("Read NFC",style:  TextStyle(color: Colors.black54),),
                  onPressed: () async  => {
                    // Check availability
                    isAvailable = await NfcManager.instance.isAvailable(),
                    if (isAvailable)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  ReadNFC()),
                        )
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

              ],
            ),
            Padding(padding: EdgeInsets.only(top: height*0.01)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(width*0.35,height*0.05),
                backgroundColor: Colors.amber, // background (button) color
                foregroundColor: Colors.white, // foreground (text) color
              ),
              child:  Text("Scan Passport",style:  TextStyle(color: Colors.black54),),
              onPressed: ()  => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  ScanPassport()),
                )
              },
            ),
          ],
        ),
      ),

    );
  }
}