class UAEIdProvider{
  static Map<String,dynamic>? resultString= {
  "Last name"  :'',
  "Full name"  :'',
  "Document number" : '',
  "Sex":'',
  "Nationality":'',
  "Date of birth":'',
  "Age":'',
  "Date of expiry":'',
  "Date of expiry permanent":'',
  "Personal Id Number":'',
    "Text":''
};
  static Map<String,dynamic>? resultPassport= {
    "Last name"  :'',
    "First name"  :'',
    "Document number" : '',
    "Sex":'',
    "Nationality":'',
    "Date of birth":'',
    "Age":'',
    "Date of expiry":'',
    "Date of expiry permanent":'',
    "Personal Id Number":'',
    "Text":''
  };
  static String fullDocumentFrontImageBase64 = "";
  static String fullDocumentBackImageBase64 = "";
  static String faceImageBase64 = "";
  static String signatureImageBase64 = "";
  static Future<bool>? successResult;

  static Map<String,dynamic>? tempResultData= {
    "Last name"  :'test',
    "Full name"  :'test',
    "Document number" : 'test',
    "Sex":'test',
    "Nationality":'test',
    "Date of birth":'test',
    "Age":'test',
    "Date of expiry":'test',
    "Date of expiry permanent":'test',
    "Personal Id Number":'test',
    "Text":'test'
  };

  static String? tempResultHandel= 'test';

}