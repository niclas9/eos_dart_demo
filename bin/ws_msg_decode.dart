import 'dart:convert';
import 'dart:typed_data';

import 'package:eosdart/eosdart.dart';

const api = 'https://jungle3.cryptolions.io';

Future<void> main() async {
  EOSClient client = EOSClient(api, 'v1');

  var abiJson = '''{
  "version": "eosio::abi/1.1",
  "types": [],
  "variants": [],
  "structs": [   { "name": "sealed_message",
         "base": "",
         "fields": [
            {
               "name": "from",
               "type": "public_key"
            },
            {
               "name": "nonce",
               "type": "uint64"
            },
            {
               "name": "ciphertext",
               "type": "bytes"
            },
            {
               "name": "checksum",
               "type": "uint32"
            }
         ]}],
  "actions": [],
  "tables": [],
  "ricardian_clauses": []
}''';

  Map<String, Type> abiTypes = getTypesFromAbi(createInitialTypes(), Abi.fromJson(json.decode(abiJson)));

  print(abiTypes);

  List<int> data = [0,3,36,112,5,124,240,55,219,189,249,171,203,111,34,64,3,22,181,106,170,184,68,159,112,238,29,97,110,9,32,78,82,137,25,66,129,197,214,217,63,73,240,1,115,91,19,106,251,183,57,4,72,247,211,80,129,87,115,186,7,50,73,170,123,76,52,36,200,176,128,236,87,15,229,237,23,84,92,161,224,197,114,96,157,233,7,45,127,17,22,231,76,152,24,10,27,142,199,227,231,194,83,243,65,122,182,14,201,222,79,28,134,81,5,4,214,105,67,247,108,131,122,210,255,252,202,228,67,91,47,219,230,228,78,55,50,154,183,160,255,174,47,213,186,18,54,116,244,153,200,255,164,159,181,162,102,74,225,174,143,247,127,13,144,246,219,221,132,204,192,183,28,238,131,226,2,224,37,226,97,148,145,32,164,97,38,35,87,128,148,113,198,82,143,10,147,144,254,196,15,74,166,14,214,45,172,158,69,216,127,44,179,156,246,166,232,243,236,216,122,3,68,28,167,54,146,19,20,220,79,105,88,96,114,168,69,195,6,42,129,125,32,93,14,57,26,165,170,135,93,20,15,38,28,139,11,136,200,9,206,229,97,129,47,189,111,125,214,83,146,168,122,241,72,118,209,37,162,39,0,12,78,159,170,85,94,118];

  Uint8List serializedMsg = Uint8List.fromList(data);
  print(serializedMsg);
  print(arrayToHex(serializedMsg));

  var buffer = SerialBuffer(serializedMsg);

  buffer.restartRead();
  var t = abiTypes['sealed_message'];
  var b = t?.deserialize?.call(t, buffer);
  print(b);
}
