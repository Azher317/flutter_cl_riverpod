/// Centralized API endpoint paths (appended to `ApiDocument.baseUrl`).
///
/// Paths are `static const` so they can be used directly in Retrofit
/// annotations (`@POST(Endpoints.login)`), which require compile-time
/// constants. For parameterized routes, use Retrofit's `@GET('x/{id}')` +
/// `@Path()` rather than string-interpolation helper methods.
abstract class Endpoints {
  const Endpoints._();

  static const String login = '/auth/login';
}
