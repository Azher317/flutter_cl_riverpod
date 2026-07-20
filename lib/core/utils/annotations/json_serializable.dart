import 'package:freezed_annotation/freezed_annotation.dart';

/// JSON key casing for the whole app. `none` = Dart field names are used
/// as-is (backend already matches). Switch to `snake` if the API is snake_case.
const filedRename = FieldRename.none;

/// GENERAL two-way model. Use when the SAME model is both received and sent,
/// and it may contain NESTED models. `explicitToJson: true` fully expands
/// nested objects into real Maps (safe for logging/redaction/Dio interceptors).
const jsonSerializable = JsonSerializable(
  fieldRename: filedRename,
  createFactory: true,
  createToJson: true,
  explicitToJson: true,
);

/// RESPONSE model (read-heavy). Parses incoming JSON and can still serialize,
/// but does NOT force nested-object expansion. Use for plain responses you
/// don't need to inspect/redact as an outgoing body.
const jsonSerializableResponse = JsonSerializable(
  fieldRename: filedRename,
  createFactory: true,
  createToJson: true,
  explicitToJson: false,
);

/// REQUEST model (send-only). No `fromJson` (never parsed), only `toJson`.
/// `explicitToJson: true` so nested bodies fully expand — required for your
/// Dio logging + `_redactBody` walker to see into them.
const jsonSerializableRequest = JsonSerializable(
  fieldRename: filedRename,
  createFactory: false,
  createToJson: true,
  explicitToJson: true,
);

/// GENERIC response envelope, e.g. `ApiResponse<T>`. Read-only (`createToJson:
/// false`). `genericArgumentFactories: true` adds the `fromJsonT` helper param
/// so one wrapper class can decode any `T` (User, Order, ...).
const jsonSerializableResponseGeneric = JsonSerializable(
  createToJson: false,
  explicitToJson: true,
  genericArgumentFactories: true,
);

/// ENUM serialization. `pascal` => values encode as "Standard"/"Express".
/// `alwaysCreate: true` generates the enum map even when no model uses it,
/// so you can serialize the enum standalone (e.g. as a query parameter).
const jsonEnum = JsonEnum(fieldRename: FieldRename.pascal, alwaysCreate: true);

// ─────────────────────────────────────────────────────────────────────────
// PARAMETER GLOSSARY
//
// fieldRename            How a Dart field name maps to its JSON key.
//                        none  -> firstName  (unchanged)
//                        snake -> first_name
//                        pascal-> FirstName
//                        Set once here; avoids per-field @JsonKey(name: ...).
//
// createFactory          Generate `fromJson` (the PARSER for incoming JSON)?
//                        true  -> Model.fromJson(map) exists.
//                        false -> no parser. Use for send-only requests.
//
// createToJson           Generate `toJson` (the SERIALIZER for outgoing JSON)?
//                        true  -> map = model.toJson() exists.
//                        false -> no serializer. Use for read-only responses.
//
// explicitToJson         Only matters when a model CONTAINS other models.
//                        false -> nested value stays a Dart object; only turns
//                                 into JSON if you jsonEncode the whole thing.
//                        true  -> toJson() returns a fully-nested Map, every
//                                 level a real Map. Needed for logging,
//                                 redaction, or inspecting the body directly.
//
// genericArgumentFactories  For GENERIC classes like ApiResponse<T>. The
//                        generator can't build an unknown T by itself, so this
//                        adds a helper param: fromJson(json, fromJsonT). You
//                        pass the T's builder at the call site:
//                        ApiResponse<User>.fromJson(json, User.fromJson).
//
// alwaysCreate  (JsonEnum)  Force-generate the enum's encode/decode map even
//                        if no model references the enum. Lets you serialize
//                        the enum on its own (query params, standalone keys).
// ─────────────────────────────────────────────────────────────────────────
