part of "widgets.dart";

Future<Map<String, dynamic>?> showFilterDialog(BuildContext context) async {
  final HouseManager houseManager = HouseManager();
  RangeValues tempPriceRange = const RangeValues(100, 10000);
  TextEditingController tempMinPriceController = TextEditingController();
  TextEditingController tempMaxPriceController = TextEditingController();

  RangeValues tempSizeRange = const RangeValues(30, 500);
  RangeValues tempBedroomsRange = const RangeValues(0, 10);
  RangeValues tempFloorRange = const RangeValues(0, 10);
  String tempSelectedRegion = "";
  String tempSelectedDistrict = "";
  Map<String, List<String>> regionsAndDistricts = houseManager.regionsAndDistricts;
  bool tempHasParking = false;
  bool tempIsFurnished = false;
  bool tempIsForRent = false;
  bool tempIsForSale = false;
  bool tempIsMonthlyPayment = false;
  bool tempIsDailyPayment = false;
  bool tempIs3D = false;

  final FocusNode focusNodeMin = FocusNode();
  final FocusNode focusNodeMax = FocusNode();

  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      final theme = Theme.of(context);
      return AlertDialog(
        title: Text(
          'Filters',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  // For Rent and For Sale options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text('For Rent', style: theme.textTheme.titleMedium),
                          Checkbox(
                            value: tempIsForRent,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                tempIsForRent = value ?? false;
                                if (tempIsForRent) tempIsForSale = false;
                              });
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('For Sale', style: theme.textTheme.titleMedium),
                          Checkbox(
                            value: tempIsForSale,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                tempIsForSale = value ?? false;
                                if (tempIsForSale) tempIsForRent = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Price Range Filter (only shown for rent)
                  if (tempIsForRent) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Price Range: ${tempPriceRange.start.round()}DT - ${tempPriceRange.end.round()}DT',
                      style: theme.textTheme.bodySmall,
                    ),
                    RangeSlider(
                      values: tempPriceRange,
                      min: 100,
                      max: 10000,
                      divisions: 100,
                      onChanged: (RangeValues values) {
                        setDialogState(() {
                          tempPriceRange = values;
                          tempMinPriceController.text = values.start.round().toString();
                          tempMaxPriceController.text = values.end.round().toString();
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            controller: tempMinPriceController,
                            keyboardType: TextInputType.number,
                            focusNode: focusNodeMin,
                            onTapOutside: (event) {
                              focusNodeMin.unfocus();
                            },
                            decoration: InputDecoration(
                              label: Text("Min Price", style: theme.textTheme.bodySmall),
                            ),
                            onChanged: (value) {
                              double minValue = double.tryParse(value) ?? 100;
                              minValue = minValue.clamp(100, tempPriceRange.end);
                              setDialogState(() {
                                tempPriceRange = RangeValues(minValue, tempPriceRange.end);
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 80,
                          child: TextFormField(
                            controller: tempMaxPriceController,
                            keyboardType: TextInputType.number,
                            focusNode: focusNodeMax,
                            onTapOutside: (event) {
                              focusNodeMax.unfocus();
                            },
                            style: theme.textTheme.bodyMedium,
                            decoration: InputDecoration(
                              label: Text("Max Price", style: theme.textTheme.bodySmall),
                            ),
                            onChanged: (value) {
                              double maxValue = double.tryParse(value) ?? 10000;
                              maxValue = maxValue.clamp(tempPriceRange.start, 10000);
                              setDialogState(() {
                                tempPriceRange = RangeValues(tempPriceRange.start, maxValue);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Rest of the filters...
                  const SizedBox(height: 16),
                  Text('Area: ${tempSizeRange.start.round()} m² - ${tempSizeRange.end.round()} m²',
                      style: theme.textTheme.titleSmall),
                  RangeSlider(
                    values: tempSizeRange,
                    min: 30,
                    max: 500,
                    divisions: 50,
                    onChanged: (RangeValues values) {
                      setDialogState(() {
                        tempSizeRange = values;
                      });
                    },
                  ),
                  Text(
                      'Rooms: ${tempBedroomsRange.start.round()} - ${tempBedroomsRange.end.round()}',
                      style: theme.textTheme.titleSmall),
                  RangeSlider(
                    values: tempBedroomsRange,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (RangeValues values) {
                      setDialogState(() {
                        tempBedroomsRange = values;
                      });
                    },
                  ),
                  // Floor Filter
                  Text(
                      'Floor: ${tempFloorRange.start.round()} - ${tempFloorRange.end.round()}',
                      style: theme.textTheme.titleSmall),
                  RangeSlider(
                    values: tempFloorRange,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (RangeValues values) {
                      setDialogState(() {
                        tempFloorRange = values;
                      });
                    },
                  ),
                  // Boolean filters for house features
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row for selecting a region with reset icon
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              value: tempSelectedRegion.isNotEmpty
                                  ? tempSelectedRegion
                                  : null,
                              hint: Text("Select Region",
                                  style: theme.textTheme.titleMedium),
                              items: regionsAndDistricts.keys
                                  .map((String region) {
                                return DropdownMenuItem<String>(
                                  value: region,
                                  child: Text(region,
                                      style: theme.textTheme.titleMedium),
                                );
                              }).toList(),
                              onChanged: (String? newRegion) {
                                setDialogState(() {
                                  tempSelectedRegion = newRegion ?? "";
                                  tempSelectedDistrict =
                                  ""; // Reset district when region changes
                                });
                              },
                            ),
                          ),
                          if (tempSelectedRegion
                              .isNotEmpty) // Show "x" icon only when a region is selected
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setDialogState(() {
                                  tempSelectedRegion = ""; // Reset region
                                  tempSelectedDistrict = ""; // Reset district
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      if (tempSelectedRegion.isNotEmpty)
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                value: tempSelectedDistrict.isNotEmpty
                                    ? tempSelectedDistrict
                                    : null,
                                hint: Text("Select District",
                                    style: theme.textTheme.titleMedium),
                                items:
                                regionsAndDistricts[tempSelectedRegion]!
                                    .map((String district) {
                                  return DropdownMenuItem<String>(
                                    value: district,
                                    child: Text(district,
                                        style: theme.textTheme.titleMedium),
                                  );
                                }).toList(),
                                onChanged: (String? newDistrict) {
                                  setDialogState(() {
                                    tempSelectedDistrict = newDistrict ?? "";
                                  });
                                },
                              ),
                            ),
                            if (tempSelectedDistrict
                                .isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setDialogState(() {
                                    tempSelectedDistrict =
                                    "";
                                  });
                                },
                              ),
                          ],
                        ),
                    ],
                  ),

                  CheckboxListTile(
                    title: Text('Has Parking',
                        style: theme.textTheme.titleMedium),
                    value: tempHasParking,
                    onChanged: (bool? value) {
                      setDialogState(() {
                        tempHasParking = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Is Furnished',
                        style: theme.textTheme.titleMedium),
                    value: tempIsFurnished,
                    onChanged: (bool? value) {
                      setDialogState(() {
                        tempIsFurnished = value ?? false;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('3D View Available',
                        style: theme.textTheme.titleMedium),
                    value: tempIs3D,
                    onChanged: (bool? value) {
                      setDialogState(() {
                        tempIs3D = value ?? false;
                      });
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment :', style: theme.textTheme.bodyLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Monthly',
                                  style: theme.textTheme.bodyMedium),
                              Checkbox(
                                value: tempIsMonthlyPayment,
                                onChanged: (bool? value) {
                                  setDialogState(() {
                                    tempIsMonthlyPayment = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Daily',
                                  style: theme.textTheme.bodyMedium),
                              Checkbox(
                                value: tempIsDailyPayment,
                                onChanged: (bool? value) {
                                  setDialogState(() {
                                    tempIsDailyPayment = value ?? false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Map<String, dynamic> resetFilters = {
                'priceRange': const RangeValues(100, 10000),
                'sizeRange': const RangeValues(30, 500),
                'bedroomsRange': const RangeValues(1, 10),
                'floorRange': const RangeValues(0, 10),
                'hasParking': false,
                'isFurnished': false,
                'isForRent': false,
                'isForSale': false,
                'isMonthlyPayment': false,
                'isDailyPayment': false,
                'is3D': false,
                'selectedDistrict': "",
                'selectedRegion': "",
              };
              Navigator.of(context).pop(resetFilters);
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () {
              Map<String, dynamic> appliedFilters = {
                if (tempIsForRent) 'priceRange': tempPriceRange,
                'sizeRange': tempSizeRange,
                'bedroomsRange': tempBedroomsRange,
                'floorRange': tempFloorRange,
                'hasParking': tempHasParking,
                'isFurnished': tempIsFurnished,
                'isForRent': tempIsForRent,
                'isForSale': tempIsForSale,
                'isMonthlyPayment': tempIsMonthlyPayment,
                'isDailyPayment': tempIsDailyPayment,
                'is3D': tempIs3D,
                'selectedDistrict': tempSelectedDistrict,
                'selectedRegion': tempSelectedRegion,
              };
              Navigator.of(context).pop(appliedFilters);
            },
            child: const Text('Apply'),
          ),
        ],
      );
    },
  );
}