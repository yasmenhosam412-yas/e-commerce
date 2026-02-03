class BannerModel {
  final bool isNewShop;
  final bool hasDiscount;
  final bool isBestSelling;
  final bool isUserAllow;
  final String image;

  const BannerModel({
    required this.isNewShop,
    required this.hasDiscount,
    required this.isBestSelling,
    required this.isUserAllow,
    required this.image,
  });

  bool get canShowBadge => isUserAllow;

  bool get hasBadge =>
      canShowBadge && (isNewShop || hasDiscount || isBestSelling);
}

enum BannerBadge { newShop, discount, bestSelling, none }

extension BannerBadgeX on BannerModel {
  BannerBadge get badge {
    if (!canShowBadge) return BannerBadge.none;

    if (isNewShop) return BannerBadge.newShop;
    if (hasDiscount) return BannerBadge.discount;
    if (isBestSelling) return BannerBadge.bestSelling;

    return BannerBadge.none;
  }
}
