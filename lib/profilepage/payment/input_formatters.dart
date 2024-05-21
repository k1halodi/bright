import 'package:flutter/services.dart';

// to make space after every 4 numbers in credit card
class CardNumberInputFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
if (newValue.selection.baseOffset == 0){
  return newValue;
}
String inputData = newValue.text;
StringBuffer buffer = StringBuffer();

for (var i = 0; i < inputData.length; i++ ){
  buffer.write(inputData[i]);
  int index = i + 1;

  if (index % 4 == 0 && inputData.length != index){
    buffer.write("  "); //double space
  }
}
return TextEditingValue(
  text: buffer.toString(),
  selection: TextSelection.collapsed(
    offset: buffer.toString().length),
);
  }

}

// card month 
class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;

if (newValue.selection.baseOffset == 0){
  return newValue;
}

var buffer = StringBuffer();
for (var i = 0; i < newText.length; i++ ){
  buffer.write(newText[i]);
  var nonZeroIndex = i + 1;

  if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length){
    buffer.write("/"); //double space
  }
}
var string = buffer.toString();
return newValue.copyWith(
  text: string,
  selection: TextSelection.collapsed(offset: string.length)
);

  }

}