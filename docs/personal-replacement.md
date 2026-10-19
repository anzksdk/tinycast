# Replace the official app while keeping your setup

The personal replacement is named **Tinycast.app** and uses the official stable bundle identifier,
`com.tinycast.app`. It reads the same preferences, Application Support directory, settings-file mirror
and Keychain service names. It does not copy, reset or import those stores.

**Tinycast Dev.app is different:** its `com.tinycast.app.dev` identifier deliberately has separate data.
Renaming its app bundle does not turn it into a replacement for the stable app.

## On the Mac with your existing setup

1. Quit Tinycast from its menu. Keep a copy of the currently installed `Tinycast.app` for rollback.
2. Copy these existing locations to a local backup folder. Keep the entire Application Support folder,
   including any SQLite sidecar files. Do not upload this backup: it can contain private content.
   - `~/Library/Application Support/com.tinycast.app/`
   - `~/Library/Preferences/com.tinycast.app.plist`
   - `~/.config/tinycast/`, if you enabled the settings-file mirror
   - Any custom Notes or Snippets folders you chose outside Application Support
3. Unzip **Tinycast-0.11.19-boyin.1-arm64.zip**, then replace the existing app at its current location,
   normally `/Applications/Tinycast.app`. Replace the app bundle only; keep its data directories.
4. Open Tinycast. Existing settings and history should appear without an import. Search `settings` and
   use ⌘2 to check the second-result shortcut. The personal build is identified by `TinycastPersonalBuild`
   in its Info.plist and keeps the official updater disabled without changing your saved preference.

The built-in `.tinycast` export is useful as an additional backup, but it excludes extensions,
AI chat history and Keychain items. A same-Mac replacement leaves those items in place.

The personal app has an ad-hoc signature, not the upstream developer's certificate, and is not notarized.
macOS may require approval in Privacy & Security before it opens. Accessibility, Input Monitoring,
other protected-resource permissions, and access to saved Keychain items may need renewed approval.
Keep the existing Keychain items; if an item cannot be authorized for the new signature, re-enter its
key in Tinycast. Ad-hoc signing may require renewed permission after a later personal build as well.

If Homebrew manages your official installation, a later `brew upgrade` or reinstall can replace this
personal app with the official build. The in-app updater is disabled in this package; Homebrew is
separate. Use this fork's packages when updating the personal version.

## Roll back

Quit the personal app, restore the saved original application, and reopen it. If data was changed
after the replacement, restore your local data backup while Tinycast is stopped. Keep copies of both
the before and after data until you have verified the rollback. Existing Keychain entries stay on
the same Mac; they are not bundled or exported by this package.

## Build identity

This package is built from this fork's current source, which includes changes on upstream `main`
after the official v0.11.19 release, plus numbered result activation. Its application version remains
0.11.19, its build number is 1000001, and `TinycastPersonalBuild` is `boyin.1`.

The main and helper bundles retain hardened runtime and the existing resource entitlements.
No system security settings, permissions or Keychain trust settings are changed by building the zip.
