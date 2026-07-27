import 'dart:async';

import 'package:app/core/messaging/snackbar.dart';
import 'package:app/core/session/session_provider.dart';
import 'package:app/core/settings/app_settings_provider.dart';
import 'package:app/core/utils/constants/route_names.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/widgets/overlay/custom_modal_bottom_sheet.dart';
import 'package:app/core/widgets/text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ───────────────────────────────────────────────────────────────────────────
/// ⚠️  PLACEHOLDER SCREEN — UI preview only, no real logic.
///
/// Every callback here is a no-op and every string is a `preview*` key in the
/// ARB files. It exists so the theme (four placeholder fonts, color scheme,
/// component themes, overlays) can be eyeballed in one scroll — flip the
/// language with the AppBar button and watch the display face switch
/// Playfair Display → Aref Ruqaa and the body face Work Sans → Tajawal.
///
/// TODO(placeholder): delete this file when building the real home screen, and
/// delete every `preview*` key from lib/core/l10n/generated/app_{en,ar}.arb
/// plus assets/images/jpeg/monstera.jpeg. Keep the AppBar actions if useful.
/// ───────────────────────────────────────────────────────────────────────────
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isArabic = settings.locale?.languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          context.l10n.previewTitle,
          style: context.textTheme.titleLarge,
        ),
        leading: kDebugMode
            ? IconButton(
                onPressed: () => context.push(RouteNames.logs),
                icon: const Icon(Icons.bug_report),
                tooltip: 'Log viewer (debug only)',
              )
            : null,
        actions: <Widget>[
          IconButton(
            onPressed: () =>
                ref.read(settingsProvider.notifier).toggleThemeMode(context),
            icon: Icon(
              settings.themeMode.isDark ? Icons.light_mode : Icons.dark_mode,
            ),
            tooltip: context.l10n.switchTheme,
          ),
          IconButton(
            onPressed: () => unawaited(
              ref
                  .read(settingsProvider.notifier)
                  .setLocale(Locale(isArabic ? 'en' : 'ar')),
            ),
            icon: const Icon(Icons.translate),
            tooltip: context.l10n.changeLanguage,
          ),
          IconButton(
            onPressed: () =>
                unawaited(ref.read(sessionControllerProvider).logout()),
            icon: const Icon(Icons.logout),
            tooltip: context.l10n.logout,
          ),
        ],
      ),
      body: ListView(
        padding: Insets.mediumAll,
        children: const <Widget>[
          _TodaySection(),
          SizedBox(height: Insets.large),
          _DetailPreview(),
          SizedBox(height: Insets.large),
          _ComponentGallery(),
          SizedBox(height: Insets.large),
          _OverlayGallery(),
          SizedBox(height: Insets.extraLarge),
        ],
      ),
    );
  }
}

/// Exercises cardTheme + checkboxTheme.
class _TodaySection extends StatelessWidget {
  const _TodaySection();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: context.l10n.previewTodayTitle,
      subtitle: context.l10n.previewTodaySubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: Insets.mediumAll,
            decoration: BoxDecoration(
              color: context.colorScheme.secondaryContainer,
              borderRadius: BorderSize.smallRadius,
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.lightbulb_outline,
                  color: context.colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: Insets.small),
                Expanded(
                  child: CustomText(
                    context.l10n.previewWinterTip,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Insets.medium),
          // Species names stay Latin in both languages — they're proper nouns.
          _RoomCard(
            room: context.l10n.previewLivingRoom,
            tasks: <(String, String)>[
              (context.l10n.previewWater, 'hoya australis'),
              (context.l10n.previewFeed, 'monstera siltepecana'),
            ],
          ),
          const SizedBox(height: Insets.medium),
          _RoomCard(
            room: context.l10n.previewKitchen,
            tasks: <(String, String)>[
              (context.l10n.previewWater, 'pilea peperomiodes'),
              (context.l10n.previewWater, 'hoya australis'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  final String room;
  final List<(String, String)> tasks;

  const _RoomCard({required this.room, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: Insets.mediumAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomText(
              room,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
            const SizedBox(height: Insets.small),
            for (final (action, plant) in tasks)
              Row(
                children: <Widget>[
                  Checkbox(value: true, onChanged: (_) {}),
                  const SizedBox(width: Insets.small),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomText(action, style: context.textTheme.bodyLarge),
                      CustomText(
                        plant,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Image beside a title/body column, then a scrolling chip strip.
class _DetailPreview extends StatelessWidget {
  const _DetailPreview();

  @override
  Widget build(BuildContext context) {
    final facts = <(IconData, String, String)>[
      (
        Icons.auto_awesome,
        context.l10n.previewMostPopular,
        context.l10n.previewMostPopularBody,
      ),
      (
        Icons.assignment_outlined,
        context.l10n.previewEasyCare,
        context.l10n.previewEasyCareBody,
      ),
      (
        Icons.park_outlined,
        context.l10n.previewFaux,
        context.l10n.previewFauxBody,
      ),
    ];

    return _Section(
      title: context.l10n.previewDetailTitle,
      subtitle: context.l10n.previewDetailSubtitle,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderSize.mediumRadius,
                child: Image.asset(
                  'assets/images/jpeg/monstera.jpeg',
                  width: context.width * 0.5,
                  height: context.width * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: Insets.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CustomText(
                      context.l10n.previewPlantName,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: context.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: Insets.small),
                    CustomText(
                      context.l10n.previewPlantBody,
                      style: context.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.medium),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: facts.length,
              separatorBuilder: (_, _) => const SizedBox(width: Insets.small),
              itemBuilder: (context, i) {
                final (icon, title, body) = facts[i];

                return Container(
                  width: 180,
                  padding: Insets.mediumAll,
                  decoration: BoxDecoration(
                    color: context.colorScheme.secondaryContainer,
                    borderRadius: BorderSize.smallRadius,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        icon,
                        size: IconSize.small,
                        color: context.colorScheme.onSecondaryContainer,
                      ),
                      const SizedBox(height: Insets.extraSmall),
                      CustomText(title, style: context.textTheme.titleSmall),
                      CustomText(body, style: context.textTheme.bodySmall),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Every themed component in one place, all callbacks inert.
class _ComponentGallery extends StatelessWidget {
  const _ComponentGallery();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: context.l10n.previewComponentsTitle,
      subtitle: context.l10n.previewComponentsSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(decoration: InputDecoration(hintText: context.l10n.search)),
          const SizedBox(height: Insets.medium),
          Wrap(
            spacing: Insets.small,
            runSpacing: Insets.small,
            children: <Widget>[
              ActionChip(
                avatar: const Icon(Icons.info_outline, size: IconSize.small),
                label: CustomText(context.l10n.previewAssist),
                onPressed: () {},
              ),
              FilterChip(
                label: CustomText(context.l10n.previewFilter),
                selected: true,
                onSelected: (_) {},
              ),
              InputChip(
                label: CustomText(context.l10n.previewSuggestion),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: Insets.medium),
          FilledButton(
            onPressed: () {},
            child: CustomText(context.l10n.previewFilledButton),
          ),
          const SizedBox(height: Insets.small),
          OutlinedButton(
            onPressed: () {},
            child: CustomText(context.l10n.previewOutlinedButton),
          ),
          const SizedBox(height: Insets.small),
          Align(
            child: TextButton(
              onPressed: () {},
              child: CustomText(context.l10n.previewTextButton),
            ),
          ),
          const SizedBox(height: Insets.medium),
          // Platform names are proper nouns — untranslated on purpose.
          SegmentedButton<int>(
            segments: const <ButtonSegment<int>>[
              ButtonSegment<int>(value: 0, label: CustomText('Android')),
              ButtonSegment<int>(value: 1, label: CustomText('Web')),
              ButtonSegment<int>(value: 2, label: CustomText('Linux')),
            ],
            selected: const <int>{0},
            onSelectionChanged: (_) {},
          ),
          const SizedBox(height: Insets.medium),
          const LinearProgressIndicator(value: 0.4),
          const SizedBox(height: Insets.medium),
          Align(
            child: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}

/// The themed surfaces that only exist once something is tapped — without
/// these triggers `dialogTheme`, `snackBarTheme` and `bottomSheetTheme` can't
/// be eyeballed at all.
class _OverlayGallery extends StatelessWidget {
  const _OverlayGallery();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: context.l10n.previewOverlaysTitle,
      subtitle: context.l10n.previewOverlaysSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          OutlinedButton(
            onPressed: () => unawaited(_showDialog(context)),
            child: CustomText(context.l10n.previewDialog),
          ),
          const SizedBox(height: Insets.small),
          OutlinedButton(
            onPressed: () => unawaited(_showSheet(context)),
            child: CustomText(context.l10n.previewBottomSheet),
          ),
          const SizedBox(height: Insets.medium),
          // One per MessageType: the theme owns the shape, AppMessenger still
          // owns the colors.
          Wrap(
            spacing: Insets.small,
            runSpacing: Insets.small,
            children: <Widget>[
              for (final MessageType type in MessageType.values)
                ActionChip(
                  label: CustomText(type.name),
                  onPressed: () => AppMessenger.show(
                    context.l10n.previewSnackMessage(type.name),
                    type: type,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showDialog(BuildContext context) => showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: CustomText(context.l10n.previewDialogTitle),
      content: CustomText(context.l10n.previewDialogBody),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: CustomText(context.l10n.cancel),
        ),
      ],
    ),
  );

  Future<void> _showSheet(BuildContext context) => customModalBottomSheet(
    context,
    height: 280,
    showDragHandle: true,
    child: ListView(
      padding: Insets.mediumAll,
      children: <Widget>[
        CustomText(
          context.l10n.previewRooms,
          style: context.textTheme.titleMedium,
        ),
        const Divider(),
        for (final String room in <String>[
          context.l10n.previewLivingRoom,
          context.l10n.previewKitchen,
          context.l10n.previewBalcony,
        ])
          ListTile(
            leading: const Icon(Icons.local_florist_outlined),
            title: CustomText(room),
            subtitle: CustomText(context.l10n.previewPlantCount(3)),
            onTap: () {},
          ),
      ],
    ),
  );
}

/// Shared heading + body wrapper so the sections line up.
class _Section extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _Section({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomText(title, style: context.textTheme.titleLarge),
        CustomText(
          subtitle,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: Insets.medium),
        child,
      ],
    );
  }
}
