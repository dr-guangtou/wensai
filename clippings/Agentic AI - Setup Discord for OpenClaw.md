---
title: "Agentic AI - Setup Discord for OpenClaw"
source: "https://docs.openclaw.ai/channels/discord#ask-your-agent-5"
author:
  - "[[OpenClaw]]"
published:
created: 2026-02-20
description:
tags:
  - "clippings"
  - "agentic"
  - "openclaw"
---
## Discord (Bot API)

Status: ready for DMs and guild channels via the official Discord gateway.## [Pairing](https://docs.openclaw.ai/channels/pairing)

[

Discord DMs default to pairing mode.

](https://docs.openclaw.ai/channels/pairing)Slash commands

Native command behavior and command catalog.

[View original](https://docs.openclaw.ai/tools/slash-commands)Channel troubleshooting

Cross-channel diagnostics and repair flow.

[View original](https://docs.openclaw.ai/channels/troubleshooting)

## Quick setup

You will need to create a new application with a bot, add the bot to your server, and pair it to OpenClaw. We recommend adding your bot to your own private server. If you don’t have one yet, [create one first](https://support.discord.com/hc/en-us/articles/204849977-How-do-I-create-a-server) (choose **Create My Own > For me and my friends**).

Token resolution is account-aware. Config token values win over env fallback. `DISCORD_BOT_TOKEN` is only used for the default account.

Once DMs are working, you can set up your Discord server as a full workspace where each channel gets its own agent session with its own context. This is recommended for private servers where it’s just you and your bot.Now create some channels on your Discord server and start chatting. Your agent can see the channel name, and each channel gets its own isolated session — so you can set up `#coding`, `#home`, `#research`, or whatever fits your workflow.

## Runtime model

- Gateway owns the Discord connection.
- Reply routing is deterministic: Discord inbound replies back to Discord.
- By default (`session.dmScope=main`), direct chats share the agent main session (`agent:main:main`).
- Guild channels are isolated session keys (`agent:<agentId>:discord:channel:<channelId>`).
- Group DMs are ignored by default (`channels.discord.dm.groupEnabled=false`).
- Native slash commands run in isolated command sessions (`agent:<agentId>:discord:slash:<userId>`), while still carrying `CommandTargetSessionKey` to the routed conversation session.

## Interactive components

OpenClaw supports Discord components v2 containers for agent messages. Use the message tool with a `components` payload. Interaction results are routed back to the agent as normal inbound messages and follow the existing Discord `replyToMode` settings.Supported blocks:
- `text`, `section`, `separator`, `actions`, `media-gallery`, `file`
- Action rows allow up to 5 buttons or a single select menu
- Select types: `string`, `user`, `role`, `mentionable`, `channel`
By default, components are single use. Set `components.reusable=true` to allow buttons, selects, and forms to be used multiple times until they expire.To restrict who can click a button, set `allowedUsers` on that button (Discord user IDs, tags, or `*`). When configured, unmatched users receive an ephemeral denial.File attachments:
- `file` blocks must point to an attachment reference (`attachment://<filename>`)
- Provide the attachment via `media` / `path` / `filePath` (single file); use `media-gallery` for multiple files
- Use `filename` to override the upload name when it should match the attachment reference
Modal forms:
- Add `components.modal` with up to 5 fields
- Field types: `text`, `checkbox`, `radio`, `select`, `role-select`, `user-select`
- OpenClaw adds a trigger button automatically
Example:

```
{

  channel: "discord",

  action: "send",

  to: "channel:123456789012345678",

  message: "Optional fallback text",

  components: {

    reusable: true,

    text: "Choose a path",

    blocks: [

      {

        type: "actions",

        buttons: [

          {

            label: "Approve",

            style: "success",

            allowedUsers: ["123456789012345678"],

          },

          { label: "Decline", style: "danger" },

        ],

      },

      {

        type: "actions",

        select: {

          type: "string",

          placeholder: "Pick an option",

          options: [

            { label: "Option A", value: "a" },

            { label: "Option B", value: "b" },

          ],

        },

      },

    ],

    modal: {

      title: "Details",

      triggerLabel: "Open form",

      fields: [

        { type: "text", label: "Requester" },

        {

          type: "select",

          label: "Priority",

          options: [

            { label: "Low", value: "low" },

            { label: "High", value: "high" },

          ],

        },

      ],

    },

  },

}
```

## Access control and routing

- DM policy
- Guild policy
- Mentions and group DMs

`channels.discord.dmPolicy` controls DM access (legacy: `channels.discord.dm.policy`):
- `pairing` (default)
- `allowlist`
- `open` (requires `channels.discord.allowFrom` to include `"*"`; legacy: `channels.discord.dm.allowFrom`)
- `disabled`
If DM policy is not open, unknown users are blocked (or prompted for pairing in `pairing` mode).DM target format for delivery:
- `user:<id>`
- `<@id>` mention
Bare numeric IDs are ambiguous and rejected unless an explicit user/channel target kind is provided.

### Role-based agent routing

Use `bindings[].match.roles` to route Discord guild members to different agents by role ID. Role-based bindings accept role IDs only and are evaluated after peer or parent-peer bindings and before guild-only bindings. If a binding also sets other match fields (for example `peer` + `guildId` + `roles`), all configured fields must match.

## Developer Portal setup

1. Discord Developer Portal -> **Applications** -> **New Application**
2. **Bot** -> **Add Bot**
3. Copy bot token

Privileged intents

OAuth URL generator:
- scopes: `bot`, `applications.commands`
Typical baseline permissions:
- View Channels
- Send Messages
- Read Message History
- Embed Links
- Attach Files
- Add Reactions (optional)
Avoid `Administrator` unless explicitly needed.

Copy IDs

Enable Discord Developer Mode, then copy:
- server ID
- channel ID
- user ID
Prefer numeric IDs in OpenClaw config for reliable audits and probes.

## Native commands and command auth

- `commands.native` defaults to `"auto"` and is enabled for Discord.
- Per-channel override: `channels.discord.commands.native`.
- `commands.native=false` explicitly clears previously registered Discord native commands.
- Native command auth uses the same Discord allowlists/policies as normal message handling.
- Commands may still be visible in Discord UI for users who are not authorized; execution still enforces OpenClaw auth and returns “not authorized”.
See [Slash commands](https://docs.openclaw.ai/tools/slash-commands) for command catalog and behavior.

## Feature details

Discord supports reply tags in agent output:
- `[[reply_to_current]]`
- `[[reply_to:<id>]]`
Controlled by `channels.discord.replyToMode`:
- `off` (default)
- `first`
- `all`
Note: `off` disables implicit reply threading. Explicit `[[reply_to_*]]` tags are still honored.Message IDs are surfaced in context/history so agents can target specific messages.

Guild history context:
- `channels.discord.historyLimit` default `20`
- fallback: `messages.groupChat.historyLimit`
- `0` disables
DM history controls:
- `channels.discord.dmHistoryLimit`
- `channels.discord.dms["<user_id>"].historyLimit`
Thread behavior:
- Discord threads are routed as channel sessions
- parent thread metadata can be used for parent-session linkage
- thread config inherits parent channel config unless a thread-specific entry exists
Channel topics are injected as **untrusted** context (not as system prompt).

Reaction notifications

Per-guild reaction notification mode:
- `off`
- `own` (default)
- `all`
- `allowlist` (uses `guilds.<id>.users`)
Reaction events are turned into system events and attached to the routed Discord session.

Ack reactions

`ackReaction` sends an acknowledgement emoji while OpenClaw is processing an inbound message.Resolution order:
- `channels.discord.accounts.<accountId>.ackReaction`
- `channels.discord.ackReaction`
- `messages.ackReaction`
- agent identity emoji fallback (`agents.list[].identity.emoji`, else ”👀”)
Notes:
- Discord accepts unicode emoji or custom emoji names.
- Use `""` to disable the reaction for a channel or account.

Config writes

Channel-initiated config writes are enabled by default.This affects `/config set|unset` flows (when command features are enabled).Disable:

Gateway proxy

Route Discord gateway WebSocket traffic and startup REST lookups (application ID + allowlist resolution) through an HTTP(S) proxy with `channels.discord.proxy`.Per-account override:

PluralKit support

Enable PluralKit resolution to map proxied messages to system member identity:Notes:
- allowlists can use `pk:<memberId>`
- member display names are matched by name/slug
- lookups use original message ID and are time-window constrained
- if lookup fails, proxied messages are treated as bot messages and dropped unless `allowBots=true`

Presence configuration

Presence updates are applied only when you set a status or activity field.Status only example:Activity example (custom status is the default activity type):Streaming example:Activity type map:
- 0: Playing
- 1: Streaming (requires `activityUrl`)
- 2: Listening
- 3: Watching
- 4: Custom (uses the activity text as the status state; emoji is optional)
- 5: Competing

Discord supports button-based exec approvals in DMs and can optionally post approval prompts in the originating channel.Config path:
- `channels.discord.execApprovals.enabled`
- `channels.discord.execApprovals.approvers`
- `channels.discord.execApprovals.target` (`dm` | `channel` | `both`, default: `dm`)
- `agentFilter`, `sessionFilter`, `cleanupAfterResolve`
When `target` is `channel` or `both`, the approval prompt is visible in the channel. Only configured approvers can use the buttons; other users receive an ephemeral denial. Approval prompts include the command text, so only enable channel delivery in trusted channels. If the channel ID cannot be derived from the session key, OpenClaw falls back to DM delivery.If approvals fail with unknown approval IDs, verify approver list and feature enablement.Related docs: [Exec approvals](https://docs.openclaw.ai/tools/exec-approvals)

## Tools and action gates

Discord message actions include messaging, channel admin, moderation, presence, and metadata actions.Core examples:
- messaging: `sendMessage`, `readMessages`, `editMessage`, `deleteMessage`, `threadReply`
- reactions: `react`, `reactions`, `emojiList`
- moderation: `timeout`, `kick`, `ban`
- presence: `setPresence`
Action gates live under `channels.discord.actions.*`.Default gate behavior:

## Components v2 UI

OpenClaw uses Discord components v2 for exec approvals and cross-context markers. Discord message actions can also accept `components` for custom UI (advanced; requires Carbon component instances), while legacy `embeds` remain available but are not recommended.
- `channels.discord.ui.components.accentColor` sets the accent color used by Discord component containers (hex).
- Set per account with `channels.discord.accounts.<id>.ui.components.accentColor`.
- `embeds` are ignored when components v2 are present.
Example:

## Voice messages

Discord voice messages show a waveform preview and require OGG/Opus audio plus metadata. OpenClaw generates the waveform automatically, but it needs `ffmpeg` and `ffprobe` available on the gateway host to inspect and convert audio files.Requirements and constraints:
- Provide a **local file path** (URLs are rejected).
- Omit text content (Discord does not allow text + voice message in the same payload).
- Any audio format is accepted; OpenClaw converts to OGG/Opus when needed.
Example:

## Troubleshooting

- enable Message Content Intent
- enable Server Members Intent when you depend on user/member resolution
- restart gateway after changing intents

- verify `groupPolicy`
- verify guild allowlist under `channels.discord.guilds`
- if guild `channels` map exists, only listed channels are allowed
- verify `requireMention` behavior and mention patterns
Useful checks:

Common causes:
- `groupPolicy="allowlist"` without matching guild/channel allowlist
- `requireMention` configured in the wrong place (must be under `channels.discord.guilds` or channel entry)
- sender blocked by guild/channel `users` allowlist

`channels status --probe` permission checks only work for numeric channel IDs.If you use slug keys, runtime matching can still work, but probe cannot fully verify permissions.

- DM disabled: `channels.discord.dm.enabled=false`
- DM policy disabled: `channels.discord.dmPolicy="disabled"` (legacy: `channels.discord.dm.policy`)
- awaiting pairing approval in `pairing` mode

By default bot-authored messages are ignored.If you set `channels.discord.allowBots=true`, use strict mention and allowlist rules to avoid loop behavior.

## Configuration reference pointers

Primary reference:
- [Configuration reference - Discord](https://docs.openclaw.ai/gateway/configuration-reference#discord)
High-signal Discord fields:
- startup/auth: `enabled`, `token`, `accounts.*`, `allowBots`
- policy: `groupPolicy`, `dm.*`, `guilds.*`, `guilds.*.channels.*`
- command: `commands.native`, `commands.useAccessGroups`, `configWrites`
- reply/history: `replyToMode`, `historyLimit`, `dmHistoryLimit`, `dms.*.historyLimit`
- delivery: `textChunkLimit`, `chunkMode`, `maxLinesPerMessage`
- media/retry: `mediaMaxMb`, `retry`
- actions: `actions.*`
- presence: `activity`, `status`, `activityType`, `activityUrl`
- UI: `ui.components.accentColor`
- features: `pluralkit`, `execApprovals`, `intents`, `agentComponents`, `heartbeat`, `responsePrefix`

## Safety and operations

- Treat bot tokens as secrets (`DISCORD_BOT_TOKEN` preferred in supervised environments).
- Grant least-privilege Discord permissions.
- If command deploy/state is stale, restart gateway and re-check with `openclaw channels status --probe`.
- [Pairing](https://docs.openclaw.ai/channels/pairing)
- [Channel routing](https://docs.openclaw.ai/channels/channel-routing)
- [Multi-agent routing](https://docs.openclaw.ai/concepts/multi-agent)
- [Troubleshooting](https://docs.openclaw.ai/channels/troubleshooting)
- [Slash commands](https://docs.openclaw.ai/tools/slash-commands)

[Telegram](https://docs.openclaw.ai/channels/telegram) [IRC](https://docs.openclaw.ai/channels/irc)