/// Resolves the display name of a lookup item that may carry either a single
/// `name` or per-locale `nameEn`/`nameAr` fields.
///
/// [item] is `dynamic` because the paginated pickers are generic over lookup
/// DTOs that share these field names without a common supertype.
String localizedName(dynamic item, String localeCode) {
  final name = item.name as String?;
  if (name != null) return name;

  final localized =
      (localeCode == 'en' ? item.nameEn : item.nameAr) as String?;
  return localized ?? '';
}
