//
//  VenueConnect.h
//
//  Created by Mark Ferguson on 4/25/10.
//  Copyright 2010 Rage Digital Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VenueConnect : NSObject {
	NSMutableDictionary *configuration;
}

@property (nonatomic, retain) NSMutableDictionary *configuration; 

+ (id)sharedVenueConnect;

- (BOOL)isConnectedToInternet;

- (NSString *) getConfigKey: (NSString *)key;
// The following methods relate to settings stored in the venueConfiguration.plist

/*
- (NSString *) appName;									// The name of the app - max of 11 characters
- (NSString *) venueName;								// The name of the venue to be used in the user registration interface and elsewhere.
- (NSString *) venueURL;								// URL of venue - used for building URLs for song playback.  
- (NSNumber *) venueLatitude;							// Latitude & Longitude of venue - change to match address of venue
- (NSNumber *) venueLongitude;							//
- (NSString *) venueCity;								// City of venue - used in map info - update to match address of venue
- (NSString *) venueState;								// State of venue - used in map info - update to match address of venue

- (NSString *) appServerFeedURL;						// This is the URL to retrieve the JSON feed describing where everything is located (blog, ads, etc.).  Typically only the app name needs to change in the URL
- (NSString *) appServerUserURL;						// This is the base URL needed for pushing new user registrations to the app server.  Typically only the app name needs to change in the URL
- (NSString *) appServerWallURL;						// This is the base URL needed for wall feed retrieval.  Typically only the app name needs to change in the URL

- (NSString *) defaultJSONCalendarFeedURL;				// This is the backup URL in the event that the Blog URL specified in the client area for the venue is not set
- (NSString *) defaultTwitterFeedURL;					// This is the backup URL in the event that the Twitter specified in the client area for the venue is not set
- (NSString *) defaultFacebookFeedURL;					// This is the Graph URL to the venue's facebook feed and is a backup URL in the event that the Facebook feed specified in the client area for the venue is not set

- (NSString *) flurryAPIKey;							// The Key provided by Flurry for this particular app.  Each venueConnect app should have a unique key

- (NSString *) crittercismAppId;

- (NSString *) pushNotificationApplicationKey;			// This is the UrbanAirship key and secret
- (NSString *) pushNotificationApplicationSecret;		//

- (NSString *) facebookAPIKey;							// Enter the API key for this Facebook Connect app
- (NSString *) facebookAPISecret;						// Enter the API secret for this Facebook Connect app
- (NSString *) facebookPostIcon;						// The URL to the icon to use for the Facebook post entry

- (NSString *) twitterCommentSignature;					// Change to match the venue name but with no spaces

- (NSString *) rageDigitalBaseURL;						// This is typically the same for all venueConnect products
- (NSString *) internetConnectionCheckURL;				// This is typically the same for all venueConnect products
- (NSString *) adImagesURL;								// This is typically the same for all venueConnect products
- (NSString *) uploadPostImageURL;						// This is typically the same for all venueConnect products
- (NSString *) appStoreURL;								// Change to match the published app URL
 
*/
@end
