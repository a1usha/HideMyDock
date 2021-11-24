//
//  Creds: https://ianyh.com/blog/identifying-spaces-in-mac-os-x/
//
//  Utils.m
//  HideMyDock
//
//  Created by Александр Ушаев on 24.11.2021.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#include "Utils.h"

@implementation Utils

- (NSString *)activeSpaceIdentifier {
    [[NSUserDefaults standardUserDefaults] removeSuiteNamed:@"com.apple.spaces"];
    [[NSUserDefaults standardUserDefaults] addSuiteNamed:@"com.apple.spaces"];

    NSArray *spaceProperties = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"SpacesDisplayConfiguration"][@"Space Properties"];
    NSMutableDictionary *spaceIdentifiersByWindowNumber = [NSMutableDictionary dictionary];
    for (NSDictionary *spaceDictionary in spaceProperties) {
        NSArray *windows = spaceDictionary[@"windows"];
        for (NSNumber *window in windows) {
            if (spaceIdentifiersByWindowNumber[window]) {
                spaceIdentifiersByWindowNumber[window] = [spaceIdentifiersByWindowNumber[window] arrayByAddingObject:spaceDictionary[@"name"]];
            } else {
                spaceIdentifiersByWindowNumber[window] = @[ spaceDictionary[@"name"] ];
            }
        }
    }

    CFArrayRef windowDescriptions = CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    NSString *activeSpaceIdentifier = nil;

    for (NSDictionary *dictionary in (__bridge NSArray *)windowDescriptions) {
        NSNumber *windowNumber = dictionary[(__bridge NSString *)kCGWindowNumber];
        NSArray *spaceIdentifiers = spaceIdentifiersByWindowNumber[windowNumber];

        if (spaceIdentifiers.count == 1) {
            activeSpaceIdentifier = spaceIdentifiers[0];
            break;
        }
    }

    CFRelease(windowDescriptions);

    return activeSpaceIdentifier;
}

@end
