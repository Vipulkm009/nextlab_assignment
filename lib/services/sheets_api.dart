import 'package:gsheets/gsheets.dart';
import 'package:nextlab_assignment/models/record_model.dart';

class SheetsAPI {
  static const credentials = r'''
  {
  "type": "service_account",
  "project_id": "nextlab-1661021254667",
  "private_key_id": "e023c2a4f5790c3e71080e1bdf2772d2967f450f",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDW2B8+9sHg6QWM\nnQDwLLQohtDuw0XwW1aWpatONBwQzLIMs7yRDp3oOKRKBl8z3Fs14c9UVmXgR3p1\na7Vp6kVCejljD6g4LDst9fimbX8WkHfAHuFGe5izOhSE+qNDx8gaxFHd1/ZyTAaM\nIInN69ivfdUStxT+dwxhrS16KHN5nmqUc8RsBPwNK3V/RmDRcuf9KIxW7XkWJ4WB\nEkq5E3zByWEUwdWRMnABc9qNlmBcLrT7Hd6y/X98P5Gutmc2KN7MU897Xr/i48vn\nqnkoytOHxXZI40MjhyLOuj+vVG/uR+BTEIqHrYRPYNDcNXECDbyPb2YNW14t4QLI\n/m8oJARhAgMBAAECggEAFnZaLfcWpjE2x1DS/ElwPJx707rO4SZrkyyXEIIaPRdp\ntjJEkNX6ZIEnjCXGZmGvl56YUrUFycEvaH9uZDh+LUkiHt1QNS9KsK9648um8fEA\n1DFmVDwv5u03n/+kej21CjdkZ9Fgjuqr9JKiVclGynJZiK9jnodL4Bp/GrqH+DsK\ntMjUOgGCjWiwYexx31CnTTUmNmQ+C+jp/UhThl8diqpJE7xJYP73/R+p+PUJmPcy\nUCbk2mTXdYbZ2b1RYerajt+bQF+R3da/xUg9CUJA2VGLZ4cQEw+/88XKbPqrnomh\ny+N59sOrPA222P0gaJLcYwke6lJVHWRIUmqNNE/9UQKBgQD8moPK0aFOlO6Z0rFx\nY3Wje+2HL2fIweA4bJ+7Jv8Jogmcr0ftyXGKKr2UW5TOF3rvcUbNl+3wBQ8oMaW7\naW3yMjEOov8Y4vbu4GkD8xSIuLCiMSemTxKVnVN9VY8yysDAdmIKuDofgldz/PZ5\nqX7Q7cmIfd7MeAXsV9kUMSatSwKBgQDZu6LSynInKJyV71pcPCEvqZBgCMtQYStu\n7AK+2BI2FXGd6dV5Ss3c3ljBUK3vmM9yLBe9N/1ohXMWhjZdOFJxsYSPh2sTcceX\nYrdInn/2/GxgYcP/Fes/f8uNfjG2vgH0w9N+FS5GeU/K6Y8ESL6OwUYlw3Jtjg0W\nfZeLufilgwKBgQCMpFcmsKr4PrHOUWHceP0Bpjls4DcPrupxYAFbSW4MZfymEW2h\n9lvSCtP86zShvq8C6/X4+FNRJO/4eBQHkb7Wb52iwZv4tj24aJfvzAKt0O7/jxC9\nZx840ByxFtcg94R0ZDVYNJSgAIlCmiB9QqLKHurrpPFMtLLPkWXa+TbImwKBgADu\nJEvyQXqZWdHqK+CpARtLBiri3ruBLsZSi9B0697/SHT8QsU55JdE++wXhCa56Gj8\ndz1/t71ylINMH39WdkO2FnLmiTaUDd4/tbjBtJpBidT/le7JETA8Q4pfN6coOKnr\nDERFouT6L7UWOl4yUV4axUn0A9EkAjpOXw9hxAYxAoGAYgxZyoUdG/47RoJSngRE\nXRDb1H5mQ7S+LShDs5PUOrs6SepHHWVkOis1DFVkTvLF9oktBfNQI9J9KbGW+O4G\nYqBhP2tu/nPF94tflfY47MsLt9sWJrY6JOk5wctYu2SHCChEaS9RL+3i0CUOOSz7\n9WWlV3CDtZ1IUK93rj2RqXk=\n-----END PRIVATE KEY-----\n",
  "client_email": "nextlab@nextlab-1661021254667.iam.gserviceaccount.com",
  "client_id": "104320848816287637633",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/nextlab%40nextlab-1661021254667.iam.gserviceaccount.com"
}
  ''';
  static final spreadsheetId = '1XfTv3rA67l_l6rMwz6o4XgZlI9LUtvrMqv0XlqGno4A';
  static final gsheets = GSheets(credentials);
  static Worksheet? recordSheet;

  static Future init() async {
    try {
      final spreadsheet = await gsheets.spreadsheet(spreadsheetId);
      recordSheet = await getWorksheet(spreadsheet, title: 'Login Record');

      final firstRow = RecordFields.getFields();
      recordSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('Error : $e');
    }
  }

  static Future<Worksheet> getWorksheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return await spreadsheet.worksheetByTitle(title)!;
    }
  }

  static Future insert(List<Map<String, dynamic>> rowData) async {
    if (recordSheet == null) return;
    recordSheet!.values.map.appendRows(rowData);
  }
}
