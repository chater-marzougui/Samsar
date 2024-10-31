// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(error) => "Error checking favorite status: ${error}";

  static String m1(error) => "Error updating favorite status: ${error}";

  static String m2(name) => "${name}\'s house";

  static String m3(price) => "${price} TND";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("Add"),
        "addFeature": MessageLookupByLibrary.simpleMessage("Add Feature"),
        "addFeatures": MessageLookupByLibrary.simpleMessage("Add Features"),
        "addFurniture": MessageLookupByLibrary.simpleMessage("Add Furniture"),
        "addMainImage": MessageLookupByLibrary.simpleMessage("Add Main Image"),
        "addedToFavorites":
            MessageLookupByLibrary.simpleMessage("Added to favorites"),
        "additionalImages":
            MessageLookupByLibrary.simpleMessage("Additional Images"),
        "address": MessageLookupByLibrary.simpleMessage("Address"),
        "area": MessageLookupByLibrary.simpleMessage("Area"),
        "available": MessageLookupByLibrary.simpleMessage("Available"),
        "availableHint": MessageLookupByLibrary.simpleMessage(
            "Enable this if your house is available"),
        "back": MessageLookupByLibrary.simpleMessage("Back"),
        "basicInformation":
            MessageLookupByLibrary.simpleMessage("Basic Information"),
        "bedrooms": MessageLookupByLibrary.simpleMessage("Bedrooms"),
        "camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "city": MessageLookupByLibrary.simpleMessage("City"),
        "comment": MessageLookupByLibrary.simpleMessage("Comment"),
        "dailyPayment": MessageLookupByLibrary.simpleMessage("Daily Payment"),
        "delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "deleteHouse": MessageLookupByLibrary.simpleMessage("Delete House"),
        "deleteHouseConfirmation": MessageLookupByLibrary.simpleMessage(
            "Are you sure you want to delete this house listing?"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "enterRentPrice":
            MessageLookupByLibrary.simpleMessage("Please enter a rent price"),
        "enterSalePrice":
            MessageLookupByLibrary.simpleMessage("Please enter a sale price"),
        "errorCheckingFavoriteStatus": m0,
        "errorDeletingHouse":
            MessageLookupByLibrary.simpleMessage("Error deleting house"),
        "errorFetchingHouses": MessageLookupByLibrary.simpleMessage(
            "Error Fetching house details"),
        "errorUpdatingFavoriteStatus": m1,
        "errorUploadingHouse": MessageLookupByLibrary.simpleMessage(
            "Error uploading house listing"),
        "floor": MessageLookupByLibrary.simpleMessage("Floor"),
        "forRent": MessageLookupByLibrary.simpleMessage("For Rent"),
        "forSale": MessageLookupByLibrary.simpleMessage("For Sale"),
        "furnished": MessageLookupByLibrary.simpleMessage("Furnished"),
        "furniture": MessageLookupByLibrary.simpleMessage("Furniture"),
        "furnitureItems":
            MessageLookupByLibrary.simpleMessage("Fridge, TV, Table...."),
        "gallery": MessageLookupByLibrary.simpleMessage("Gallery"),
        "garageFeatures": MessageLookupByLibrary.simpleMessage(
            "Garage, 2 Rooms, 2 Toilets..."),
        "groundFloor":
            MessageLookupByLibrary.simpleMessage("0 for ground floor"),
        "hasLivingRoom": MessageLookupByLibrary.simpleMessage(
            "The house has a living room ?"),
        "hasParking":
            MessageLookupByLibrary.simpleMessage("The house has a parking ?"),
        "hasWifi":
            MessageLookupByLibrary.simpleMessage("Does it have a WiFi ?"),
        "hintText":
            MessageLookupByLibrary.simpleMessage("villa, apartment, studio..."),
        "home": MessageLookupByLibrary.simpleMessage("Home"),
        "houseDeleteSuccess":
            MessageLookupByLibrary.simpleMessage("House deleted successfully!"),
        "houseSpecifications":
            MessageLookupByLibrary.simpleMessage("House Specifications"),
        "houseUploadedSuccess": MessageLookupByLibrary.simpleMessage(
            "House listing uploaded successfully!"),
        "inbox": MessageLookupByLibrary.simpleMessage("Inbox"),
        "isAvailable": MessageLookupByLibrary.simpleMessage("Is Available"),
        "isFurnished":
            MessageLookupByLibrary.simpleMessage("Is it Furnished ?"),
        "justContinue": MessageLookupByLibrary.simpleMessage("Continue"),
        "justIn": MessageLookupByLibrary.simpleMessage("in"),
        "livingRoom": MessageLookupByLibrary.simpleMessage("Living Room"),
        "location": MessageLookupByLibrary.simpleMessage("Location"),
        "main": MessageLookupByLibrary.simpleMessage("Main"),
        "mainImage": MessageLookupByLibrary.simpleMessage("Main Image"),
        "monthlyPayment":
            MessageLookupByLibrary.simpleMessage("Monthly Payment"),
        "name": MessageLookupByLibrary.simpleMessage("Name"),
        "no": MessageLookupByLibrary.simpleMessage("No"),
        "noAdditionalImages": MessageLookupByLibrary.simpleMessage(
            "No additional images selected"),
        "noRooms": MessageLookupByLibrary.simpleMessage("0 if no rooms"),
        "notLoggedIn": MessageLookupByLibrary.simpleMessage("Not logged in..."),
        "options": MessageLookupByLibrary.simpleMessage("Options"),
        "ownerComment": MessageLookupByLibrary.simpleMessage("Owner Comment"),
        "ownerHouse": m2,
        "ownerInfoMessage": MessageLookupByLibrary.simpleMessage(
            "Owner information will be automatically filled based on your account details."),
        "ownerInformation":
            MessageLookupByLibrary.simpleMessage("Owner Information"),
        "phone": MessageLookupByLibrary.simpleMessage("Phone"),
        "pickCustomLocation":
            MessageLookupByLibrary.simpleMessage("Pick Custom Location"),
        "price": MessageLookupByLibrary.simpleMessage("Price"),
        "priceValue": m3,
        "profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "removedFromFavorites":
            MessageLookupByLibrary.simpleMessage("Removed from favorites"),
        "rentPrice": MessageLookupByLibrary.simpleMessage("Rent Price"),
        "salePrice": MessageLookupByLibrary.simpleMessage("Sale Price"),
        "saveChanges": MessageLookupByLibrary.simpleMessage("Save Changes"),
        "search": MessageLookupByLibrary.simpleMessage("Search"),
        "status": MessageLookupByLibrary.simpleMessage("Status"),
        "submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "update": MessageLookupByLibrary.simpleMessage("Update"),
        "updateHouseDetails":
            MessageLookupByLibrary.simpleMessage("Update House Details"),
        "uploadHouseListing":
            MessageLookupByLibrary.simpleMessage("Upload House Listing"),
        "useCurrentLocation":
            MessageLookupByLibrary.simpleMessage("Use Current Location"),
        "weReUploadingWait": MessageLookupByLibrary.simpleMessage(
            "We\'re uploading your House, please wait..."),
        "yes": MessageLookupByLibrary.simpleMessage("Yes")
      };
}
