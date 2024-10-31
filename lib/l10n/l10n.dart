// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Inbox`
  String get inbox {
    return Intl.message(
      'Inbox',
      name: 'inbox',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Available`
  String get available {
    return Intl.message(
      'Available',
      name: 'available',
      desc: '',
      args: [],
    );
  }

  /// `Enable this if your house is available`
  String get availableHint {
    return Intl.message(
      'Enable this if your house is available',
      name: 'availableHint',
      desc: '',
      args: [],
    );
  }

  /// `House Specifications`
  String get houseSpecifications {
    return Intl.message(
      'House Specifications',
      name: 'houseSpecifications',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Living Room`
  String get livingRoom {
    return Intl.message(
      'Living Room',
      name: 'livingRoom',
      desc: '',
      args: [],
    );
  }

  /// `Bedrooms`
  String get bedrooms {
    return Intl.message(
      'Bedrooms',
      name: 'bedrooms',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get floor {
    return Intl.message(
      'Floor',
      name: 'floor',
      desc: '',
      args: [],
    );
  }

  /// `Area`
  String get area {
    return Intl.message(
      'Area',
      name: 'area',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `For Sale`
  String get forSale {
    return Intl.message(
      'For Sale',
      name: 'forSale',
      desc: '',
      args: [],
    );
  }

  /// `For Rent`
  String get forRent {
    return Intl.message(
      'For Rent',
      name: 'forRent',
      desc: '',
      args: [],
    );
  }

  /// `Sale Price`
  String get salePrice {
    return Intl.message(
      'Sale Price',
      name: 'salePrice',
      desc: '',
      args: [],
    );
  }

  /// `Rent Price`
  String get rentPrice {
    return Intl.message(
      'Rent Price',
      name: 'rentPrice',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a sale price`
  String get enterSalePrice {
    return Intl.message(
      'Please enter a sale price',
      name: 'enterSalePrice',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a rent price`
  String get enterRentPrice {
    return Intl.message(
      'Please enter a rent price',
      name: 'enterRentPrice',
      desc: '',
      args: [],
    );
  }

  /// `Furnished`
  String get furnished {
    return Intl.message(
      'Furnished',
      name: 'furnished',
      desc: '',
      args: [],
    );
  }

  /// `Add Furniture`
  String get addFurniture {
    return Intl.message(
      'Add Furniture',
      name: 'addFurniture',
      desc: '',
      args: [],
    );
  }

  /// `Add Feature`
  String get addFeature {
    return Intl.message(
      'Add Feature',
      name: 'addFeature',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Update House Details`
  String get updateHouseDetails {
    return Intl.message(
      'Update House Details',
      name: 'updateHouseDetails',
      desc: '',
      args: [],
    );
  }

  /// `Delete House`
  String get deleteHouse {
    return Intl.message(
      'Delete House',
      name: 'deleteHouse',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this house listing?`
  String get deleteHouseConfirmation {
    return Intl.message(
      'Are you sure you want to delete this house listing?',
      name: 'deleteHouseConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `{name}'s house`
  String ownerHouse(Object name) {
    return Intl.message(
      '$name\'s house',
      name: 'ownerHouse',
      desc: '',
      args: [name],
    );
  }

  /// `Owner Comment`
  String get ownerComment {
    return Intl.message(
      'Owner Comment',
      name: 'ownerComment',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `{price} TND`
  String priceValue(Object price) {
    return Intl.message(
      '$price TND',
      name: 'priceValue',
      desc: '',
      args: [price],
    );
  }

  /// `Furniture`
  String get furniture {
    return Intl.message(
      'Furniture',
      name: 'furniture',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get options {
    return Intl.message(
      'Options',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `Owner Information`
  String get ownerInformation {
    return Intl.message(
      'Owner Information',
      name: 'ownerInformation',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `We're uploading your House, please wait...`
  String get weReUploadingWait {
    return Intl.message(
      'We\'re uploading your House, please wait...',
      name: 'weReUploadingWait',
      desc: '',
      args: [],
    );
  }

  /// `Upload House Listing`
  String get uploadHouseListing {
    return Intl.message(
      'Upload House Listing',
      name: 'uploadHouseListing',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Is Available`
  String get isAvailable {
    return Intl.message(
      'Is Available',
      name: 'isAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Payment`
  String get monthlyPayment {
    return Intl.message(
      'Monthly Payment',
      name: 'monthlyPayment',
      desc: '',
      args: [],
    );
  }

  /// `Daily Payment`
  String get dailyPayment {
    return Intl.message(
      'Daily Payment',
      name: 'dailyPayment',
      desc: '',
      args: [],
    );
  }

  /// `Use Current Location`
  String get useCurrentLocation {
    return Intl.message(
      'Use Current Location',
      name: 'useCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Pick Custom Location`
  String get pickCustomLocation {
    return Intl.message(
      'Pick Custom Location',
      name: 'pickCustomLocation',
      desc: '',
      args: [],
    );
  }

  /// `villa, apartment, studio...`
  String get hintText {
    return Intl.message(
      'villa, apartment, studio...',
      name: 'hintText',
      desc: '',
      args: [],
    );
  }

  /// `Owner information will be automatically filled based on your account details.`
  String get ownerInfoMessage {
    return Intl.message(
      'Owner information will be automatically filled based on your account details.',
      name: 'ownerInfoMessage',
      desc: '',
      args: [],
    );
  }

  /// `in`
  String get justIn {
    return Intl.message(
      'in',
      name: 'justIn',
      desc: '',
      args: [],
    );
  }

  /// `Basic Information`
  String get basicInformation {
    return Intl.message(
      'Basic Information',
      name: 'basicInformation',
      desc: '',
      args: [],
    );
  }

  /// `Main Image`
  String get mainImage {
    return Intl.message(
      'Main Image',
      name: 'mainImage',
      desc: '',
      args: [],
    );
  }

  /// `Add Main Image`
  String get addMainImage {
    return Intl.message(
      'Add Main Image',
      name: 'addMainImage',
      desc: '',
      args: [],
    );
  }

  /// `Additional Images`
  String get additionalImages {
    return Intl.message(
      'Additional Images',
      name: 'additionalImages',
      desc: '',
      args: [],
    );
  }

  /// `Main`
  String get main {
    return Intl.message(
      'Main',
      name: 'main',
      desc: '',
      args: [],
    );
  }

  /// `No additional images selected`
  String get noAdditionalImages {
    return Intl.message(
      'No additional images selected',
      name: 'noAdditionalImages',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get justContinue {
    return Intl.message(
      'Continue',
      name: 'justContinue',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `The house has a living room ?`
  String get hasLivingRoom {
    return Intl.message(
      'The house has a living room ?',
      name: 'hasLivingRoom',
      desc: '',
      args: [],
    );
  }

  /// `The house has a parking ?`
  String get hasParking {
    return Intl.message(
      'The house has a parking ?',
      name: 'hasParking',
      desc: '',
      args: [],
    );
  }

  /// `Does it have a WiFi ?`
  String get hasWifi {
    return Intl.message(
      'Does it have a WiFi ?',
      name: 'hasWifi',
      desc: '',
      args: [],
    );
  }

  /// `Is it Furnished ?`
  String get isFurnished {
    return Intl.message(
      'Is it Furnished ?',
      name: 'isFurnished',
      desc: '',
      args: [],
    );
  }

  /// `Add Features`
  String get addFeatures {
    return Intl.message(
      'Add Features',
      name: 'addFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Garage, 2 Rooms, 2 Toilets...`
  String get garageFeatures {
    return Intl.message(
      'Garage, 2 Rooms, 2 Toilets...',
      name: 'garageFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Fridge, TV, Table....`
  String get furnitureItems {
    return Intl.message(
      'Fridge, TV, Table....',
      name: 'furnitureItems',
      desc: '',
      args: [],
    );
  }

  /// `0 if no rooms`
  String get noRooms {
    return Intl.message(
      '0 if no rooms',
      name: 'noRooms',
      desc: '',
      args: [],
    );
  }

  /// `0 for ground floor`
  String get groundFloor {
    return Intl.message(
      '0 for ground floor',
      name: 'groundFloor',
      desc: '',
      args: [],
    );
  }

  /// `Not logged in...`
  String get notLoggedIn {
    return Intl.message(
      'Not logged in...',
      name: 'notLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `House listing uploaded successfully!`
  String get houseUploadedSuccess {
    return Intl.message(
      'House listing uploaded successfully!',
      name: 'houseUploadedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error uploading house listing`
  String get errorUploadingHouse {
    return Intl.message(
      'Error uploading house listing',
      name: 'errorUploadingHouse',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Error Fetching house details`
  String get errorFetchingHouses {
    return Intl.message(
      'Error Fetching house details',
      name: 'errorFetchingHouses',
      desc: '',
      args: [],
    );
  }

  /// `House deleted successfully!`
  String get houseDeleteSuccess {
    return Intl.message(
      'House deleted successfully!',
      name: 'houseDeleteSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting house`
  String get errorDeletingHouse {
    return Intl.message(
      'Error deleting house',
      name: 'errorDeletingHouse',
      desc: '',
      args: [],
    );
  }

  /// `Error checking favorite status: {error}`
  String errorCheckingFavoriteStatus(Object error) {
    return Intl.message(
      'Error checking favorite status: $error',
      name: 'errorCheckingFavoriteStatus',
      desc: '',
      args: [error],
    );
  }

  /// `Added to favorites`
  String get addedToFavorites {
    return Intl.message(
      'Added to favorites',
      name: 'addedToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Removed from favorites`
  String get removedFromFavorites {
    return Intl.message(
      'Removed from favorites',
      name: 'removedFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Error updating favorite status: {error}`
  String errorUpdatingFavoriteStatus(Object error) {
    return Intl.message(
      'Error updating favorite status: $error',
      name: 'errorUpdatingFavoriteStatus',
      desc: '',
      args: [error],
    );
  }

  /// `change to another location`
  String get changeToAnotherLoc {
    return Intl.message(
      'change to another location',
      name: 'changeToAnotherLoc',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load search results`
  String get failedToLoadSearchResults {
    return Intl.message(
      'Failed to load search results',
      name: 'failedToLoadSearchResults',
      desc: '',
      args: [],
    );
  }

  /// `Error searching for places`
  String get errorSearchingForPlaces {
    return Intl.message(
      'Error searching for places',
      name: 'errorSearchingForPlaces',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `My Houses`
  String get myHouses {
    return Intl.message(
      'My Houses',
      name: 'myHouses',
      desc: '',
      args: [],
    );
  }

  /// `Favourite Houses`
  String get favouriteHouses {
    return Intl.message(
      'Favourite Houses',
      name: 'favouriteHouses',
      desc: '',
      args: [],
    );
  }

  /// `Personal Account`
  String get personalAccount {
    return Intl.message(
      'Personal Account',
      name: 'personalAccount',
      desc: '',
      args: [],
    );
  }

  /// `Contact Support`
  String get contactSupport {
    return Intl.message(
      'Contact Support',
      name: 'contactSupport',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Error loading user data: {e}`
  String errorLoadingUserData(Object e) {
    return Intl.message(
      'Error loading user data: $e',
      name: 'errorLoadingUserData',
      desc: '',
      args: [e],
    );
  }

  /// `Error signing out: {e}`
  String errorSigningOut(Object e) {
    return Intl.message(
      'Error signing out: $e',
      name: 'errorSigningOut',
      desc: '',
      args: [e],
    );
  }

  /// `Are you sure you want to logout?`
  String get logoutConfirmation {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'logoutConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `No results found`
  String get noResultsFound {
    return Intl.message(
      'No results found',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }

  /// `Try adjusting your search or filters`
  String get adjustSearchOrFilters {
    return Intl.message(
      'Try adjusting your search or filters',
      name: 'adjustSearchOrFilters',
      desc: '',
      args: [],
    );
  }

  /// `No more houses found`
  String get noMoreHousesFound {
    return Intl.message(
      'No more houses found',
      name: 'noMoreHousesFound',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Sorting`
  String get sorting {
    return Intl.message(
      'Sorting',
      name: 'sorting',
      desc: '',
      args: [],
    );
  }

  /// `Max Distance: {e} Km`
  String maxDistance(Object e) {
    return Intl.message(
      'Max Distance: $e Km',
      name: 'maxDistance',
      desc: '',
      args: [e],
    );
  }

  /// `Sort by:`
  String get sortBy {
    return Intl.message(
      'Sort by:',
      name: 'sortBy',
      desc: '',
      args: [],
    );
  }

  /// `Distance`
  String get distance {
    return Intl.message(
      'Distance',
      name: 'distance',
      desc: '',
      args: [],
    );
  }

  /// `Support request sent successfully!`
  String get supportRequestSent {
    return Intl.message(
      'Support request sent successfully!',
      name: 'supportRequestSent',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send support request. Please try again.`
  String get supportRequestFailed {
    return Intl.message(
      'Failed to send support request. Please try again.',
      name: 'supportRequestFailed',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enterName {
    return Intl.message(
      'Enter your name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Subject`
  String get subject {
    return Intl.message(
      'Subject',
      name: 'subject',
      desc: '',
      args: [],
    );
  }

  /// `Enter the subject`
  String get enterSubject {
    return Intl.message(
      'Enter the subject',
      name: 'enterSubject',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Describe your issue`
  String get describeIssue {
    return Intl.message(
      'Describe your issue',
      name: 'describeIssue',
      desc: '',
      args: [],
    );
  }

  /// `Or contact Us directly`
  String get contactUsDirectly {
    return Intl.message(
      'Or contact Us directly',
      name: 'contactUsDirectly',
      desc: '',
      args: [],
    );
  }

  /// `{e} is required`
  String fieldRequired(Object e) {
    return Intl.message(
      '$e is required',
      name: 'fieldRequired',
      desc: '',
      args: [e],
    );
  }

  /// `Enter a valid email address`
  String get invalidEmail {
    return Intl.message(
      'Enter a valid email address',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Authentication failed`
  String get authFailed {
    return Intl.message(
      'Authentication failed',
      name: 'authFailed',
      desc: '',
      args: [],
    );
  }

  /// `Error sending verification code`
  String get verificationCodeError {
    return Intl.message(
      'Error sending verification code',
      name: 'verificationCodeError',
      desc: '',
      args: [],
    );
  }

  /// `Phone number updated successfully`
  String get phoneUpdateSuccess {
    return Intl.message(
      'Phone number updated successfully',
      name: 'phoneUpdateSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get updateError {
    return Intl.message(
      'Error',
      name: 'updateError',
      desc: '',
      args: [],
    );
  }

  /// `Wrong password`
  String get wrongPassword {
    return Intl.message(
      'Wrong password',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get profileUpdatedSuccessfully {
    return Intl.message(
      'Profile updated successfully',
      name: 'profileUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error updating profile`
  String get errorUpdatingProfile {
    return Intl.message(
      'Error updating profile',
      name: 'errorUpdatingProfile',
      desc: '',
      args: [],
    );
  }

  /// `Password updated successfully`
  String get passwordUpdatedSuccessfully {
    return Intl.message(
      'Password updated successfully',
      name: 'passwordUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error updating password: {error}`
  String errorUpdatingPassword(Object error) {
    return Intl.message(
      'Error updating password: $error',
      name: 'errorUpdatingPassword',
      desc: '',
      args: [error],
    );
  }

  /// `Edit Personal Account`
  String get editProfile {
    return Intl.message(
      'Edit Personal Account',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Middle Name (optional)`
  String get middleName {
    return Intl.message(
      'Middle Name (optional)',
      name: 'middleName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Type your password to apply changes`
  String get typeYourPasswordToApplyChanges {
    return Intl.message(
      'Type your password to apply changes',
      name: 'typeYourPasswordToApplyChanges',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Apply Changes`
  String get applyChanges {
    return Intl.message(
      'Apply Changes',
      name: 'applyChanges',
      desc: '',
      args: [],
    );
  }

  /// `Select Image Source`
  String get selectImageSource {
    return Intl.message(
      'Select Image Source',
      name: 'selectImageSource',
      desc: '',
      args: [],
    );
  }

  /// `Choose an image source`
  String get chooseAnImageSource {
    return Intl.message(
      'Choose an image source',
      name: 'chooseAnImageSource',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get oldPassword {
    return Intl.message(
      'Old Password',
      name: 'oldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get confirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'confirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to recover your password`
  String get enterYourEmailToRecoverPassword {
    return Intl.message(
      'Enter your email to recover your password',
      name: 'enterYourEmailToRecoverPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password recovery email sent successfully`
  String get passwordRecoveryEmailSentSuccessfully {
    return Intl.message(
      'Password recovery email sent successfully',
      name: 'passwordRecoveryEmailSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Error sending password recovery email: {error}`
  String errorSendingPasswordRecoveryEmail(Object error) {
    return Intl.message(
      'Error sending password recovery email: $error',
      name: 'errorSendingPasswordRecoveryEmail',
      desc: '',
      args: [error],
    );
  }

  /// `Send Recovery Email`
  String get sendRecoveryEmail {
    return Intl.message(
      'Send Recovery Email',
      name: 'sendRecoveryEmail',
      desc: '',
      args: [],
    );
  }

  /// `Select your phone code`
  String get selectYourPhoneCode {
    return Intl.message(
      'Select your phone code',
      name: 'selectYourPhoneCode',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
