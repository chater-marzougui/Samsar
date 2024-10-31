// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  static String m1(error) =>
      "Erreur lors de la vérification de l\'état favori : ${error}";

  static String m2(e) =>
      "Erreur lors du chargement des données utilisateur : ${e}";

  static String m3(error) =>
      "Erreur lors de l\'envoi de l\'e-mail de récupération du mot de passe: ${error}";

  static String m4(e) => "Erreur lors de la déconnexion : ${e}";

  static String m5(error) =>
      "Erreur lors de la mise à jour de l\'état favori : ${error}";

  static String m6(error) =>
      "Erreur lors de la mise à jour du mot de passe : ${error}";

  static String m7(e) => "${e} est requis";

  static String m9(e) => "Distance maximale : ${e} Km";

  static String m11(name) => "Maison de ${name}";

  static String m12(e) => "Veuillez entrer ${e}";

  static String m13(price) => "${price} TND";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add": MessageLookupByLibrary.simpleMessage("Ajouter"),
        "addCommentOptional": MessageLookupByLibrary.simpleMessage(
            "Ajoutez un commentaire (facultatif)"),
        "addFeature":
            MessageLookupByLibrary.simpleMessage("Ajouter une caractéristique"),
        "addFeatures": MessageLookupByLibrary.simpleMessage(
            "Ajouter des caractéristiques"),
        "addFurniture":
            MessageLookupByLibrary.simpleMessage("Ajouter un meuble"),
        "addMainImage": MessageLookupByLibrary.simpleMessage(
            "Ajouter une image principale"),
        "addedToFavorites":
            MessageLookupByLibrary.simpleMessage("Ajouté aux favoris"),
        "additionalImages":
            MessageLookupByLibrary.simpleMessage("Images supplémentaires"),
        "additionalInformation": MessageLookupByLibrary.simpleMessage(
            "Informations supplémentaires"),
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
        "changeRating": MessageLookupByLibrary.simpleMessage("Modifier"),
        "changeToAnotherLoc":
            MessageLookupByLibrary.simpleMessage("changer d\'emplacement..."),
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
        "daily": MessageLookupByLibrary.simpleMessage("Quotidien"),
        "dailyPayment":
            MessageLookupByLibrary.simpleMessage("Paiement quotidien"),
        "dans": MessageLookupByLibrary.simpleMessage("dans"),
        "dark": MessageLookupByLibrary.simpleMessage("Sombre"),
        "daysAgo": MessageLookupByLibrary.simpleMessage("j"),
        "delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
        "deleteHouse":
            MessageLookupByLibrary.simpleMessage("Supprimer la maison"),
        "deleteHouseConfirmation": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous sûr de vouloir supprimer cette annonce ?"),
        "deleteRating":
            MessageLookupByLibrary.simpleMessage("Supprimer l\'évaluation"),
        "deleteRatingConfirmation": MessageLookupByLibrary.simpleMessage(
            "Voulez-vous vraiment supprimer votre évaluation ?"),
        "describeIssue":
            MessageLookupByLibrary.simpleMessage("Décrivez votre problème"),
        "dismiss": MessageLookupByLibrary.simpleMessage("Ignorer"),
        "distance": MessageLookupByLibrary.simpleMessage("Dist"),
        "editProfile":
            MessageLookupByLibrary.simpleMessage("Modifier le profil"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "enableNotifications":
            MessageLookupByLibrary.simpleMessage("Activer les Notifications"),
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
        "errorCheckingFavoriteStatus": m1,
        "errorDeletingHouse": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la suppression de la maison"),
        "errorDeletingRating": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la suppression de l\'évaluation"),
        "errorFetchingHouses": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la récupération des données"),
        "errorLoadingUserData": m2,
        "errorSearchingForPlaces": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la recherche de lieux"),
        "errorSendingPasswordRecoveryEmail": m3,
        "errorSigningOut": m4,
        "errorSubmittingRating": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la soumission de l\'évaluation, veuillez réessayer plus tard"),
        "errorUpdatingFavoriteStatus": m5,
        "errorUpdatingPassword": m6,
        "errorUpdatingProfile": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de la mise à jour du profil"),
        "errorUploadingHouse": MessageLookupByLibrary.simpleMessage(
            "Erreur lors du téléchargement de l\'annonce de la maison"),
        "failedToLoadSearchResults": MessageLookupByLibrary.simpleMessage(
            "Échec du chargement des résultats de recherche"),
        "favouriteHouses":
            MessageLookupByLibrary.simpleMessage("Maisons favourites"),
        "fieldRequired": m7,
        "filters": MessageLookupByLibrary.simpleMessage("Filtres"),
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
        "genderFemale": MessageLookupByLibrary.simpleMessage("Femme"),
        "genderMale": MessageLookupByLibrary.simpleMessage("Homme"),
        "genderOther": MessageLookupByLibrary.simpleMessage("Autre"),
        "groundFloor":
            MessageLookupByLibrary.simpleMessage("0 pour le rez-de-chaussée"),
        "has3DView": MessageLookupByLibrary.simpleMessage("Vue 3D disponible"),
        "hasLivingRoom":
            MessageLookupByLibrary.simpleMessage("La maison a un salon ?"),
        "hasParking":
            MessageLookupByLibrary.simpleMessage("La maison a un parking ?"),
        "hasWifi":
            MessageLookupByLibrary.simpleMessage("Est-ce qu\'il y a du WiFi ?"),
        "hintText": MessageLookupByLibrary.simpleMessage(
            "villa, appartement, studio..."),
        "home": MessageLookupByLibrary.simpleMessage("Accueil"),
        "hoursAgo": MessageLookupByLibrary.simpleMessage("h"),
        "houseDeleteSuccess": MessageLookupByLibrary.simpleMessage(
            "Maison supprimée avec succès !"),
        "houseSpecifications":
            MessageLookupByLibrary.simpleMessage("Spécifications"),
        "houseUploadedSuccess": MessageLookupByLibrary.simpleMessage(
            "Annonce de maison téléchargée avec succès !"),
        "inbox": MessageLookupByLibrary.simpleMessage("Messages"),
        "invalidEmail": MessageLookupByLibrary.simpleMessage(
            "Entrez une adresse e-mail valide"),
        "isAvailable": MessageLookupByLibrary.simpleMessage("Disponible"),
        "isFurnished": MessageLookupByLibrary.simpleMessage("Est-ce meublé ?"),
        "justContinue": MessageLookupByLibrary.simpleMessage("Continuer"),
        "justCurrent": MessageLookupByLibrary.simpleMessage("Actuel"),
        "justIn": MessageLookupByLibrary.simpleMessage("en"),
        "language": MessageLookupByLibrary.simpleMessage("Langue"),
        "lastName": MessageLookupByLibrary.simpleMessage("Nom de famille"),
        "light": MessageLookupByLibrary.simpleMessage("Clair"),
        "livingRoom": MessageLookupByLibrary.simpleMessage("Salon"),
        "loading": MessageLookupByLibrary.simpleMessage("Chargement..."),
        "loadingMessages":
            MessageLookupByLibrary.simpleMessage("Chargement des messages..."),
        "loadingNotifications": MessageLookupByLibrary.simpleMessage(
            "Chargement des notifications..."),
        "location": MessageLookupByLibrary.simpleMessage("Emplacement"),
        "logout": MessageLookupByLibrary.simpleMessage("Se déconnecter"),
        "logoutConfirmation": MessageLookupByLibrary.simpleMessage(
            "Êtes-vous sûr de vouloir vous déconnecter ?"),
        "main": MessageLookupByLibrary.simpleMessage("Principale"),
        "mainImage": MessageLookupByLibrary.simpleMessage("Image principale"),
        "maxDistance": m9,
        "maxPrice": MessageLookupByLibrary.simpleMessage("Prix maximum"),
        "message": MessageLookupByLibrary.simpleMessage("Message"),
        "messages": MessageLookupByLibrary.simpleMessage("Messages"),
        "middleName":
            MessageLookupByLibrary.simpleMessage("Deuxième prénom (optionnel)"),
        "minPrice": MessageLookupByLibrary.simpleMessage("Prix minimum"),
        "minutesAgo": MessageLookupByLibrary.simpleMessage("min"),
        "monthly": MessageLookupByLibrary.simpleMessage("Mensuel"),
        "monthlyPayment":
            MessageLookupByLibrary.simpleMessage("Paiement mensuel"),
        "monthsAgo": MessageLookupByLibrary.simpleMessage("mois"),
        "moreDetails": MessageLookupByLibrary.simpleMessage("Plus de détails"),
        "myHouses": MessageLookupByLibrary.simpleMessage("Mes maisons"),
        "name": MessageLookupByLibrary.simpleMessage("Nom"),
        "newPassword":
            MessageLookupByLibrary.simpleMessage("Nouveau mot de passe"),
        "no": MessageLookupByLibrary.simpleMessage("Non"),
        "noAdditionalImages": MessageLookupByLibrary.simpleMessage(
            "Aucune image supplémentaire sélectionnée"),
        "noHousesListed": MessageLookupByLibrary.simpleMessage(
            "Vous n\'avez aucune maison listée."),
        "noMessages": MessageLookupByLibrary.simpleMessage("Aucun message"),
        "noMoreHousesFound":
            MessageLookupByLibrary.simpleMessage("Plus de maisons trouvées"),
        "noNotifications":
            MessageLookupByLibrary.simpleMessage("Aucune notification"),
        "noRatings": MessageLookupByLibrary.simpleMessage("Aucune évaluation"),
        "noResultsFound":
            MessageLookupByLibrary.simpleMessage("Aucun résultat trouvé"),
        "noRooms": MessageLookupByLibrary.simpleMessage(
            "0 s\'il n\'y a pas de chambres"),
        "notAvailable":
            MessageLookupByLibrary.simpleMessage("N\'est Pas Disponible"),
        "notLoggedIn":
            MessageLookupByLibrary.simpleMessage("Non authentifié..."),
        "notifications": MessageLookupByLibrary.simpleMessage("Notifications"),
        "oldPassword":
            MessageLookupByLibrary.simpleMessage("Ancien mot de passe"),
        "options": MessageLookupByLibrary.simpleMessage("Options"),
        "ownerComment": MessageLookupByLibrary.simpleMessage("Commentaire"),
        "ownerHouse": m11,
        "ownerInfoMessage": MessageLookupByLibrary.simpleMessage(
            "Les informations sur le propriétaire seront automatiquement remplies en fonction des détails de votre compte."),
        "ownerInformation":
            MessageLookupByLibrary.simpleMessage("Informations pour Contact"),
        "password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
        "passwordRecoveryEmailSentSuccessfully":
            MessageLookupByLibrary.simpleMessage(
                "E-mail de récupération de mot de passe envoyé avec succès"),
        "passwordUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Mot de passe mis à jour avec succès"),
        "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
            "Les mots de passe ne correspondent pas"),
        "payment": MessageLookupByLibrary.simpleMessage("Paiement"),
        "personalAccount":
            MessageLookupByLibrary.simpleMessage("Compte personnel"),
        "phone": MessageLookupByLibrary.simpleMessage("Téléphone"),
        "phoneNumber":
            MessageLookupByLibrary.simpleMessage("Numéro de téléphone"),
        "phoneUpdateSuccess": MessageLookupByLibrary.simpleMessage(
            "Numéro de téléphone mis à jour avec succès"),
        "pickCustomLocation": MessageLookupByLibrary.simpleMessage(
            "Choisir un emplacement personnalisé"),
        "pleaseEnter": m12,
        "pleaseEnterPhoneNumber": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer un numéro de téléphone"),
        "pleaseEnterValidPhoneNumber": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer un numéro de téléphone valide"),
        "price": MessageLookupByLibrary.simpleMessage("Prix"),
        "priceRange": MessageLookupByLibrary.simpleMessage("Plage de prix"),
        "priceValue": m13,
        "profile": MessageLookupByLibrary.simpleMessage("Profil"),
        "profileUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Profil mis à jour avec succès"),
        "rate": MessageLookupByLibrary.simpleMessage("Évaluer"),
        "rateThisHouse":
            MessageLookupByLibrary.simpleMessage("Notez cette maison"),
        "rating": MessageLookupByLibrary.simpleMessage("Évaluation"),
        "ratingDeleted": MessageLookupByLibrary.simpleMessage(
            "Évaluation supprimée avec succès"),
        "ratingMultiple": MessageLookupByLibrary.simpleMessage("évaluations"),
        "ratingSingle": MessageLookupByLibrary.simpleMessage("évaluation"),
        "ratingSubmitted": MessageLookupByLibrary.simpleMessage(
            "Évaluation soumise avec succès"),
        "recenter": MessageLookupByLibrary.simpleMessage("recentrer"),
        "recently": MessageLookupByLibrary.simpleMessage("à l\'instant"),
        "removedFromFavorites":
            MessageLookupByLibrary.simpleMessage("Retiré des favoris"),
        "rentPrice": MessageLookupByLibrary.simpleMessage("Prix de location"),
        "reset": MessageLookupByLibrary.simpleMessage("Réinitialiser"),
        "reviews": MessageLookupByLibrary.simpleMessage("Avis"),
        "salePrice": MessageLookupByLibrary.simpleMessage("Prix de vente"),
        "saveChanges": MessageLookupByLibrary.simpleMessage(
            "Enregistrer les modifications"),
        "search": MessageLookupByLibrary.simpleMessage("Recherche"),
        "selectBirthdate": MessageLookupByLibrary.simpleMessage(
            "Sélectionner la date de naissance"),
        "selectDistrict":
            MessageLookupByLibrary.simpleMessage("Sélectionner le district"),
        "selectGender":
            MessageLookupByLibrary.simpleMessage("Sélectionnez le sexe"),
        "selectImageSource": MessageLookupByLibrary.simpleMessage(
            "Sélectionner la source de l\'image"),
        "selectRating": MessageLookupByLibrary.simpleMessage(
            "Veuillez sélectionner une note"),
        "selectRegion":
            MessageLookupByLibrary.simpleMessage("Sélectionner la région"),
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
        "themeMode": MessageLookupByLibrary.simpleMessage("Mode Thème"),
        "type": MessageLookupByLibrary.simpleMessage("Type"),
        "typeYourPasswordToApplyChanges": MessageLookupByLibrary.simpleMessage(
            "Tapez votre mot de passe pour appliquer les changements"),
        "uhOhPageNotFound":
            MessageLookupByLibrary.simpleMessage("Oups!\nPage non trouvée"),
        "update": MessageLookupByLibrary.simpleMessage("mise à jour"),
        "updateError": MessageLookupByLibrary.simpleMessage("Erreur"),
        "updateHouseDetails":
            MessageLookupByLibrary.simpleMessage("Mettre à jour les détails"),
        "uploadHouseListing":
            MessageLookupByLibrary.simpleMessage("Téléchargez une manie"),
        "useCurrentLocation": MessageLookupByLibrary.simpleMessage(
            "Utiliser la position actuelle"),
        "validPhoneNumberRequired": MessageLookupByLibrary.simpleMessage(
            "Veuillez entrer un numéro de téléphone valide"),
        "verificationCodeError": MessageLookupByLibrary.simpleMessage(
            "Erreur lors de l\'envoi du code de vérification"),
        "weReUploadingWait": MessageLookupByLibrary.simpleMessage(
            "Nous téléchargeons votre maison, veuillez patienter..."),
        "wrongPassword":
            MessageLookupByLibrary.simpleMessage("Mot de passe incorrect"),
        "yearsAgo": MessageLookupByLibrary.simpleMessage("a"),
        "yes": MessageLookupByLibrary.simpleMessage("Oui")
      };
}
