#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

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

static BOOL CGBFIsOpenAIHost(NSString *host) {
    NSString *lower = host.lowercaseString;
    return [lower isEqualToString:@"openai.com"] ||
           [lower hasSuffix:@".openai.com"] ||
           [lower isEqualToString:@"chatgpt.com"] ||
           [lower hasSuffix:@".chatgpt.com"];
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

// Some code paths query the main bundle through CoreFoundation rather than
// NSBundle. Cover the two version keys there as well without changing any
// device-wide OS metadata.
%hookf(CFTypeRef, CFBundleGetValueForInfoDictionaryKey, CFBundleRef bundle, CFStringRef key) {
    if (bundle == CFBundleGetMainBundle() && key != NULL) {
        if (CFEqual(key, CFSTR("CFBundleShortVersionString"))) {
            NSLog(@"[ChatGBeFree] CFBundle short version -> 1.2099.999");
            return (__bridge CFTypeRef)@"1.2099.999";
        }
        if (CFEqual(key, CFSTR("CFBundleVersion"))) {
            NSLog(@"[ChatGBeFree] CFBundle build version -> 99999999999");
            return (__bridge CFTypeRef)@"99999999999";
        }
    }
    return %orig;
}

%ctor {
    NSLog(@"[ChatGBeFree] Loaded v5 successfully in %@", [[NSBundle mainBundle] bundleIdentifier]);
}
