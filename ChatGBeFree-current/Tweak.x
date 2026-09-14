#import <Foundation/Foundation.h>

// Minimal process-local app-version spoof for the official ChatGPT app only.
%hook NSBundle
- (NSDictionary *)infoDictionary {
    NSDictionary *dict = %orig;
    NSString *bundleID = [dict objectForKey:@"CFBundleIdentifier"];
    if ([bundleID isEqualToString:@"com.openai.chat"]) {
        NSMutableDictionary *modDict = [dict mutableCopy];
        modDict[@"CFBundleShortVersionString"] = @"1.2099.999";
        modDict[@"CFBundleVersion"] = @"99999999999";
        return modDict;
    }
    return dict;
}
%end

%ctor {
    NSLog(@"[ChatGBeFree] Loaded successfully");
}
