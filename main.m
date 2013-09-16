//
//  main.m
//  Fox
//
//  Created by Keiran Flanigan on 11/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoxAppDelegate.h"

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([FoxAppDelegate class]));
    [pool release];
    return retVal;
}

