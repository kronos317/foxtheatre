//
//  BoulderTheaterAppDelegate.m
//  Boulder Theater
//
//  Created by Keiran Flanigan on 11/4/09.
//  Copyright Rage Digital Inc. 2009. All rights reserved.
//

#import "BoulderTheaterAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "FlurryAPI.h"
#import	"VenueConnect.h"

@implementation BoulderTheaterAppDelegate

@synthesize window;
@synthesize blackBG;
@synthesize finishedInitLoad;
@synthesize deviceToken;
@synthesize deviceAlias;
@synthesize tabBarController;
@synthesize keyboardIsInUse;
@synthesize currentTextField;
@synthesize advert;
@synthesize advertFull;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	[FlurryAPI startSessionWithLocationServices:[[VenueConnect sharedVenueConnect] flurryAPIKey]];
	
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
	NSLog(@"Registering for push notifications...");    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | 
																		   UIRemoteNotificationTypeBadge | 
																		   UIRemoteNotificationTypeSound)];
	

	defaults = [NSUserDefaults standardUserDefaults];
	finishedInitLoad = [NSNumber numberWithInt:0];
	[self performSelectorInBackground:@selector(setupDefaults) withObject:nil];
	
	UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
	bg.frame = CGRectMake(0,0,320,480);
	[window addSubview:bg];
	[bg release];
	
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,40)];
	
	UIImageView *headerLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerBG.png"]];
	[headerView addSubview:headerLogo];
	[window addSubview:headerView];
	[headerLogo release];
	[headerView release];
	
	[window addSubview:tabBarController.view];

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *adImage = [NSString stringWithFormat:@"/%@",[defaults objectForKey:@"ad_image"]];
	NSString *adShortImage = [NSString stringWithFormat:@"/%@",[defaults objectForKey:@"ad_short_image"]];
	
	advert = [UIButton buttonWithType:UIButtonTypeCustom];
	advert.backgroundColor = [UIColor clearColor];
	advert.frame = CGRectMake(0,389,320,42);
	advert.clipsToBounds = YES;
	advert.contentMode = UIViewContentModeTop;
	advert.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adShortImage]] forState:UIControlStateNormal];
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adShortImage]] forState:UIControlStateSelected];
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adImage]] forState:UIControlStateDisabled];
	[advert addTarget:self action:@selector(toggleAdvert) forControlEvents:UIControlEventTouchUpInside];
	[window addSubview:advert];
	
	advertFull = [UIButton buttonWithType:UIButtonTypeCustom];
	advertFull.backgroundColor = [UIColor clearColor];
	advertFull.frame = CGRectMake(0,481,320,480);
	advertFull.clipsToBounds = YES;
	advertFull.contentMode = UIViewContentModeTop;
	advertFull.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
	advertFull.alpha = 0.0;
	[advertFull setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adImage]] forState:UIControlStateNormal];
	[advertFull setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adImage]] forState:UIControlStateSelected];
	[advertFull addTarget:self action:@selector(toggleAdvert) forControlEvents:UIControlEventTouchUpInside];
	[window addSubview:advertFull];
	
	keyboardIsInUse = 0;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil]; 
	
	splashView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
	splashView.frame = CGRectMake(0,0,320,480);
	[window addSubview:splashView];
	[splashView release];
	
	// Set up black background needed for contrast on splash/signup display
	blackBG = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,480)];
	blackBG.backgroundColor = [UIColor blackColor];
	blackBG.opaque = YES;
	blackBG.alpha = 0.0;

	signUpView = [[UIView alloc] initWithFrame:CGRectMake(10,260,300,180)];
	signUpView.alpha = 0.0;
	
	signUpName = [[UITextField alloc] initWithFrame:CGRectMake(0,37,300,31)];
	signUpName.delegate = self;
	signUpName.borderStyle = UITextBorderStyleRoundedRect;
	signUpName.keyboardAppearance = UIKeyboardAppearanceAlert;
	signUpName.keyboardType = UIKeyboardTypeDefault;
	signUpName.returnKeyType = UIReturnKeySend;
	signUpName.autocorrectionType = UITextAutocorrectionTypeNo;
	signUpName.autocapitalizationType = UITextAutocapitalizationTypeNone;
	signUpName.font = [UIFont boldSystemFontOfSize:14];
	signUpName.placeholder = @"Username (Required)";
	signUpName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,74,300,30)];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont systemFontOfSize:12];
	label.textColor = [UIColor whiteColor];
	label.numberOfLines = 2;
	label.text = [NSString stringWithFormat:@"Enter your email and phone number to recieve %@ updates",[[VenueConnect sharedVenueConnect] venueName]];
	
	signUpEmail = [[UITextField alloc] initWithFrame:CGRectMake(0,109,300,31)];
	signUpEmail.delegate = self;
	signUpEmail.borderStyle = UITextBorderStyleRoundedRect;
	signUpEmail.keyboardAppearance = UIKeyboardAppearanceAlert;
	signUpEmail.keyboardType = UIKeyboardTypeEmailAddress;
	signUpEmail.returnKeyType = UIReturnKeySend;
	signUpEmail.autocorrectionType = UITextAutocorrectionTypeNo;
	signUpEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
	signUpEmail.font = [UIFont boldSystemFontOfSize:14];
	signUpEmail.placeholder = @"Email Address (Optional)";
	signUpEmail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	
	signUpNumber = [[UITextField alloc] initWithFrame:CGRectMake(0,146,300,31)];
	signUpNumber.delegate = self;
	signUpNumber.borderStyle = UITextBorderStyleRoundedRect;
	signUpNumber.keyboardAppearance = UIKeyboardAppearanceAlert;
	signUpNumber.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	signUpNumber.returnKeyType = UIReturnKeySend;
	signUpNumber.font = [UIFont boldSystemFontOfSize:14];
	signUpNumber.placeholder = @"Phone Number (Optional)";
	signUpNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

	[signUpView addSubview:signUpEmail];
	[signUpView addSubview:signUpNumber];
	[signUpView addSubview:signUpName];
	[signUpView addSubview:label];
	[signUpEmail release];
	[signUpNumber release];
	[signUpName release];
	[label release];
	
	[window addSubview:signUpView];
	[signUpView release];
	
	[textFieldBar removeFromSuperview];
	[window addSubview:textFieldBar];
	
	if([[defaults objectForKey:@"signedup"] isEqualToString:@"1"]) {
		[self hideSplashView];
	} else {
		[self showSignUpForm];
	}
}

- (void)toggleAdvert {
	
	
	if(advertFull.alpha == 0.0)
	{
		advertFull.alpha = 1.0;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		advertFull.frame = CGRectMake(0,0,320,480);
		[UIView commitAnimations];	
	}
	else {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDidStopSelector:@selector(changeAdvertImage)];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		advertFull.frame = CGRectMake(0,481,320,480);
		[UIView commitAnimations];	
	}

/*	
	if(advert.frame.origin.y == 389) {
		UIImage *image = [advert imageForState:UIControlStateDisabled];
		[advert setImage:image forState:UIControlStateNormal];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		advert.frame = CGRectMake(0,0,320,480);
		[UIView commitAnimations];
	} else {		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDidStopSelector:@selector(changeAdvertImage)];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		//advert.frame = CGRectMake(0,481,320,480);
		advert.alpha = 0.5;
		[UIView commitAnimations];

		 //  Comment out
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:2.0];
		[UIView setAnimationDidStopSelector:@selector(changeAdvertImage)];
		[UIView setAnimationDelegate:self];
		CGAffineTransform t = CGAffineTransformMakeScale(1,1);
		advert.transform = CGAffineTransformTranslate (t,0,389);
		advert.alpha = 1.0f;
		[UIView commitAnimations];
		//
	}
 */
}

- (void)changeAdvertImage {
	
	advertFull.alpha = 0.0;
	/*
	UIImage *image = [advert imageForState:UIControlStateSelected];
	[advert setImage:image forState:UIControlStateNormal];
	advert.alpha = 0.0;
	advert.frame = CGRectMake(0,389,320,42);

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	advert.alpha = 1.0;
	//advert.frame = CGRectMake(0,389,320,42);
	[advert setImage:image forState:UIControlStateNormal];
	[UIView commitAnimations];
	*/
}

- (void)refreshAd {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *adImage = [NSString stringWithFormat:@"/%@",[defaults objectForKey:@"ad_image"]];
	NSString *adShortImage = [NSString stringWithFormat:@"/%@",[defaults objectForKey:@"ad_short_image"]];
	/*
	if(advert.frame.origin.y == 389) {
		[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adShortImage]] forState:UIControlStateNormal];
	} else {
		[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adImage]] forState:UIControlStateNormal];
	}
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adShortImage]] forState:UIControlStateSelected];
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adImage]] forState:UIControlStateDisabled];
	*/
	
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adShortImage]] forState:UIControlStateNormal];
	[advertFull setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adImage]] forState:UIControlStateNormal];
	
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adShortImage]] forState:UIControlStateSelected];
	[advertFull setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:adImage]] forState:UIControlStateDisabled];	
	
	[advert setNeedsDisplay];
	[advertFull setNeedsDisplay];
}

- (void)downloadAdImages {
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		NSString *adImage = [NSString stringWithFormat:@"/%@",[defaults objectForKey:@"ad_image"]];

		//if(![[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingString:adImage]]) {
			NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[VenueConnect sharedVenueConnect] adImagesURL], [defaults objectForKey:@"ad_image"]]];
			NSData *data = [NSData dataWithContentsOfURL:myURL];
			if(!data) {
				adImage = nil;
			} else {
				[data writeToFile:[documentsDirectory stringByAppendingString:adImage] atomically:YES];
			}
		//}
		
		NSString *adShortImage = [NSString stringWithFormat:@"/%@",[defaults objectForKey:@"ad_short_image"]];
		
		//if(![[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingString:adShortImage]]) {
			myURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[VenueConnect sharedVenueConnect] adImagesURL],[defaults objectForKey:@"ad_short_image"]]];
			data = [NSData dataWithContentsOfURL:myURL];
			if(!data) {
				adShortImage = nil;
			} else {
				[data writeToFile:[documentsDirectory stringByAppendingString:adShortImage] atomically:YES];
			}
		//}
		
		[self performSelectorOnMainThread:@selector(refreshAd) withObject:nil waitUntilDone:NO];
		
	}
}


#pragma mark -
#pragma mark Push

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)_deviceToken { 
	// Get a hex string from the device token with no spaces or < >
	
	self.deviceToken = [[[[_deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:self.deviceToken delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert setTag:1];
	[alert show];
	[alert release];
	*/
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	
    self.deviceAlias = [userDefaults stringForKey: @"_UADeviceAliasKey"];
	
	NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
	NSString *UAServer = @"https://go.urbanairship.com";
	NSString *urlString = [NSString stringWithFormat:@"%@%@%@/", UAServer, @"/api/device_tokens/", self.deviceToken];
	NSURL *url = [NSURL URLWithString:  urlString];
	ASIHTTPRequest *request = [[[ASIHTTPRequest alloc] initWithURL:url] autorelease];
	request.requestMethod = @"PUT";
	
	// Send along our device alias as the JSON encoded request body
	if(self.deviceAlias != nil && [self.deviceAlias length] > 0) {
		[request addRequestHeader: @"Content-Type" value: @"application/json"];
		[request appendPostData:[[NSString stringWithFormat: @"{\"alias\": \"%@\"}", self.deviceAlias] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	// Authenticate to the server
	request.username = [[VenueConnect sharedVenueConnect] pushNotificationApplicationKey];
	request.password = [[VenueConnect sharedVenueConnect] pushNotificationApplicationSecret];
	
	[request setDelegate:self];
	[queue addOperation:request];
	
	NSLog(@"Device Token: %@", self.deviceToken);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
	
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[defaults setObject:@"YES" forKey:@"openToFavorites"];
}


#pragma mark -
#pragma mark ASI Requests

- (void)requestFinished:(ASIHTTPRequest *)request {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setValue:self.deviceToken forKey: @"_UALastDeviceToken"];
	[userDefaults setValue:self.deviceAlias forKey: @"_UALastAlias"];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
	NSError *error = [request error];
	NSLog(@"ERROR: NSError query result: %@", error);
}


#pragma mark -


- (void)keyboardWillShow {
	if(textFieldBar.frame.origin.y == 480 && [currentTextField isKindOfClass:[UITextField class]]) {		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		textFieldBar.frame = CGRectMake(0,231,320,34);
		[UIView commitAnimations];
	}
}

- (void)keyboardWillHide {
	if(keyboardIsInUse == 0) {
		if(textFieldBar.frame.origin.y == 231) {

			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.2];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			textFieldBar.frame = CGRectMake(0,480,320,34);
			[UIView commitAnimations];
		}
	}
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	keyboardIsInUse = 1;
	currentTextField = textField;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	signUpView.frame = CGRectMake(10,60,300,180);
	[UIView commitAnimations];
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	keyboardIsInUse = 0;
	currentTextField = nil;
	[textField resignFirstResponder];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	signUpView.frame = CGRectMake(10,260,300,180);
	[UIView commitAnimations];
	
	[self signUpAction];
	
	return YES;
}

- (IBAction)textFieldPreviousAction {
	UIView *parent = [currentTextField superview];
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	NSInteger index = -1;
	
	for(UIView *view in [parent subviews]) {
		if([view isKindOfClass:[UITextField class]]) {
			[tempArray addObject:view];
			if(view == currentTextField) {
				index = [tempArray count] - 1;
			}
		}
	}
	
	if(index == 0) {
		[[tempArray objectAtIndex:([tempArray count] - 1)] becomeFirstResponder];
	} else {
		[[tempArray objectAtIndex:(index - 1)] becomeFirstResponder];
	}
	
	[tempArray release];
}

- (IBAction)textFieldNextAction {
	UIView *parent = [currentTextField superview];
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	NSInteger index = -1;
	
	for(UIView *view in [parent subviews]) {
		if([view isKindOfClass:[UITextField class]]) {
			[tempArray addObject:view];
			if(view == currentTextField) {
				index = [tempArray count] - 1;
			}
		}
	}
	
	if(index == [tempArray count] - 1) {
		[[tempArray objectAtIndex:0] becomeFirstResponder];
	} else {
		[[tempArray objectAtIndex:(index + 1)] becomeFirstResponder];
	}
	
	[tempArray release];
}

- (IBAction)textFieldDoneAction:(id)sender {
	keyboardIsInUse = 0;
	[currentTextField resignFirstResponder];
	currentTextField = nil;
	
	if(signUpView.frame.origin.y == 80) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		splashView.alpha = 1.0;
		signUpView.frame = CGRectMake(10,260,300,180);
		[UIView commitAnimations];
	}
}

- (void)hideSplashView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationDelay:0.1];
	[UIView setAnimationDidStopSelector:@selector(killSplashView)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	splashView.alpha = 0.0;
	signUpView.alpha = 0.0;
	[UIView commitAnimations];
}

- (void)showSignUpForm {

	[splashView addSubview:blackBG];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	//[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDelegate:self];
	signUpView.alpha = 1.0;
	blackBG.alpha = 0.5;

	[UIView commitAnimations];
}


- (void)killSplashView {
	[splashView removeFromSuperview];
	[signUpView removeFromSuperview];
}

- (void)signUpAction {
	if([signUpName.text isEqualToString:@""] || signUpName.text == NULL) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please specify a username for yourself." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert setTag:1];
		[alert show];
		[alert release];
	} else {
		[defaults setValue:@"1" forKey:@"signedup"];
		[defaults setValue:signUpEmail.text forKey:@"email"];
		[defaults setValue:signUpNumber.text forKey:@"phone"];
		[defaults setValue:signUpName.text forKey:@"username"];
		
		[self hideSplashView];
		
		if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
			[self performSelectorInBackground:@selector(postSignup) withObject:nil];
		}
	}
}

- (void)showHeader {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	headerView.alpha = 1.0;
	advert.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)hideHeader {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	headerView.alpha = 0.0;
	advert.alpha = 0.0;
	[UIView commitAnimations];
}


- (void)postSignup {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *urlString = [NSString stringWithFormat:@"%@&action=add&device=%@&name=%@&email=%@&phone=%@",[[VenueConnect sharedVenueConnect] appServerUserURL],[[UIDevice currentDevice] uniqueIdentifier],[self getEncodeString:[defaults objectForKey:@"name"]],[self getEncodeString:[defaults objectForKey:@"email"]],[self getEncodeString:[defaults objectForKey:@"phone"]]];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	[pool release];
}

- (NSString *)getEncodeString:(NSString *)string {
	return [[[string stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"] stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
}

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)setupDefaults {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	//GET FEED LOCATIONS
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[VenueConnect sharedVenueConnect] appServerFeedURL]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
		NSData *urlData;
		NSURLResponse *response;
		NSError *error;
		urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
		NSString *returnString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
		jsonParser = [[SBJSON alloc] init];
		NSDictionary *info = [jsonParser objectWithString:returnString error:&error];
		[jsonParser release];
		[returnString release];
		
		if([info count] > 0) {
			[defaults setObject:[info objectForKey:@"blog_feed"] forKey:@"shows_feed"];		// This needs to be changed so that this is the event feed here and in the server UI
			[defaults setObject:[info objectForKey:@"twitter_feed"] forKey:@"twitter_feed"];
			[defaults setObject:[info objectForKey:@"video_feed"] forKey:@"facebook_feed"];  // This name needs to be changed in the server UI
			
			[defaults setObject:[info objectForKey:@"ad_image"] forKey:@"ad_image"];
			[defaults setObject:[info objectForKey:@"ad_short_image"] forKey:@"ad_short_image"];
			
			[self downloadAdImages];
		}
	} else {
		if(![defaults objectForKey:@"shows_feed"]) {
			[defaults setObject:[[VenueConnect sharedVenueConnect] defaultJSONCalendarFeedURL] forKey:@"shows_feed"];
			[defaults setObject:[[VenueConnect sharedVenueConnect] defaultTwitterFeedURL] forKey:@"twitter_feed"];
			[defaults setObject:[[VenueConnect sharedVenueConnect] defaultFacebookFeedURL] forKey:@"facebook_feed"];
		}
	}
	
	finishedInitLoad = [NSNumber numberWithInt:1];
			 
	[pool release];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [FlurryAPI setSessionReportsOnCloseEnabled:true];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

