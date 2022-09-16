import 'dart:convert';
import 'dart:typed_data';

import 'package:eosdart/eosdart.dart';

const api = 'https://jungle3.cryptolions.io';

Future<void> main() async {
  EOSClient client = EOSClient(api, 'v1');

  var txJson =
      '{"expiration":"2022-04-06T07:42:50","ref_block_num":63627,"ref_block_prefix":2292189494,"net_usage_words":0,"max_cpu_usage_ms":0,"delay_sec":0,"context_free_actions":[],"actions":[{"account":"eosio","name":"newaccount","authorization":[{"actor":"eosisverygo1","permission":"active"}],"data":"1028f3576dec305510d49ffa19dd5cc30100000001000288c5656ad50af3cc23f13eae4edd3df2f878a6430828cfab209e70eff0f2c565010000000100000001000288c5656ad50af3cc23f13eae4edd3df2f878a6430828cfab209e70eff0f2c56501000000"},{"account":"eosio","name":"buyrambytes","authorization":[{"actor":"eosisverygo1","permission":"active"}],"data":"1028f3576dec305510d49ffa19dd5cc300200000"},{"account":"eosio","name":"delegatebw","authorization":[{"actor":"eosisverygo1","permission":"active"}],"data":"1028f3576dec305510d49ffa19dd5cc3e80300000000000004454f5300000000e80300000000000004454f530000000001"}],"transaction_extensions":[]}';

  Transaction transaction = Transaction.fromJson(jsonDecode(txJson));

  // print result
  print(transaction);

  Uint8List serializedTrx = transaction.toBinary(client.transactionTypes['transaction']!);
  print(serializedTrx);

  try {
    var buffer = SerialBuffer(serializedTrx);
    buffer.restartRead();
    var t = client.transactionTypes['transaction'];
    var b = t?.deserialize?.call(t, buffer);
    print(b);
  } catch (e) {
    print(e.toString());
  }
}
