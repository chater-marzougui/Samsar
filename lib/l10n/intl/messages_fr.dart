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

  static String m1(e) =>
      "Erreur lors du chargement des données utilisateur : ${e}";

  static String m2(error) =>
      "Erreur lors de l\'envoi de l\'e-mail de récupération du mot de passe: ${error}";

  static String m3(e) => "Erreur lors de la déconnexion : ${e}";

  static String m4(error) =>
      "Erreur lors de la mise à jour de l\'état favori : ${error}";

  static String m5(error) => "Erreur de mise à jour du mot de passe: ${error}";

  static String m6(e) => "${e} est requis";

  static String m7(e) => "Distance maximale : ${e} Km";

  static String m8(name) => "Maison de ${name}";

  static String m9(price) => "${price} TND";

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
        "adjustSearchOrFilters": MessageLookupByLibrary.simpleMessage(
            "Essayez d\'ajuster votre recherche ou vos filtres"),
        "apply": MessageLookupByLibrary.simpleMessage("Appliqué"),
        "applyChanges":
            MessageLookupByLibrary.simpleMessage("Appliquer les modifications"),
        "area": MessageLookupByLibrary.simpleMessage("Surface"),
        "authFailed": MessageLookupByLibrary.simpleMessage(
            "Échec de l\'authentification"),
        "available": MessageLookupByLibrary.simpleMessage("Disponible"),
        "availableHint": MessageLookupByLibrary.simpleMessage(
            "Activez si votre maison est disponible"),
        "back": MessageLookupByLibrary.simpleMessage("Retour"),
        "basicInformation":
            MessageLookupByLibrary.simpleMessage("Informations de base"),
        "bedrooms": MessageLookupByLibrary.simpleMessage("Chambres"),
        "camera": MessageLookupByLibrary.simpleMessage("Appareil photo"),
        "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
        "changeToAnotherLoc":
            MessageLookupByLibrary.simpleMessage("changer d\'emplacement"),
        "chooseAnImageSource": MessageLookupByLibrary.simpleMessage(
            "Choisissez une source d\'image"),
        "city": MessageLookupByLibrary.simpleMessage("Ville"),
        "comment": MessageLookupByLibrary.simpleMessage("Commentaire"),
        "confirmNewPassword": MessageLookupByLibrary.simpleMessage(
            "Confirmer le nouveau mot de passe"),
        "contactSupport":
            MessageLookupByLibrary.simpleMessage("Contacter le support"),
        "contactUsDirectly": MessageLookupByLibrary.simpleMessage(
            "Ou contactez-nous directement"),
        "dailyPayment":
            MessageLookupByLibrary.simpleMessage("Paiement quotidien"),
        "delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "deleteHouse":
            MessageLookupByLibrary.simpleMessage("Supprimer la maison"),
        "deleteHouseConfirmation": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous sûr de vouloir supprimer cette annonce ?"),
        "describeIssue":
            MessageLookupByLibrary.simpleMessage("Décrivez votre problème"),
        "distance": MessageLookupByLibrary.simpleMessage("Distance"),
        "editProfile":
            MessageLookupByLibrary.simpleMessage("Modifier le profil"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "enterEmail":
            MessageLookupByLibrary.simpleMessage("Entrez votre email"),
        "enterName": MessageLookupByLibrary.simpleMessage("Entrez votre nom"),
        "enterRentPrice": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer un prix de location"),
        "enterSalePrice": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer un prix de vente"),
        "enterSubject": MessageLookupByLibrary.simpleMessage("Entrez l\'objet"),
        "enterYourEmailToRecoverPassword": MessageLookupByLibrary.simpleMessage(
            "Entrez votre e-mail pour récupérer votre mot de passe"),
        "errorCheckingFavoriteStatus": m0,
        "errorDeletingHouse": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la suppression de la maison"),
        "errorFetchingHouses": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la récupération des données"),
        "errorLoadingUserData": m1,
        "errorSearchingForPlaces": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la recherche de lieux"),
        "errorSendingPasswordRecoveryEmail": m2,
        "errorSigningOut": m3,
        "errorUpdatingFavoriteStatus": m4,
        "errorUpdatingPassword": m5,
        "errorUpdatingProfile": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la mise à jour du profil"),
        "errorUploadingHouse": MessageLookupByLibrary.simpleMessage(
            "Erreur lors du téléchargement de l\'annonce de la maison"),
        "failedToLoadSearchResults": MessageLookupByLibrary.simpleMessage(
            "Échec du chargement des résultats de recherche"),
        "favouriteHouses":
            MessageLookupByLibrary.simpleMessage("Maisons favorites"),
        "fieldRequired": m6,
        "floor": MessageLookupByLibrary.simpleMessage("Étage"),
        "forRent": MessageLookupByLibrary.simpleMessage("À louer"),
        "forSale": MessageLookupByLibrary.simpleMessage("À vendre"),
        "forgotPassword":
            MessageLookupByLibrary.simpleMessage("Mot de passe oublié?"),
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
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "Entrez une adresse e-mail valide"),
        "isAvailable": MessageLookupByLibrary.simpleMessage("Disponible"),
        "isFurnished": MessageLookupByLibrary.simpleMessage("Est-ce meublé ?"),
        "justContinue": MessageLookupByLibrary.simpleMessage("Continuer"),
        "justIn": MessageLookupByLibrary.simpleMessage("en"),
        "lastName": MessageLookupByLibrary.simpleMessage("Nom de famille"),
        "livingRoom": MessageLookupByLibrary.simpleMessage("Salon"),
        "location": MessageLookupByLibrary.simpleMessage("Emplacement"),
        "logout": MessageLookupByLibrary.simpleMessage("Se déconnecter"),
        "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous sûr de vouloir vous déconnecter ?"),
        "main": MessageLookupByLibrary.simpleMessage("Principale"),
        "mainImage": MessageLookupByLibrary.simpleMessage("Image principale"),
        "maxDistance": m7,
        "message": MessageLookupByLibrary.simpleMessage("Message"),
        "middleName":
            MessageLookupByLibrary.simpleMessage("Deuxième prénom (optionnel)"),
        "monthlyPayment":
            MessageLookupByLibrary.simpleMessage("Paiement mensuel"),
        "myHouses": MessageLookupByLibrary.simpleMessage("Mes maisons"),
        "name": MessageLookupByLibrary.simpleMessage("Nom"),
        "newPassword":
            MessageLookupByLibrary.simpleMessage("Nouveau mot de passe"),
        "no": MessageLookupByLibrary.simpleMessage("Non"),
        "noAdditionalImages": MessageLookupByLibrary.simpleMessage(
            "Aucune image supplémentaire sélectionnée"),
        "noMoreHousesFound":
            MessageLookupByLibrary.simpleMessage("Plus de maisons trouvées"),
        "noResultsFound":
            MessageLookupByLibrary.simpleMessage("Aucun résultat trouvé"),
        "noRooms": MessageLookupByLibrary.simpleMessage(
            "0 s\'il n\'y a pas de chambres"),
        "notLoggedIn":
            MessageLookupByLibrary.simpleMessage("Non authentifié..."),
        "oldPassword":
            MessageLookupByLibrary.simpleMessage("Ancien mot de passe"),
        "options": MessageLookupByLibrary.simpleMessage("Options"),
        "ownerComment":
            MessageLookupByLibrary.simpleMessage("Commentaire du propriétaire"),
        "ownerHouse": m8,
        "ownerInfoMessage": MessageLookupByLibrary.simpleMessage(
            "Les informations sur le propriétaire seront automatiquement remplies en fonction des détails de votre compte."),
        "ownerInformation": MessageLookupByLibrary.simpleMessage(
            "Informations du propriétaire"),
        "password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "passwordRecoveryEmailSentSuccessfully":
            MessageLookupByLibrary.simpleMessage(
                "E-mail de récupération de mot de passe envoyé avec succès"),
        "passwordUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Mot de passe mis à jour avec succès"),
        "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
            "Les mots de passe ne correspondent pas"),
        "personalAccount":
            MessageLookupByLibrary.simpleMessage("Compte personnel"),
        "phone": MessageLookupByLibrary.simpleMessage("Téléphone"),
        "phoneUpdateSuccess": MessageLookupByLibrary.simpleMessage(
            "Numéro de téléphone mis à jour avec succès"),
        "pickCustomLocation": MessageLookupByLibrary.simpleMessage(
            "Choisir un emplacement personnalisé"),
        "price": MessageLookupByLibrary.simpleMessage("Prix"),
        "priceValue": m9,
        "profile": MessageLookupByLibrary.simpleMessage("Profil"),
        "profileUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Profil mis à jour avec succès"),
        "removedFromFavorites":
            MessageLookupByLibrary.simpleMessage("Retiré des favoris"),
        "rentPrice": MessageLookupByLibrary.simpleMessage("Prix de location"),
        "salePrice": MessageLookupByLibrary.simpleMessage("Prix de vente"),
        "saveChanges": MessageLookupByLibrary.simpleMessage(
            "Enregistrer les modifications"),
        "search": MessageLookupByLibrary.simpleMessage("Recherche"),
        "selectImageSource": MessageLookupByLibrary.simpleMessage(
            "Sélectionner la source de l\'image"),
        "selectYourPhoneCode": MessageLookupByLibrary.simpleMessage(
            "Sélectionnez votre code téléphonique"),
        "sendRecoveryEmail": MessageLookupByLibrary.simpleMessage(
            "Envoyer l\'e-mail de récupération"),
        "settings": MessageLookupByLibrary.simpleMessage("Paramètres"),
        "sortBy": MessageLookupByLibrary.simpleMessage("Trier par :"),
        "sorting": MessageLookupByLibrary.simpleMessage("Tri"),
        "status": MessageLookupByLibrary.simpleMessage("État"),
        "subject": MessageLookupByLibrary.simpleMessage("Objet"),
        "submit": MessageLookupByLibrary.simpleMessage("Soumettre"),
        "supportRequestFailed": MessageLookupByLibrary.simpleMessage(
            "Échec de l\'envoi de la demande d\'assistance. Veuillez réessayer."),
        "supportRequestSent": MessageLookupByLibrary.simpleMessage(
            "Demande d\'assistance envoyée avec succès !"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "typeYourPasswordToApplyChanges": MessageLookupByLibrary.simpleMessage(
            "Tapez votre mot de passe pour appliquer les changements"),
        "update": MessageLookupByLibrary.simpleMessage("mise à jour"),
        "updateError": MessageLookupByLibrary.simpleMessage("Erreur"),
        "updateHouseDetails":
            MessageLookupByLibrary.simpleMessage("Mettre à jour les détails"),
        "uploadHouseListing":
            MessageLookupByLibrary.simpleMessage("Téléchargez une manie"),
        "useCurrentLocation": MessageLookupByLibrary.simpleMessage(
            "Utiliser la position actuelle"),
        "verificationCodeError": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de l\'envoi du code de vérification"),
        "weReUploadingWait": MessageLookupByLibrary.simpleMessage(
            "Nous téléchargeons votre maison, veuillez patienter..."),
        "wrongPassword":
            MessageLookupByLibrary.simpleMessage("Mot de passe incorrect"),
        "yes": MessageLookupByLibrary.simpleMessage("Oui")
      };
}
