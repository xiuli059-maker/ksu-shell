#import <Foundation/Foundation.h>
#import <dlfcn.h>

// 用 dlsym 运行时取私有 SecTask API，读自身签名 entitlements 里的 App Group
typedef void *SecTaskRef;
typedef SecTaskRef (*SecTaskCreateFromSelfFn)(CFAllocatorRef);
typedef CFTypeRef (*SecTaskCopyValueFn)(SecTaskRef, CFStringRef, CFErrorRef *);

NSArray<NSString *> *WQSignedAppGroups(void) {
    void *sec = dlopen("/System/Library/Frameworks/Security.framework/Security", RTLD_LAZY);
    if (!sec) return @[];
    SecTaskCreateFromSelfFn create = (SecTaskCreateFromSelfFn)dlsym(sec, "SecTaskCreateFromSelf");
    SecTaskCopyValueFn copy = (SecTaskCopyValueFn)dlsym(sec, "SecTaskCopyValueForEntitlement");
    if (!create || !copy) return @[];
    SecTaskRef task = create(kCFAllocatorDefault);
    if (!task) return @[];
    CFTypeRef val = copy(task, CFSTR("com.apple.security.application-groups"), NULL);
    CFRelease(task);
    if (!val) return @[];
    NSArray *arr = (__bridge_transfer NSArray *)val;
    return [arr isKindOfClass:[NSArray class]] ? arr : @[];
}