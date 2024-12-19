import 'package:form_field_validator/form_field_validator.dart';

// Just required validator
final requiredValidation =
    RequiredValidator(errorText: 'This field cannot be empty');

// Email validator
final emailValidation = MultiValidator([
  RequiredValidator(errorText: 'This field cannot be empty'),
  EmailValidator(errorText: 'Please enter a valid email')
]);

// Text-only validator
final textOnlyValidation = MultiValidator([
  RequiredValidator(errorText: 'This field cannot be empty'),
  PatternValidator(r'^[a-zA-Z]+$',
      errorText: 'Please enter only alphabets in this field')
]);

// Text-only without Required validator
final textOnlyValidation2 = MultiValidator([
  PatternValidator(r'^[a-zA-Z /^(?!\s*$).+/]*$',
      errorText: 'Please enter only alphabets in this field')
]);

// Number-only validator
final numOnlyValidation = MultiValidator([
  RequiredValidator(errorText: 'This field cannot be empty'),
  PatternValidator(r'^-?[0-9]+$',
      errorText: 'Please enter only numbers in this field'),
  LengthRangeValidator(
      min: 10, max: 10, errorText: 'Please enter a valid phone number')
]);

// Password length validator
final passLenValidation = MultiValidator([
  RequiredValidator(errorText: 'This field cannot be empty'),
  LengthRangeValidator(
      min: 5, max: 25, errorText: 'This field must have 5 to 25 characters')
]);

// Same password validator
final passMatch = MatchValidator(errorText: 'Passwords do not match');
