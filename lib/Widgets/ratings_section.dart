part of 'widgets.dart';

class RatingSection extends StatefulWidget {
  final House house;
  final Function onRatingUpdated;

  const RatingSection({
    super.key,
    required this.house,
    required this.onRatingUpdated,
  });

  @override
  State<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  final _commentController = TextEditingController();
  final UserManager _userManager = UserManager();
  double _userRating = 0;
  bool _isSubmitting = false;


  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    widget.house.ratings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final bool hasRated = _userManager.samsarUser!.ratedHouses.contains(
        widget.house.id);
    final double averageRating =
    widget.house.rate.raters == 0
        ? 0
        : widget.house.rate.totalRating / widget.house.rate.raters;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.star_rate_outlined,
                        size: 24, color: theme.iconTheme.color),
                    const SizedBox(width: 8),
                    Text(
                      S.of(context).rating,
                      style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (widget.house.owner.id != _userManager.samsarUser!.uid)
                  ElevatedButton.icon(
                    onPressed: () => _showRatingBottomSheet(),
                    icon: const Icon(Icons.rate_review),
                    style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(
                        theme.dividerColor)),
                    label: Text(hasRated ? S.of(context).changeRating : S.of(context).rate), // Localized button text
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  _buildRatingStars(averageRating),
                  const SizedBox(height: 8),
                  Text(
                    averageRating == 0
                        ? S.of(context).noRatings
                        : '${averageRating.toStringAsFixed(1)}/5',
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    '(${widget.house.rate.raters} ${widget.house.rate.raters == 1 ? S.of(context).ratingSingle : S.of(context).ratingMultiple})', // Localized rating count
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            if (widget.house.ratings.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                S.of(context).reviews,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.house.ratings.length,
                separatorBuilder: (context, index) =>
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, thickness: 1, color: Colors.grey,),
                ),
                itemBuilder: (context, index) {
                  final rating = widget.house.ratings[index];
                  final isUsersRating = rating.uid ==
                      _userManager.samsarUser!.uid;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: rating.imageUrl.isNotEmpty
                                  ? NetworkImage(rating.imageUrl)
                                  : null,
                              child: rating.imageUrl.isEmpty
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            // Comment content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        rating.displayName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        _formatTimestamp(rating.timestamp),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center, // Ensures vertical alignment
                                    children: [
                                      SizedBox(width:  isUsersRating ? 30 : 10),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: _buildRatingStars(rating.rate, size: 24),
                                        ),
                                      ),
                                      SizedBox(
                                        width: isUsersRating ? 30 : 10,
                                        height: isUsersRating ? 30 : 0,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                          iconSize: isUsersRating ? 30 : 0,
                                          onPressed: _isSubmitting ? null : () => _showDeleteConfirmation(rating),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (rating.comment.isNotEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              rating.comment,
                              style: theme.textTheme.titleMedium
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(Rating rating) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(S.of(context).deleteRating),
        content: Text(S.of(context).deleteRatingConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.of(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteRating(rating);
            },
            child: Text(S.of(context).delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _submitRating() async {
    if (_userRating == 0) {
      showSnackBar(context, S.of(context).selectRating);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _userManager.samsarUser!;

      final Rating newRating = (
        comment: _commentController.text.trim(),
        displayName: user.displayName,
        imageUrl: user.profileImage,
        rate: _userRating,
        timestamp: DateTime.now(),
        uid: user.uid,
      );

      await _userManager.rateHouse(newRating, widget.house);

      _commentController.clear();
      setState(() {
        _userRating = 0;
      });

      widget.onRatingUpdated();

      if (mounted) {
        showSnackBar(context, S.of(context).ratingSubmitted);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, S.of(context).errorSubmittingRating);
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Future<void> _deleteRating(Rating rating) async {
    try {
      setState(() => _isSubmitting = true);
      await _userManager.deleteRating(rating, widget.house);
      widget.onRatingUpdated();
      if (mounted) {
        showSnackBar(context, S.of(context).ratingDeleted);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, S.of(context).errorDeletingRating);
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }


  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}${S.of(context).yearsAgo}';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}${S.of(context).monthsAgo}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}${S.of(context).daysAgo}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}${S.of(context).hoursAgo}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}${S.of(context).minutesAgo}';
    } else {
      return S.of(context).recently;
    }
  }


  Widget _buildRatingStars(double rating, {
    bool interactive = false,
    void Function(double)? onRatingChanged,
    double size = 32,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starRating = index + 1;
        return GestureDetector(
          onTap: interactive && onRatingChanged != null
              ? () => onRatingChanged(starRating.toDouble())
              : null,
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            size: size,
            color: index < rating ? Colors.amber : Colors.grey,
          ),
        );
      }),
    );
  }

  void _showRatingBottomSheet() {
    double tempRating = _userRating;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor.withAlpha(255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Handle bar
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        // Title
                        Text(
                          S.of(context).rateThisHouse,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Rating stars with local state update
                        Center(
                          child: _buildRatingStars(
                            tempRating,
                            interactive: true,
                            onRatingChanged: (rating) {
                              setSheetState(() {
                                tempRating = rating;
                              });
                              setState(() {
                                _userRating = rating;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Comment field
                        TextField(
                          controller: _commentController,
                          style: theme.textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: S.of(context).addCommentOptional,
                            hintStyle: theme.textTheme.bodyMedium,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Theme
                                  .of(context)
                                  .primaryColor),
                            ),
                            filled: true,
                            fillColor: theme.dividerColor,
                          ),
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                    S.of(context).cancel, style: TextStyle(fontSize: 16)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : () async {
                                  // Update bottom sheet loading state
                                  setSheetState(() {
                                    _isSubmitting = true;
                                  });

                                  // Update parent widget loading state
                                  setState(() {
                                    _isSubmitting = true;
                                  });

                                  try {
                                    await _submitRating();
                                    if (mounted && context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  } finally {
                                    // Reset loading states if the submission fails
                                    if (mounted) {
                                      setState(() {
                                        _isSubmitting = false;
                                      });
                                      setSheetState(() {
                                        _isSubmitting = false;
                                      });
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.dividerColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isSubmitting
                                    ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                                    : Text(S.of(context).submit),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}