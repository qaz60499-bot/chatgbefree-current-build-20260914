#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Process-local compatibility shim for the official ChatGPT app only.
// Injection is additionally constrained by ChatGBeFree.plist to com.openai.chat.
static BOOL CGBFIsMainBundle(NSBundle *bundle) {
    return bundle == [NSBundle mainBundle];
}

static id CGBFSpoofedVersionValue(NSString *key) {
    if ([key isEqualToString:@"CFBundleShortVersionString"]) {
        return @"1.2099.999";
    }
    if ([key isEqualToString:@"CFBundleVersion"]) {
        return @"99999999999";
    }
    return nil;
}

%hook NSBundle

- (NSDictionary *)infoDictionary {
    NSDictionary *dict = %orig;
    if (!CGBFIsMainBundle(self)) {
        return dict;
    }

    NSMutableDictionary *modDict = [dict mutableCopy];
    modDict[@"CFBundleShortVersionString"] = @"1.2099.999";
    modDict[@"CFBundleVersion"] = @"99999999999";
    return modDict;
}

- (id)objectForInfoDictionaryKey:(NSString *)key {
    id spoofed = CGBFSpoofedVersionValue(key);
    if (spoofed != nil && CGBFIsMainBundle(self)) {
        NSLog(@"[ChatGBeFree] version read %@ -> %@", key, spoofed);
        return spoofed;
    }
    return %orig;
}

%end

// Current iOS 16 ChatGPT bypasses reported by the jailbreak community combine
// app-version spoofing with a process-local iOS version spoof. Keep this hook
// inside com.openai.chat only; never modify the device-wide ProductVersion.
%hook UIDevice

- (NSString *)systemVersion {
    NSLog(@"[ChatGBeFree] UIDevice.systemVersion -> 17.0");
    return @"17.0";
}

%end

%ctor {
    NSLog(@"[ChatGBeFree] Loaded v3 successfully in %@", [[NSBundle mainBundle] bundleIdentifier]);
}
