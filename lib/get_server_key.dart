// import 'package:googleapis_auth/auth_io.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
//
// class GetServerKey {
//   Future<String> getServerKeyToken() async {
//     final scopes = [
//       'https://www.googleapis.com/auth/userinfo.email',
//       'https://www.googleapis.com/auth/firebase.database',
//       'https://www.googleapis.com/auth/firebase.messaging',
//     ];
//
//     final client = await clientViaServiceAccount(
//       ServiceAccountCredentials.fromJson(
//         {
//           "type": "service_account",
//           "project_id": "gen21au",
//           "private_key_id": "ebe56619877957992568aa11340672d3664998ad",
//           "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDRhNQtd2P7sdML\nNc2yJA0EMETZuUaPz41FBNkSTinryJMdP8Jjn2C+UgKTfV2KtODk240Lxh/KDeYe\nlhdGIvEWBAkOakOxQMoVkIRgAYYZDqTQYZcF27oCavojZAPV6yobaHk+O+Xw89Rl\nhFTqgPZEcJ5oxyDb4FG7NwFMKhV6mIT+/72sDKOUnJgWT8yTS7otnWh4YBHmS5aF\nYZF36Co7YLGYKlC0/aQPZY7ooROzkPBWPZoDOWqDHAqFTMpOloBJQ9CNic45TFr/\nTQGNTfBRQFGhAbHH8cpJH93EIV02IFh+392mQ6AXylLawTA9EBBcxIyqdnTng2u4\nXD/Y/+VLAgMBAAECggEAC8mnLaxXEzeU0eoj2am+k7rq0hG4Sb9ZyYV1eFqucBti\nRNXWqB0057BHKyjKpP2lM4BeBfNjzCM5DFp8Z7qaiWxjsrcWz4z/cZ7RBnJqKtRl\n6xVlK5607zg5PNl+f8AR0pCaVakwDXziY8MXYJ7YfCRBPVA1ZeQlJQfPX7YfFue4\nwOQp/mYEF5mL35Pjo7+zXMXownxBSShRj7pvJ5A2MFUcwrLDm4hS6eLYntLasHAc\nUEneq6dHEWKpNnT/OAD1zIsi1BCy50Z+P+YTyYQGBkbqvuO01N2yb7AEqzpZiTcZ\nI0wA553jGiiem+/ZeOvRHXf0B2CDctB/d5PFbneqVQKBgQDwpabGJC1NWf3JMYJs\niZ9bWQccl48w0ng3X4KO6UszZ55ju/ew0YPBxn75w0ZYkYvjjCm7l9j8SG0qerYX\n4IUErUFD1m0T2kj4ee0YzIC8HaWMj5pwBcoH2hoLpKlcFELbuUkrJ98aFWn77jm6\nPBxSMN2p7kNfrhCroYNXMitDvQKBgQDe4sdDs+PucjxYwvXEsKzWT0koSoKxmt8R\nJtH///p99ULe19hYJZQHLw4Bvux8oCc6DZvTwqRpC53nfzR2575XsNIA/CiRaMOE\n4oD9wsU0gTVOzrIt/S4vFoyGZHUvjaVdCbxoKRnNNOIBL39MMxtWrYXhbYJfXU0N\nrwJ/K8JZpwKBgQCARItkSZwsAq+XMeCG4cQi+I0l3FLifwy81xfL/OWsfKqcFnCr\nusEz5A2CK2evhcS+gNMtvn5V2nT1k3rDt1SvbXnAIub5EfybFMIf2cE0g8jd5x02\nYJ+TF9mSIy5yego4+8XYTuRIDuny8sOqVKfz10APd4RJ14njMa/EJmWRMQKBgQCT\nqFdsccuJ12JFR3t8P7NxEvubVql4seofucEbwOCY+5e+e+5WjyafD7xOycZv1cXG\n/ucCBgvXj5uflrUSJPsDqx+lCWhy1J3a9heQha0R2JuRRvvh3b3v8hdMnVbJFyS7\nG00XEEuImAU11dqWh7EP3ks4icz6EpyOeSfFSh8qNwKBgEPTZW/fr2AImB2u26od\nptgm+1zH6TFiz+dgLdDrVM1U9ZMJA8e2iU0tFsRxshPpVw0rezhncuqVd/2rriEQ\nB8QzljSkGv6S2mmsd7lIOmTaER12d5+KC5p4gIhOrm5cbChWGlW9AP5zbKotsrFf\nmRlgs9ugU/c3S/YMOP5jLwRu\n-----END PRIVATE KEY-----\n",
//           "client_email": "firebase-adminsdk-45bzz@gen21au.iam.gserviceaccount.com",
//           "client_id": "115005246000157250955",
//           "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//           "token_uri": "https://oauth2.googleapis.com/token",
//           "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//           "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-45bzz%40gen21au.iam.gserviceaccount.com",
//           "universe_domain": "googleapis.com"
//         }),
//       scopes,
//     );
//     final accessServerKey = client.credentials.accessToken.data;
//     return accessServerKey;
//   }
// }