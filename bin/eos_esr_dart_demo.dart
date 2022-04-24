import 'package:dart_esr/dart_esr.dart';

void main(List<String> arguments) => decodeESRExample();

Future<void> decodeESRExample() async {
  const api = 'https://jungle3.cryptolions.io';
  const myAccountName = 'eosisverygo1';
  const myPrivateKey = '5Kfs388vr6TM8oMsCd4xfkqsR9132nw9TWfpma7NNfRzvMN3vxA';
  const myPermission = 'active';
  print('Decode ESR');
  var esr = EOSIOSigningrequest(api, 'v1',
      chainId: '2a02a0053e5a8cf73a56ba0fda11e4d92e0238a4a2aa74fccf46d5a910746840');

  // var encodedRequest =
  //     'esr://gmNgZur_-TdO7KrRD9ePDEDAeEBtbc4uK8NQEIfhwLLVjAJOHF5SEzaeAvFXvDUy4mQESyVs8mQAsgA';

  // identity v3
  // var encodedRequest = 'esr://g2NgZGZgYHA4quUbzsBknVFSUlBspa-fnKSXmJeckV-kl5OZl62flJhmlJaamKqbZGaapGtikmipa5GaaqJrYpSaZGxobG5mkJLKxAJSepYRbhqz4Uemm08K7KzPL3237lNM6yyPsMj1114JhUYeTBLdkBj3dyGjI9gOH5AVxnomegYKTkX55cWpRSFFiXnFBflFJUBhY6Cwb35VZk5Oor4pkK3hm5icmVeSX5xhreCZV5KaowAUUPAPVohQMDSINzSNN9dUcCwoyEkNT03yzizRNzU21zM2U9Dw9gjx9dFRyMnMTlVwT03OztdUcM4oys9N1Tc0MNAz0DOxsDTTMzdVCE5MSyzKhGpjLU7OL0hlT61IzAWaCAA';

  // identity v2
  var encodedRequest = 'esr://gmNgZmYUcOLwmjVz4ykGIFjx1siIQTSjpKSg2EpfP9kvMScnKTE5Wy85P5cBAA';

  var decoded = esr.deserialize(encodedRequest);
  print(decoded.toString());
  // 指定操作人的私钥权限
  List<Authorization> auth = [
    Authorization()
      ..actor = myAccountName
      ..permission = myPermission
  ];

  var tx = esr.resolve(decoded, auth);

  print(tx);
}