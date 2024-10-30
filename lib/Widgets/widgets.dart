import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../helpers/CachedTileProvider.dart';
import '../helpers/user_manager.dart';
import '../values/structures.dart';
import '../helpers/house_manager.dart';

part 'snack_bar.dart';
part 'filter_dialog.dart';
part 'ratings_section.dart';
part 'image_viewer.dart';

Widget buildDetailRow(
    BuildContext context, IconData icon, String label, String value,
    {bool wrapText = false}) {
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: wrapText
        ? Column(
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: theme.iconTheme.color),
                  const SizedBox(width: 8),
                  Text(
                    '$label: ',
                    style: theme.textTheme.titleSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(value, style: theme.textTheme.titleSmall),
            ],
          )
        : Row(
            children: [
              Icon(icon, size: 20, color: theme.iconTheme.color),
              const SizedBox(width: 8),
              Text(
                '$label: ',
                style: theme.textTheme.titleSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(value, style: theme.textTheme.titleSmall),
              ),
            ],
          ),
  );
}

Widget buildInfoCard(
    BuildContext context, IconData icon, String title, Widget content) {
  final theme = Theme.of(context);
  return Card(
    elevation: 4,
    color: theme.cardColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: theme.iconTheme.color),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          content,
        ],
      ),
    ),
  );
}

Widget buildInfoDoc(
    BuildContext context, IconData icon, String title, String message) {
  final theme = Theme.of(context);
  return Card(
    elevation: 4,
    color: theme.cardColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: theme.iconTheme.color),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    ),
  );
}
/*
Widget buildRatingCard(BuildContext context, int rating, int numRaters) {
  final theme = Theme.of(context);
  double averageRating = numRaters == 0 ? 0 : rating / numRaters;

  return Card(
    elevation: 4,
    color: theme.cardColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.star_rate_outlined,
                  size: 24, color: theme.iconTheme.color),
              const SizedBox(width: 8),
              Text(
                "Rating",
                style: theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Icon(
                index < averageRating.round() ? Icons.star : Icons.star_border,
                size: 42,
                color: index < averageRating.round()
                    ? Colors.amber
                    : theme.disabledColor,
              );
            }),
          ),
          const SizedBox(width: 8),
          Text(
            averageRating == 0
                ? 'No ratings'
                : '${averageRating.toStringAsFixed(1)}/5',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(width: 4),
          Text(
            '($numRaters ratings)',
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    ),
  );
}
*/
Widget buildSection(
    BuildContext context, IconData icon, String title, List<String> items) {
  final theme = Theme.of(context);
  double screenWidth = MediaQuery.of(context).size.width;
  double cardWidth = screenWidth * 0.9;
  double maxCardWidth = 350;

  return Card(
    elevation: 4,
    color: theme.cardColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxCardWidth,
        minWidth: cardWidth < maxCardWidth ? cardWidth : maxCardWidth,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: theme.iconTheme.color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 10,
                children:
                    items.map((item) => _buildItem(context, item)).toList(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildItem(BuildContext context, String item) {
  final theme = Theme.of(context);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.secondary, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        item,
        style: theme.textTheme.titleSmall!
            .copyWith(color: theme.colorScheme.secondary),
      ),
    ),
  );
}

Widget buildTextField(
    BuildContext context, TextEditingController controller, String label,
    {bool obscureText = false, String? Function(String?)? validator}) {
  final theme = Theme.of(context);
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      fillColor: theme.inputDecorationTheme.fillColor,
      filled: true,
    ),
    style: theme.textTheme.titleSmall,
    obscureText: obscureText,
    validator: validator ??
        (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
  );
}

Widget buildCupertinoSelectedItem(Country country) {
  return Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      const SizedBox(width: 8.0),
      Text("+${country.phoneCode}"),
      const SizedBox(width: 8.0),
      Flexible(child: Text(country.isoCode))
    ],
  );
}

Widget settingScreenItem(
    BuildContext context, {
      IconData? icon,
      String? imagePath,
      required String itemName,
      required String page,
    }) {
  final theme = Theme.of(context);

  return ListTile(
    leading: SizedBox(
      width: 24,
      height: 24,
      child: icon != null
          ? Center(child: Icon(icon, color: theme.primaryColor, size: 22))
          : imagePath != null
          ? Center(child: Image.asset(imagePath, width: 20, height: 20))
          : null,
    ),
    title: Text(itemName, style: theme.textTheme.titleSmall),
    onTap: () {
      Navigator.pushNamed(context, page);
    },
  );
}



Widget buildPhoneNumberField(
  TextEditingController phoneNumberController,
  Country country,
  Function fn,
) {
  return TextFormField(
    scrollPadding: EdgeInsets.zero,
    controller: phoneNumberController,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a phone number';
      } else if (value.length < 6) {
        return 'Please enter a valid phone number';
      }
      return null;
    },
    decoration: InputDecoration(
      labelText: 'Phone Number',
      border: OutlineInputBorder(),
      prefix: IconButton(
        icon: CountryPickerUtils.getDefaultFlagImage(country),
        onPressed: () async {
          fn();
        },
        padding: EdgeInsets.zero, // Remove the default padding
      ),
      isDense: true, // Make the text field more compact
    ),
    keyboardType: TextInputType.phone,
  );
}

class HousePreviewWidget extends StatelessWidget {
  final House house;
  final VoidCallback onTap;
  final double distance;

  const HousePreviewWidget({
    super.key,
    required this.house,
    required this.onTap,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    final String rooms = house.specs.hasLivingRoom ? "S+${house.specs.rooms}" : "${house.specs.rooms} rooms";
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 0,bottom: 12, right: 12, left: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (house.images.isNotEmpty)
              GestureDetector(
                onTap: onTap,
                child: CachedNetworkImage(
                  imageUrl: house.images.first,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$rooms, ${house.specs.area.toStringAsFixed(1)} m²',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (distance >= 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.social_distance_outlined,
                        color: Colors.red,
                        size: 28,
                      ),
                      Text(
                        "  :${(distance / 1000).toStringAsFixed(1)}Km ",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.pin_drop),
                const SizedBox(width: 8),
                Text(
                  '${house.location.city}, ${house.location.region}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.attach_money),
                const SizedBox(width: 8),
                Text(
                  '${house.specs.price}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Wrap(
                  spacing: 8,
                  children: [
                    if (house.specs.hasParking)
                      const Icon(Icons.local_parking, size: 20),
                    if (house.specs.hasWifi) const Icon(Icons.wifi, size: 20),
                    if (house.specs.isFurnished) const Icon(Icons.chair, size: 20),
                    if (house.samsarStatus.is3D) const Icon(Icons.threed_rotation, size: 20),
                    if (house.status.isForSale) const Icon(Icons.real_estate_agent_outlined, size: 20,)
                  ],
                ),
                ElevatedButton(
                  onPressed: onTap,
                  style: Theme.of(context).elevatedButtonTheme.style,
                  child: Text(
                    'View Details',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLoadingScreen extends StatelessWidget {
  final String message;
  final Color indicatorColor;

  const CustomLoadingScreen({
    super.key,
    this.message = "Please wait...",
    this.indicatorColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.cardColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your logo at the top
            Image.asset(
              'assets/Logo/logo.png',
              height: 100, // Adjust the height based on your logo size
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24), // Space between logo and the progress indicator
            CircularProgressIndicator(
              color: indicatorColor,
              strokeWidth: 4.0, // Optional: Adjust thickness
            ),
            const SizedBox(height: 24), // Space between indicator and message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500, // Slightly bolder text for better visibility
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildFloatingButton({
  required VoidCallback onPressed,
  String tag = "",
  IconData icon = Icons.add,
  String image = "",
  required Color backgroundColor,
}) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: FloatingActionButton(
      heroTag: tag,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      elevation: 0,
      highlightElevation: 0,
      child: image.isEmpty
          ? Icon(icon, color: Colors.white)
          : SizedBox(
            width: 40,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
    ),
    );
}