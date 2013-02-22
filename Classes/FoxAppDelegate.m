//
//  FoxAppDelegate.m
//  Fox
//
//  Created by Keiran Flanigan on 11/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FoxAppDelegate.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "Beacon.h"

#define kApplicationKey @"Mf40hcHsTyOzcNmVlfxSVw"
#define kApplicationSecret @"foYs8e2oTpeAg60ZtUFvoQ"

@implementation FoxAppDelegate

@synthesize window;
@synthesize finishedInitLoad;
@synthesize deviceToken;
@synthesize deviceAlias;
@synthesize tabBarController;
@synthesize keyboardIsInUse;
@synthesize currentTextField;
@synthesize advert;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[Beacon initAndStartBeaconWithApplicationCode:@"261b7a820080816f020402a0b1074463" useCoreLocation:NO useOnlyWiFi:NO];
	
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
	NSLog(@"Registering for push notifications...");    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	

	defaults = [NSUserDefaults standardUserDefaults];
	finishedInitLoad = [NSNumber numberWithInt:0];
	[self performSelectorInBackground:@selector(setupDefaults) withObject:nil];
	
	UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
	bg.frame = CGRectMake(0,0,320,480);
	[window addSubview:bg];
	[bg release];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,40)];
	UIImageView *headerBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerBG.png"]];
	[headerView addSubview:headerBG];
	[window addSubview:headerView];
	[headerBG release];
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
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingFormat:adShortImage]] forState:UIControlStateNormal];
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingFormat:adShortImage]] forState:UIControlStateSelected];
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingFormat:adImage]] forState:UIControlStateDisabled];
	[advert addTarget:self action:@selector(toggleAdvert) forControlEvents:UIControlEventTouchUpInside];
	[window addSubview:advert];
	
	keyboardIsInUse = 0;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil]; 
	
	splashView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
	splashView.frame = CGRectMake(0,0,320,480);
	[window addSubview:splashView];
	[splashView release];
	
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
	label.text = @"Enter your email and phone number to recieve Fox Theater updates";
	
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
		advert.frame = CGRectMake(0,389,320,42);
		[UIView commitAnimations];
	}
}

- (void)changeAdvertImage {
	UIImage *image = [advert imageForState:UIControlStateSelected];
	
	[advert setImage:image forState:UIControlStateNormal];
}

- (void)refreshAd {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *adImage = [NSString stringWithFormat:@"/%@",[defaults objectForKey:@"ad_image"]];
	NSString *adShortImage = [NSString stringWithFormat:@"/%@",[defaults objectForKey:@"ad_short_image"]];
	
	if(advert.frame.origin.y == 389) {
		[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingFormat:adShortImage]] forState:UIControlStateNormal];
	} else {
		[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingFormat:adImage]] forState:UIControlStateNormal];
	}
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingFormat:adShortImage]] forState:UIControlStateSelected];
	[advert setImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingFormat:adImage]] forState:UIControlStateDisabled];
	
	[advert setNeedsDisplay];
}

- (void)downloadAdImages {
	if([self isConnectedToInternet]) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		
		NSString *adImage = [NSString stringWithFormat:@"/%@",[defaults objectForKey:@"ad_image"]];
		
		if(![[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingFormat:adImage]]) {
			NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://ragedigi.com/apps/images/ads/%@",[defaults objectForKey:@"ad_image"]]];
			NSData *data = [NSData dataWithContentsOfURL:myURL];
			if(!data) {
				adImage = nil;
			} else {
				[data writeToFile:[documentsDirectory stringByAppendingFormat:adImage] atomically:YES];
			}
		}
		
		NSString *adShortImage = [NSString stringWithFormat:@"/%@",[defaults objectForKey:@"ad_short_image"]];
		
		if(![[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingFormat:adShortImage]]) {
			NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://ragedigi.com/apps/images/ads/%@",[defaults objectForKey:@"ad_short_image"]]];
			NSData *data = [NSData dataWithContentsOfURL:myURL];
			if(!data) {
				adShortImage = nil;
			} else {
				[data writeToFile:[documentsDirectory stringByAppendingFormat:adShortImage] atomically:YES];
			}
		}
		
		[self performSelectorOnMainThread:@selector(refreshAd) withObject:nil waitUntilDone:NO];
		
	}
}


#pragma mark -
#pragma mark Push

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)_deviceToken { 
	// Get a hex string from the device token with no spaces or < >
	self.deviceToken = [[[[_deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString: @" " withString: @""];
	
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
	request.username = kApplicationKey;
	request.password = kApplicationSecret;
	
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
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.6];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	signUpView.alpha = 1.0;
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
		[defaults setValue:signUpName.text forKey:@"name"];
		[self hideSplashView];
		
		if([self isConnectedToInternet]) {
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
	
	NSString *urlString = [NSString stringWithFormat:@"http://www.ragedigitalinc.com/apps/user.php?salt=ng35DGnste3&app_name=Fox&action=add&device=%@&name=%@&email=%@&phone=%@",[[UIDevice currentDevice] uniqueIdentifier],[self getEncodeString:[defaults objectForKey:@"name"]],[self getEncodeString:[defaults objectForKey:@"email"]],[self getEncodeString:[defaults objectForKey:@"phone"]]];
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
	if([self isConnectedToInternet]) {
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ragedigitalinc.com/apps/feeds.php?salt=ng35DGnste3&app_name=Fox"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
		NSData *urlData;
		NSURLResponse *response;
		NSError *error;
		urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
		NSString *returnString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
		jsonParser = [[SBJSON alloc] init];
		NSDictionary *info = [jsonParser objectWithString:returnString error:&error];
		[jsonParser release];
		
		if([info count] > 0) {
			[defaults setObject:[info objectForKey:@"blog_feed"] forKey:@"shows_feed"];
			[defaults setObject:[info objectForKey:@"photo_feed"] forKey:@"gallery_feed"];
			[defaults setObject:[info objectForKey:@"extra_feed"] forKey:@"set_string"];
			[defaults setObject:[info objectForKey:@"ad_image"] forKey:@"ad_image"];
			[defaults setObject:[info objectForKey:@"ad_short_image"] forKey:@"ad_short_image"];
			
			[self downloadAdImages];
		}
	} else {
		if(![defaults objectForKey:@"shows_feed"]) {
			[defaults setObject:@"http://www.foxtheatre.com/json_upcomingshows.aspx" forKey:@"shows_feed"];
			[defaults setObject:@"http://api.flickr.com/services/rest/?method=flickr.photosets.getList&user_id=33072116%40N03&api_key=7529a690edd1d7593aea7d7fa0c174b4&format=json" forKey:@"gallery_feed"];
			[defaults setObject:@"http://api.flickr.com/services/feeds/photoset.gne?set=%@&nsid=33072116%40N03&lang=en-us&format=json" forKey:@"set_string"];
		}
	}
	
	finishedInitLoad = [NSNumber numberWithInt:1];
			 
	[pool release];
}

- (BOOL)isConnectedToInternet {
	return ([NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com/"] encoding:NSUTF8StringEncoding error:nil]!=NULL)?YES:NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [Beacon endBeacon];
}

- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

