/// Resolves the display name of a lookup item that may carry either a single
/// `name` or per-locale `nameEn`/`nameAr`/`nameKu` fields.
///
/// [item] is `dynamic` because the paginated pickers are generic over lookup
/// DTOs that share these field names without a common supertype. Prefer passing
/// an explicit `labelBuilder` to the pickers where a type-safe label is
/// available; this is the untyped fallback.
String localizedName(dynamic item, String localeCode) {
  // ignore: avoid_dynamic_calls
  final name = item.name as String?;
  if (name != null) return name;

  final localized =
      switch (localeCode) {
            // ignore: avoid_dynamic_calls
            'ar' => item.nameAr,
            // ignore: avoid_dynamic_calls
            'ku' => item.nameKu,
            // ignore: avoid_dynamic_calls
            _ => item.nameEn,
          }
          as String?;
  return localized ?? '';
}
