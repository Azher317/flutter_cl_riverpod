abstract class ApiDocument {
  const ApiDocument._();
  static const baseUrl = 'https://tafly-api.taco5k.site/api/user';
  static const mediaUrl = 'https://tafly-api.taco5k.site/';

  static String? resolveMediaPath(String? path) {
    if (path == null || path.trim().isEmpty) return null;
    final t = path.trim();
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    final base = Uri.parse(mediaUrl);
    final relative = t.startsWith('/') ? t.substring(1) : t;
    if (relative.isEmpty) return null;
    return base.resolve(relative).toString();
  }
}
