/// Centralized API endpoint paths (appended to `ApiDocument.baseUrl`).
///
/// Passed to the `ApiConsumer` verbs, e.g. `_api.post(Endpoints.login, ...)`.
/// Kept `static const` and in one place so a path has a single definition to
/// change. For parameterized routes, interpolate the id into the path string
/// (e.g. `'/orders/$id'`) or add a small helper here.
abstract class Endpoints {
  const Endpoints._();

  static const String login = '/auth/login';
}
