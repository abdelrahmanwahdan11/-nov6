# NeoBrutalistPollApp Production Blueprint

This blueprint consolidates the complete functional, architectural, and experience requirements
for delivering the fully mocked, offline-first Neo Brutalist social polling application. It expands
on the previous implementation drops and captures every capability described across phases 1–7 of
the product brief so engineering can scope, implement, and validate the remaining work.

## Core Tenets

1. **100% Local, Mocked Stack**  
   - No runtime network access. All persistence is handled with Hive boxes and Shared Preferences.  
   - Mock repositories (Riverpod providers) emulate service layers: authentication, polls,
     analytics, gamification, notifications, chat, and export.

2. **Offline-First Execution**  
   - Offline toggle stored in preferences.  
   - Action queue (Hive box) captures create / vote / comment / follow / bookmark actions while
     offline.  
   - MockSyncService drains the queue and replays payloads through repositories when connectivity
     resumes.

3. **Real-Time Simulation**  
   - MockWebSocketProvider streams faux events (votes, comments, follows) sourced from the bot
     service.  
   - UI layers subscribe to the stream and update local state immediately without manual refresh.

4. **Gamification & Pro Monetization**  
   - Points awarded for all engagement actions.  
   - Badges unlocked via GamificationService.  
   - Confetti and celebratory dialogs appear on badge unlocks.  
   - Pro subscription flag (Hive) gates image polls, analytics, and any other premium surface.

5. **Accessibility & Localization**  
   - Full intl support (en/ar) for every new string.  
   - Semantics widgets label icons, images, toggles, and list tiles.  
   - Touch targets ≥ 48 px with clear focus order and high contrast across light/dark modes.

## Domain Model Inventory

### Hive Boxes

| Box | Contents |
| --- | --- |
| `main_box` | Polls, PollOptions, Comments, Notifications, UserStats, Badge catalog |
| `user_box` | Users (auth data, profile metadata, gamification state, bookmarks, pro flag) |
| `action_queue_box` | Pending `ActionQueueItem` payloads when offline |
| `chat_box` | `ChatMessage` history for the support bot |

### Entities

- **User**: `id`, `name`, `email`, `passwordHash`, `bio`, `localAvatarPath`, `localBannerPath`,
  `isPro`, `points`, `followingUserIds`, `bookmarkedPollIds`, `bookmarkedPollsOrder`.  
- **Poll**: `id`, `question`, `pollType` (`text` or `image`), `authorId`, `category`,
  `options`, `endDate`, `headerImageUrl?`.  
- **PollOption**: `id`, `text`, `imagePath?`, `voteCount`.  
- **Comment**: `id`, `pollId`, `authorId`, `text`, `timestamp`.  
- **Notification**: `id`, `userId`, `text`, `timestamp`, `isRead`, `routeLink`.  
- **UserVote**: persists the chosen option for duplicate-prevention.  
- **UserStats**: `userId`, `earnedBadgeIds`, `currentStreak`.  
- **Badge**: read-only catalog seeded at bootstrap (id, name, description, icon asset,
  `pointsTarget`).  
- **ChatMessage**: `id`, `isFromUser`, `text`, `timestamp`.  
- **ActionQueueItem**: `actionType`, `payload` map for deferred processing.

## Provider Surface

- `authStatusProvider`: watches authentication stream (guest, authed, signed-out).  
- `MockAuthRepository`: login / signup / logout / guest / current user retrieval, updates Hive.  
- `MockPollRepository`: CRUD polls, options, votes, comments, search, categories, following feed,
  analytics helpers, bookmark order persistence, and queue-aware writes.  
- `MockUserRepository`: edit profile (name, bio, avatar, banner), follow/unfollow, bookmark toggles.  
- `MockNotificationRepository`: notification feed, mark read/delete, generate synthetic events.  
- `MockAnalyticsProvider`: aggregates poll/vote stats and chart series for current user.  
- `GamificationService`: increments points, unlocks badges, triggers confetti via notifier events.  
- `ProStatusProvider`: exposes `isPro` flag with listeners for gating premium experiences.  
- `MockChatProvider`: chat history, user/bot message orchestration, delayed canned responses.  
- `MockBotService`: timer-driven generation of faux activity, pushes into `MockWebSocketProvider`.  
- `MockWebSocketProvider`: StreamProvider broadcasting `PollEvent` / `CommentEvent` updates.  
- `OfflineModeProvider`: Riverpod state toggled from settings.  
- `MockSyncService`: consumes `action_queue_box` when offline mode disabled.  
- `ExportDataService`: collects user-centric data and serializes JSON for sharing.  
- UI helpers: category filters, search query/results, poll details family providers, comment streams,
  bookmarked polls stream, following feed stream, action feedback controllers.

## Feature Checklist

### App Shell & Navigation

- Splash → Onboarding → Auth flows with Shared Preferences gating.  
- `ShellRoute` hosting bottom navigation (Home, Search, Notifications, Profile) and centered FAB.  
- All secondary screens (create, settings, analytics, bookmarks, badges, profile edit, support chat,
  poll details/results) presented via GoRouter sub-routes with brutalist transitions.

### Home Experience

- TabBar (Popular vs Following) with category filter chips driving `pollListProvider`.  
- Guest gating for creation/voting with localized dialogs.  
- ShowcaseView tour after first authenticated landing.  
- Poll cards include vote counts, status, optional image badge, swipe-to-bookmark, animated entry.  
- Offline queued actions provide snackbars indicating deferred sync.

### Poll Lifecycle

- Creation: choose Text vs Image poll, mandatory category, settings nested route, image pickers for
  up to four options, Pro gate enforced for image polls.  
- Details: dynamic layout for text list vs image grid, bookmark toggle, comment section with timeago,
  real-time updates from websocket events, comment composer (authenticated only).  
- Results: animated bars/overlays, confetti on badge unlock, localized empty states.  
- Deletion controls for authors (from details and profile).  
- Offline queue ensures votes/comments captured while offline and replayed later.

### Search & Discovery

- Search page with brutalist text field, debounce, Riverpod stream results across questions and
  option text, animated list entry, empty state illustrations.  
- Category filters shared with home; search respects offline data.

### Profile Surfaces

- Self profile: banner/avatar display, points + Pro badge, quick links to Edit / Bookmarks /
  Badges / Analytics / Settings / Logout.  
- Profile tabs for "My Polls" (with delete) and optional "My Comments" feed.  
- Bookmarks: reorderable list storing order, swipe to remove, offline-friendly.  
- Analytics: Pro-locked view with in-context paywall; charts via `fl_chart`.  
- Badges: grid of earned vs locked states, confetti overlay when new badge triggered.  
- Edit profile: brutalist form for name/bio, avatar/banner pickers with local file persistence.  
- Other-user profile: follow/unfollow button, follow state stored in Hive, list of authored polls.

### Notifications & Support

- Notifications tab: dismissible rows for mark-read/delete, streaming updates, empty state art.  
- MockWebSocketProvider + MockNotificationRepository produce updates on votes, comments,
  bot actions.  
- Support chat: brutalist chat bubbles, semantics labels, Riverpod-backed message list, canned
  responses after delay, offline queuing for outbound messages.

### Gamification & Pro

- Points accrual rates: +10 create poll, +1 vote, +2 comment, +5 receive comment, etc.  
- Badges: tiered achievements (first poll, five polls, streaks, pro subscriber).  
- Confetti animation and modal when badge earned.  
- Pro paywall page detailing benefits with mock purchase button (updates Hive, toggles provider).  
- UI surfaces respect `isPro` (buttons disabled/redirect to paywall, lock icons, semantics labels).

### Offline & Real-Time Infrastructure

- Offline toggle stored via preferences, drives provider watchers.  
- ActionQueueItem schema enumerates supported action types with payload validation.  
- Sync service emits progress events (for snackbars / settings indicator).  
- MockWebSocketProvider merges bot events and manual triggers to keep poll/comment counts in sync.

### Data Export

- Settings button invokes ExportDataService to compose JSON blob of user account, polls, votes,
  comments, bookmarks, stats, badges, notifications.  
- Output displayed in modal with copy/share options (share_plus integration) and accessibility
  labels.

### Accessibility & Localization

- All interactive widgets wrapped in Semantics with localized labels and hints.  
- Focus order defined for keyboard traversal where applicable.  
- Screen readers announce dynamic updates (snackbars, confetti) via `SemanticsService`.  
- Both English and Arabic l10n bundles expanded to cover every new string (auth, gamification,
  analytics, offline sync, paywall, chat, export, badges, websocket events).

## Implementation Roadmap

1. **Model & Hive Schema Updates**: Extend adapters for new fields (avatar paths, pro flag,
   points, bookmark order, poll type images, action queue).  
2. **Repository Enhancements**: Wire offline queue gating, gamification callbacks, websocket
   broadcasts, and analytics aggregations.  
3. **UI Pass**: Update screens for new controls (paywall, tabs, swipe actions, animations,
   semantics).  
4. **Localization Sweep**: Add intl keys, regenerate message code, verify RTL layouts.  
5. **Testing Strategy**: Golden tests for brutalist widgets, repository unit tests with Hive in
   memory, integration smoke flows for offline queue and websocket simulation.  
6. **Polish & Accessibility**: Run semantics tester, manual screen reader verification, ensure
   48px tap targets and dark-mode contrast compliance.  
7. **Performance Considerations**: Lazy Hive reads, memoized streams, animation throttling for
   large lists, clean disposal of websocket timers.

This document serves as the single source of truth for finalizing the NeoBrutalistPollApp feature
set before any future backend integration efforts.
