# ChatGPT Native Compat baseline — 2026-09-14

Workspace: E:\iOS-External-Workspace\ChatGPT-Native-Compat

## Device
- ProductType: iPhone14,2
- ProductVersion: 16.6
- BuildVersion: 20G75
- CPU: arm64e
- USB device is visible to pymobiledevice3.
- Developer Mode: enabled.

## Installed native ChatGPT
- Bundle ID: com.openai.chat
- CFBundleShortVersionString: 1.2024.348
- CFBundleVersion: 12643679358
- MinimumOSVersion: 16.4
- App bundle path: /private/var/containers/Bundle/Application/6DEB9FDB-5BD6-4C1B-85E6-287DA0F88C61/ChatGPT.app
- Data container exists: /private/var/mobile/Containers/Data/Application/8690ABD1-1EC7-4673-9CC9-EB794678A6B7
- App group container exists: /private/var/mobile/Containers/Shared/AppGroup/9282891F-F279-4925-893A-A8BC271B031C
- No ChatGPT crash report name was found in the inspected crash-list output.

## Existing device tooling
- TrollStore 2.1.1 installed.
- Dopamine 3.0.9 installed.
- Common TrollFools bundle IDs queried were not installed.
- The current active tweak-injection state has not yet been proven from process/runtime evidence.

## WebCompat cleanup check
- com.cloudcode.chatgptwebcompat query returned no installed app; no uninstall was needed.

## ChatGBeFree source audit
- Current main filters only com.openai.chat.
- Current main hooks NSBundle infoDictionary only.
- Current main spoofs CFBundleShortVersionString to 1.2099.999 and CFBundleVersion to 99999999999.
- Current main has no network hook, Keychain access, Cookie access, token extraction, upload path, or credential-reading code in Tweak.x.
- Current main is configured as THEOS_PACKAGE_SCHEME=rootless.
- v1.0.0 release/tag is older than current main and contains an NSURLSession response hook. Do not use the prebuilt v1.0.0 deb for the minimal first experiment.

## Safety boundary
- Do not uninstall com.openai.chat.
- Do not clear its data/container.
- Do not log out.
- Do not modify D:\wendangcodex\CloudCode-iOS.
- Do not perform global iOS version spoofing.
