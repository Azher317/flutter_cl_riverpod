import 'package:app/core/network/default_response.dart';
import 'package:app/core/network/paginated_response.dart';
import 'package:retrofit/retrofit.dart';

export 'package:app/core/network/default_response.dart';
export 'package:app/core/network/paginated_response.dart';
export 'package:retrofit/retrofit.dart';

typedef FutureDefaultResponse<T> = Future<HttpResponse<DefaultResponse<T>>>;

typedef FutureApiResponse<T> = Future<HttpResponse<T>>;

typedef FuturePaginatedResponse<T> =
    Future<HttpResponse<DefaultResponse<PaginatedResponse<T>>>>;
