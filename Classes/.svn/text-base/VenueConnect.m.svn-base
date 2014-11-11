//
//  VenueConnect.m
//
//  Created by Mark Ferguson on 4/25/10.
//  Copyright 2010 Rage Digital Inc. All rights reserved.
//

#import "VenueConnect.h"

static VenueConnect *sharedVenueConnect = nil;

@implementation VenueConnect

@synthesize configuration; 

#pragma mark Singleton Methods

+ (id)sharedVenueConnect
{
    @synchronized(self) {	
		if (sharedVenueConnect == nil) {
			[[self alloc] init];
		}
	}
    return sharedVenueConnect;
}

+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) {
		if(sharedVenueConnect == nil)  {
			sharedVenueConnect = [super allocWithZone:zone];
			return sharedVenueConnect;
		}
	}
	return nil;
}



- (id)copyWithZone:(NSZone *)zone
{
    return self;
}


- (id)retain
{
    return self;
}


- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}


- (void)release
{
    //never release
}


- (id)autorelease
{
    return self;
}

- (id)init {
	if (self = [super init]) {
		NSString *path = [[NSBundle mainBundle] bundlePath];
		NSString *finalPath = [path stringByAppendingPathComponent:@"venueConfiguration.plist"];
		configuration = [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath];
	}
	return self;
}
	
- (void)dealloc 
{
	// Should never be called, but just here for clarity really.
	[configuration release];
	[super dealloc];
}

- (BOOL)isConnectedToInternet 
{
	return ([NSString stringWithContentsOfURL:[NSURL URLWithString:[configuration objectForKey:@"internetConnectionCheckURL"]] encoding:NSUTF8StringEncoding error:nil]!=NULL)?YES:NO;
}

- (NSString *) appName {
	return [configuration objectForKey:@"appName"];
}

- (NSString *) venueName {
	return [configuration objectForKey:@"venueName"];
}

- (NSString *) venueURL {
	return [configuration objectForKey:@"venueURL"];
}

- (NSNumber *) venueLatitude {
	return [configuration objectForKey:@"venueLatitude"];
}

- (NSNumber *) venueLongitude {
	return [configuration objectForKey:@"venueLongitude"];
}

- (NSString *) venueCity {
	return [configuration objectForKey:@"venueCity"];
}

- (NSString *) venueState {
	return [configuration objectForKey:@"venueState"];
}



- (NSString *) appServerFeedURL {
	return [configuration objectForKey:@"appServerFeedURL"];
}

- (NSString *) appServerUserURL {
	return [configuration objectForKey:@"appServerUserURL"];
}

- (NSString *) appServerWallURL {
	return [configuration objectForKey:@"appServerWallURL"];
}



- (NSString *) defaultJSONCalendarFeedURL {
	return [configuration objectForKey:@"defaultJSONCalendarFeedURL"];
}

- (NSString *) defaultTwitterFeedURL {
	return [configuration objectForKey:@"defaultTwitterFeedURL"];
}

- (NSString *) defaultFacebookFeedURL {
	return [configuration objectForKey:@"defaultFacebookFeedURL"];
}




- (NSString *) flurryAPIKey{
	return [configuration objectForKey:@"flurrAPIKey"];
}




- (NSString *) pushNotificationApplicationKey{
	return [configuration objectForKey:@"pushNotificationApplicationKey"];
}

- (NSString *) pushNotificationApplicationSecret{
	return [configuration objectForKey:@"pushNotificationApplicationSecret"];
}




- (NSString *) facebookAPIKey {
	return [configuration objectForKey:@"facebookAPIKey"];
}

- (NSString *) facebookAPISecret {
	return [configuration objectForKey:@"facebookAPISecret"];
}

- (NSString *) facebookPostIcon {
	return [configuration objectForKey:@"facebookPostIcon"];
}

- (NSString *) twitterCommentSignature {
	return [configuration objectForKey:@"twitterCommentSignature"];
}




- (NSString *) rageDigitalBaseURL{
	return [configuration objectForKey:@"rageDigitalBaseURL"];
}

- (NSString *) internetConnectionCheckURL{
	return [configuration objectForKey:@"internetConnectionCheckURL"];
}

- (NSString *) adImagesURL {
	return [configuration objectForKey:@"adImagesURL"];
}


- (NSString *) uploadPostImageURL {
	return [configuration objectForKey:@"uploadPostImageURL"];
}

- (NSString *) appStoreURL {
	return [configuration objectForKey:@"appStoreURL"];
}

@end
