class MachineryListing {
  final String id;
  final String title;
  final String category; // Tractor, Combine Harvester, Rotavator, Drone, Laser Leveller
  final String ownerName;
  final String ownerPhone;
  final String location;
  final double ratePerHour;
  final double ratePerAcre;
  final bool isAvailable;
  final String imageUrl;

  MachineryListing({
    required this.id,
    required this.title,
    required this.category,
    required this.ownerName,
    required this.ownerPhone,
    required this.location,
    required this.ratePerHour,
    required this.ratePerAcre,
    required this.isAvailable,
    required this.imageUrl,
  });
}

class MarketplaceItem {
  final String id;
  final String cropName;
  final String variety;
  final double quantityQuintals;
  final double expectedPricePerQuintal;
  final String farmerName;
  final String farmerPhone;
  final String location;
  final String harvestDate;
  final String imageUrl;

  MarketplaceItem({
    required this.id,
    required this.cropName,
    required this.variety,
    required this.quantityQuintals,
    required this.expectedPricePerQuintal,
    required this.farmerName,
    required this.farmerPhone,
    required this.location,
    required this.harvestDate,
    required this.imageUrl,
  });
}

class CommunityPost {
  final String id;
  final String authorName;
  final String authorLocation;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  int likes;
  List<String> comments;

  CommunityPost({
    required this.id,
    required this.authorName,
    required this.authorLocation,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    this.likes = 0,
    required this.comments,
  });
}
