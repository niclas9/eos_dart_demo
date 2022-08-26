import 'dart:typed_data';

import 'package:dart_esr/dart_esr.dart';
import 'package:eosdart/eosdart.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart' as ecc;

void main(List<String> arguments) => decodeESRExample();

Future<void> decodeESRExample() async {
  const api = 'https://jungle3.cryptolions.io';
  const myAccountName = 'eosisverygo1';
  const myPrivateKey = '5Kfs388vr6TM8oMsCd4xfkqsR9132nw9TWfpma7NNfRzvMN3vxA';
  const myPermission = 'active';
  EOSClient client = EOSClient(api, 'v1', privateKeys: [myPrivateKey]);
  print('Decode ESR');
  var esr = EOSIOSigningrequest(api, 'v1', chainId: '2a02a0053e5a8cf73a56ba0fda11e4d92e0238a4a2aa74fccf46d5a910746840');

  // var encodedRequest =
  //     'esr://gmNgZur_-TdO7KrRD9ePDEDAeEBtbc4uK8NQEIfhwLLVjAJOHF5SEzaeAvFXvDUy4mQESyVs8mQAsgA';

  // identity v3
  // var encodedRequest =
  //     'esr://g2NgZGZgYHA4quUbzsBknVFSUlBspa-fnKSXmJeckV-kl5OZl62flJhmlJaamKqbZGaapGtikmipa5GaaqJrYpSaZGxobG5mkJLKxAJSepYRbhqz4Uemm08K7KzPL3237lNM6yyPsMj1114JhUYeTBLdkBj3dyGjI9gOH5AVxnomegYKTkX55cWpRSFFiXnFBflFJUBhY6Cwb35VZk5Oor4pkK3hm5icmVeSX5xhreCZV5KaowAUUPAPVohQMDSINzSNN9dUcCwoyEkNT03yzizRNzU21zM2U9Dw9gjx9dFRyMnMTlVwT03OztdUcM4oys9N1Tc0MNAz0DOxsDTTMzdVCE5MSyzKhGpjLU7OL0hlT61IzAWaCAA';

  // identity v2
  var encodedRequest = 'esr://gmNgZmYUcOLwmjVz4ykGIFjx1siIQTSjpKSg2EpfP9kvMScnKTE5Wy85P5cBAA';

  var decoded = esr.deserialize(encodedRequest);
  print(decoded.toString());
  // 指定操作人的私钥权限
  var auth = Authorization()
    ..actor = myAccountName
    ..permission = myPermission;

  var transaction = esr.resolve(auth);

  print(transaction.toString());
  var info = await client.getInfo();
  var refBlock = await client.getBlock((info.headBlockNum! - 3).toString());
  transaction.expiration =
        refBlock.timestamp!.add(Duration(seconds: 180));
    transaction.refBlockNum = refBlock.blockNum! & 0xffff;
    transaction.refBlockPrefix = refBlock.refBlockPrefix;

  var chainId = ESRConstants.ChainIdLookup.values.toList()[decoded.chainId[1]];
  Uint8List serializedTrx = transaction.toBinary(client.transactionTypes['transaction']!);
  Uint8List signBuf = Uint8List.fromList(List.from(stringToHex(chainId))
    ..addAll(serializedTrx)
    ..addAll(Uint8List(32)));

  ecc.EOSPrivateKey pKey = ecc.EOSPrivateKey.fromString(myPrivateKey);
  var sign = pKey.sign(signBuf).toString();
  transaction.signatures = [sign];

  var callBack = esr.getCallback(transaction, auth);
  print(callBack);
}
