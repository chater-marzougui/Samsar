// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
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
  String get localeName => 'fr';

  static String m0(error) =>
      "Erreur lors de la vérification de l\'état favori : ${error}";

  static String m1(error) =>
      "Erreur lors de la mise à jour de l\'état favori : ${error}";

  static String m2(name) => "Maison de ${name}";

  static String m3(price) => "${price} TND";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("Ajouter"),
        "addFeature":
            MessageLookupByLibrary.simpleMessage("Ajouter une caractéristique"),
        "addFeatures": MessageLookupByLibrary.simpleMessage(
            "Ajouter des caractéristiques"),
        "addFurniture":
            MessageLookupByLibrary.simpleMessage("Ajouter des meubles"),
        "addMainImage": MessageLookupByLibrary.simpleMessage(
            "Ajouter une image principale"),
        "addedToFavorites":
            MessageLookupByLibrary.simpleMessage("Ajouté aux favoris"),
        "additionalImages":
            MessageLookupByLibrary.simpleMessage("Images supplémentaires"),
        "address": MessageLookupByLibrary.simpleMessage("Adresse"),
        "area": MessageLookupByLibrary.simpleMessage("Surface"),
        "available": MessageLookupByLibrary.simpleMessage("Disponible"),
        "availableHint": MessageLookupByLibrary.simpleMessage(
            "Activez si votre maison est disponible"),
        "back": MessageLookupByLibrary.simpleMessage("Retour"),
        "basicInformation":
            MessageLookupByLibrary.simpleMessage("Informations de base"),
        "bedrooms": MessageLookupByLibrary.simpleMessage("Chambres"),
        "camera": MessageLookupByLibrary.simpleMessage("Appareil photo"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "city": MessageLookupByLibrary.simpleMessage("Ville"),
        "comment": MessageLookupByLibrary.simpleMessage("Commentaire"),
        "dailyPayment":
            MessageLookupByLibrary.simpleMessage("Paiement quotidien"),
        "delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "deleteHouse":
            MessageLookupByLibrary.simpleMessage("Supprimer la maison"),
        "deleteHouseConfirmation": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous sûr de vouloir supprimer cette annonce ?"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "enterRentPrice": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer un prix de location"),
        "enterSalePrice": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer un prix de vente"),
        "errorCheckingFavoriteStatus": m0,
        "errorDeletingHouse": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la suppression de la maison"),
        "errorFetchingHouses": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la récupération des données"),
        "errorUpdatingFavoriteStatus": m1,
        "errorUploadingHouse": MessageLookupByLibrary.simpleMessage(
            "Erreur lors du téléchargement de l\'annonce de la maison"),
        "floor": MessageLookupByLibrary.simpleMessage("Étage"),
        "forRent": MessageLookupByLibrary.simpleMessage("À louer"),
        "forSale": MessageLookupByLibrary.simpleMessage("À vendre"),
        "furnished": MessageLookupByLibrary.simpleMessage("Meublé"),
        "furniture": MessageLookupByLibrary.simpleMessage("Meubles"),
        "furnitureItems":
            MessageLookupByLibrary.simpleMessage("Frigo, TV, Table...."),
        "gallery": MessageLookupByLibrary.simpleMessage("Galerie"),
        "garageFeatures": MessageLookupByLibrary.simpleMessage(
            "Garage, 2 Salles, 2 Toilettes..."),
        "groundFloor":
            MessageLookupByLibrary.simpleMessage("0 pour le rez-de-chaussée"),
        "hasLivingRoom":
            MessageLookupByLibrary.simpleMessage("La maison a un salon ?"),
        "hasParking":
            MessageLookupByLibrary.simpleMessage("La maison a un parking ?"),
        "hasWifi":
            MessageLookupByLibrary.simpleMessage("Est-ce qu\'il y a du WiFi ?"),
        "hintText": MessageLookupByLibrary.simpleMessage(
            "villa, appartement, studio..."),
        "home": MessageLookupByLibrary.simpleMessage("Accueil"),
        "houseDeleteSuccess": MessageLookupByLibrary.simpleMessage(
            "Maison supprimée avec succès !"),
        "houseSpecifications":
            MessageLookupByLibrary.simpleMessage("Spécifications de la maison"),
        "houseUploadedSuccess": MessageLookupByLibrary.simpleMessage(
            "Annonce de maison téléchargée avec succès !"),
        "inbox": MessageLookupByLibrary.simpleMessage("Messages"),
        "isAvailable": MessageLookupByLibrary.simpleMessage("Disponible"),
        "isFurnished": MessageLookupByLibrary.simpleMessage("Est-ce meublé ?"),
        "justContinue": MessageLookupByLibrary.simpleMessage("Continuer"),
        "justIn": MessageLookupByLibrary.simpleMessage("en"),
        "livingRoom": MessageLookupByLibrary.simpleMessage("Salon"),
        "location": MessageLookupByLibrary.simpleMessage("Emplacement"),
        "main": MessageLookupByLibrary.simpleMessage("Principale"),
        "mainImage": MessageLookupByLibrary.simpleMessage("Image principale"),
        "monthlyPayment":
            MessageLookupByLibrary.simpleMessage("Paiement mensuel"),
        "name": MessageLookupByLibrary.simpleMessage("Nom"),
        "no": MessageLookupByLibrary.simpleMessage("Non"),
        "noAdditionalImages": MessageLookupByLibrary.simpleMessage(
            "Aucune image supplémentaire sélectionnée"),
        "noRooms": MessageLookupByLibrary.simpleMessage(
            "0 s\'il n\'y a pas de chambres"),
        "notLoggedIn":
            MessageLookupByLibrary.simpleMessage("Non authentifié..."),
        "options": MessageLookupByLibrary.simpleMessage("Options"),
        "ownerComment":
            MessageLookupByLibrary.simpleMessage("Commentaire du propriétaire"),
        "ownerHouse": m2,
        "ownerInfoMessage": MessageLookupByLibrary.simpleMessage(
            "Les informations sur le propriétaire seront automatiquement remplies en fonction des détails de votre compte."),
        "ownerInformation": MessageLookupByLibrary.simpleMessage(
            "Informations du propriétaire"),
        "phone": MessageLookupByLibrary.simpleMessage("Téléphone"),
        "pickCustomLocation": MessageLookupByLibrary.simpleMessage(
            "Choisir un emplacement personnalisé"),
        "price": MessageLookupByLibrary.simpleMessage("Prix"),
        "priceValue": m3,
        "profile": MessageLookupByLibrary.simpleMessage("Profil"),
        "removedFromFavorites":
            MessageLookupByLibrary.simpleMessage("Retiré des favoris"),
        "rentPrice": MessageLookupByLibrary.simpleMessage("Prix de location"),
        "salePrice": MessageLookupByLibrary.simpleMessage("Prix de vente"),
        "saveChanges": MessageLookupByLibrary.simpleMessage(
            "Enregistrer les modifications"),
        "search": MessageLookupByLibrary.simpleMessage("Recherche"),
        "status": MessageLookupByLibrary.simpleMessage("État"),
        "submit": MessageLookupByLibrary.simpleMessage("Soumettre"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "update": MessageLookupByLibrary.simpleMessage("mise à jour"),
        "updateHouseDetails":
            MessageLookupByLibrary.simpleMessage("Mettre à jour les détails"),
        "uploadHouseListing":
            MessageLookupByLibrary.simpleMessage("Téléchargez une manie"),
        "useCurrentLocation": MessageLookupByLibrary.simpleMessage(
            "Utiliser la position actuelle"),
        "weReUploadingWait": MessageLookupByLibrary.simpleMessage(
            "Nous téléchargeons votre maison, veuillez patienter..."),
        "yes": MessageLookupByLibrary.simpleMessage("Oui")
      };
}
