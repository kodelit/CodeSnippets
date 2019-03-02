# Ext: ObjC exception chatcher 
- **shortcut**: `ext_ObjcExceptionCatcher`
- **language**: Objective-C
- **platform**: 

## Summary
Header (.h) file with inline method to catch objc exeptions in swift

## Code:
```objective-c
//
//  ExceptionCatcher.h
//  source: https://stackoverflow.com/a/35003095/1776859
//

#import <Foundation/Foundation.h>

NS_INLINE NSException * _Nullable tryBlock(void(^_Nonnull tryBlock)(void)) {
    @try {
        tryBlock();
    }
    @catch (NSException *exception) {
        return exception;
    }
    return nil;
}

```