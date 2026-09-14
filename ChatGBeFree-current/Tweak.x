#import <Foundation/Foundation.h>

// Process-local app-version spoof for the official ChatGPT app only.
// The substrate filter already limits injection to com.openai.chat; inside the
// process, restrict spoofing further to NSBundle.mainBundle so frameworks and
// embedded bundles keep their real metadata.
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

%ctor {
    NSLog(@"[ChatGBeFree] Loaded v2 successfully in %@", [[NSBundle mainBundle] bundleIdentifier]);
}
