import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:samsar/values/app_routes.dart';
import '../Widgets/widgets.dart';

Future<void> showAdditionalInfoDialog(BuildContext context, String userId) async {
  String? gender;
  DateTime? birthdate;
  final TextEditingController phoneNumberController = TextEditingController();
  Country selectedDialogCountry = CountryPickerUtils.getCountryByPhoneCode('216');

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Additional Information'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  DropdownButton<String>(
                    value: gender,
                    hint: Text('Select Gender'),
                    items: <String>['Male', 'Female', 'Other'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        gender = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    child: Text(birthdate == null
                        ? 'Select Birthdate'
                        : DateFormat('yyyy-MM-dd').format(birthdate!)),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && picked != birthdate) {
                        setState(() {
                          birthdate = picked;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  buildPhoneNumberField(phoneNumberController,
                      selectedDialogCountry, () => _openCountryPickerDialog(context, setState, selectedDialogCountry)),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Save'),
                onPressed: () async {
                  String phoneNumber = '+${selectedDialogCountry.phoneCode}${phoneNumberController.text}';

                  if (phoneNumberController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid phone number')),
                    );
                    return;
                  }

                  await FirebaseFirestore.instance.collection('users').doc(userId).update({
                    'gender': gender,
                    'birthdate': birthdate,
                    'phoneNumber': phoneNumber,
                  });
                  Navigator.of(dialogContext).pop();
                  Navigator.pushReplacementNamed(context, AppRoutes.authWrapper);
                },
              ),
            ],
          );
        },
      );
    },
  );
}

void _openCountryPickerDialog(BuildContext context, StateSetter setState, Country selectedDialogCountry) => showDialog(
  context: context,
  builder: (dialogContext) => Theme(
    data: Theme.of(context),
    child: CountryPickerDialog(
      titlePadding: const EdgeInsets.all(8.0),
      searchInputDecoration: const InputDecoration(hintText: 'Search...'),
      isSearchable: true,
      title: const Text(
        'Select your phone code',
        style: TextStyle(fontSize: 18),
      ),
      onValuePicked: (Country country) => setState(() => selectedDialogCountry = country),
      itemFilter: (c) => 'IL' != c.isoCode,
      itemBuilder: buildCupertinoSelectedItem,
      priorityList: [
        CountryPickerUtils.getCountryByIsoCode('TN'),
        CountryPickerUtils.getCountryByIsoCode('DZ'),
        CountryPickerUtils.getCountryByIsoCode('MA'),
        CountryPickerUtils.getCountryByIsoCode('LY'),
        CountryPickerUtils.getCountryByIsoCode('PS'),
      ],
    ),
  ),
);