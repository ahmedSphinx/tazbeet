# SettingsScreen UI/UX Upgrade TODO

## Phase 1: Core Infrastructure

- [x] Create AnimatedExpansionCard widget in lib/ui/widgets/animated_expansion_card.dart
- [x] Add search functionality to SettingsScreen (TextField with filtering logic)

## Phase 2: Replace ExpansionTiles

- [x] Replace \_buildAppearanceSection ExpansionTile with AnimatedExpansionCard
- [x] Replace \_buildNotificationsSection ExpansionTile with AnimatedExpansionCard
- [x] Replace \_buildTaskSoundsSection ExpansionTile with AnimatedExpansionCard
- [x] Replace \_buildPomodoroSection ExpansionTile with AnimatedExpansionCard
- [x] Replace \_buildBackupSection ExpansionTile with AnimatedExpansionCard
- [x] Replace \_buildPrivacySection ExpansionTile with AnimatedExpansionCard
- [x] Replace \_buildRegionalSection ExpansionTile with AnimatedExpansionCard
- [x] Replace \_buildUpdatesSection ExpansionTile with AnimatedExpansionCard

## Phase 3: UI Improvements

- [x] Improve custom Pomodoro settings: replace TextFields with Sliders
- [x] Apply AppCardStyles and AppButtonStyles consistently
- [x] Add consistent icons to all sections
- [x] Improve spacing and layout using AppSpacing
- [x] Add tooltips to complex settings
- [x] Add confirmation dialog for reset button

## Phase 4: Animations and Interactions

- [x] Add animations for switch toggles and state changes (built-in)
- [x] Ensure smooth expand/collapse animations
- [x] Add accessibility improvements (semantic labels, screen reader support)

## Phase 5: Testing and Polish

- [ ] Test on different screen sizes and orientations
- [ ] Verify animations performance
- [ ] Check accessibility features
- [ ] Final UI/UX review and adjustments
