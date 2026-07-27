// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_consumer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiConsumer)
const apiConsumerProvider = ApiConsumerProvider._();

final class ApiConsumerProvider
    extends $FunctionalProvider<ApiConsumer, ApiConsumer, ApiConsumer>
    with $Provider<ApiConsumer> {
  const ApiConsumerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiConsumerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiConsumerHash();

  @$internal
  @override
  $ProviderElement<ApiConsumer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiConsumer create(Ref ref) {
    return apiConsumer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiConsumer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiConsumer>(value),
    );
  }
}

String _$apiConsumerHash() => r'2d3a420fdac57def661eb473a3ac1ad634d6c58b';
