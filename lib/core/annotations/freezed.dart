import 'package:freezed_annotation/freezed_annotation.dart';

/// RESPONSE Freezed model (two-way). Freezed generates BOTH `fromJson` and
/// `toJson`. Use for a response you parse from the API and may also send back
/// (e.g. round-tripping an object, caching it, or re-posting it).
const freezedResponse = Freezed(toJson: true, fromJson: true);

/// REQUEST Freezed model (send-only). `toJson` generated, `fromJson: false`
/// because an outgoing request body is never parsed FROM json. Use for bodies
/// you construct in Dart and serialize to send.
const freezedRequest = Freezed(toJson: true, fromJson: false);

// ─────────────────────────────────────────────────────────────────────────
// PARAMETER GLOSSARY  (Freezed's own serialization switches)
//
// fromJson   Should Freezed generate the `Model.fromJson(map)` factory?
//            true  -> class can be PARSED from incoming JSON.
//            false -> no parser. Use for send-only requests (never received).
//
// toJson     Should Freezed generate the `model.toJson()` method?
//            true  -> class can be SERIALIZED to outgoing JSON.
//            false -> no serializer. Use for read-only responses (never sent).
//
// Direction cheat-sheet:
//   receive only  -> fromJson: true,  toJson: false
//   send only     -> fromJson: false, toJson: true   (freezedRequest)
//   both ways     -> fromJson: true,  toJson: true    (freezedResponse)
//
// Note: Freezed delegates the actual JSON work to json_serializable under the
// hood, so these mirror createFactory/createToJson from the JsonSerializable
// file. Freezed always adds ==, hashCode, copyWith, toString regardless of
// these flags — they only control serialization.
// ─────────────────────────────────────────────────────────────────────────
