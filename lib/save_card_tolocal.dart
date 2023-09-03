import 'dart:io';
import 'package:credit_card_capture_app/credit_card_object.dart';
import 'package:path_provider/path_provider.dart';

// Append data to a JSON file
Future<void> saveData(CreditCard creditCard) async {
  final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  final file = File('${appDocumentsDir.path}/creditCards.json');

  // Convert creditCard object to JSON
  final creditCardJson = creditCard.toJson();

  // Open the file in append mode and write JSON data
  await file.writeAsString(creditCardJson.toString(), mode: FileMode.append);
}

// Retrieve data from the JSON file
Future<void> retrieveData() async {
  final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  final file = File('${appDocumentsDir.path}/creditCards.json');

  try {
    // Read contents from the file
    String contents = await file.readAsString();
    print(contents);
  } catch (e) {
    print('Error reading file: $e');
  }
}
