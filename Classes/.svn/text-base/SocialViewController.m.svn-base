//
//  SocialViewController.m
//  BoulderTheater
//
//  Created by Mark Ferguson on 4/25/10.
//  Copyright 2010 Rage Digital Inc. All rights reserved.
//

#import "SocialViewController.h"
#import "JSON.h"
#import "VenueConnect.h"


@implementation SocialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	
	stopDownloadingImages = 0;
	
	twitterString = @"<style>body{background:transparent;margin:0;padding:0;color:#454545;font-size:10pt;font-family:Helvetica;width:235px;height:auto;} a{color:#f77200;} .username{font-weight:bold;color:#f77200;text-decoration:none;}</style><body><a href='http://www.twitter.com/%@' class='username'>@%@</a> %@</body>";
	facebookString = @"<style>body{background:transparent;margin:0;padding:0;color:#454545;font-size:10pt;font-family:Helvetica;width:235px;height:auto;} a{color:#f77200;} .username{font-weight:bold;color:#f77200;text-decoration:none;}</style><body><span class='username'>%@</span><br />%@</body>";
	
	tweets = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tweets"] retain];
	facebookEntries = [[[NSUserDefaults standardUserDefaults] objectForKey:@"facebookEntries"] retain];	
	
	reloadButton.userInteractionEnabled = NO;
	
	twitterView.frame = CGRectMake(0,0,320,367);
	tweetsHolder.frame = CGRectMake(0,0,320,367);
	[self showPopupLoader:@"Loading New Tweets..."];

	facebookView.frame = CGRectMake(0,0,320,367);
	facebookView.transform = CGAffineTransformMakeScale(0.6,0.6);
	facebookView.alpha = 0.0;
	
	externalWebView.frame = CGRectMake(0,411,320,323);
	
	for(UIView *v in [tweetsHolder subviews]) {
		[v removeFromSuperview];
	}
	
	for(UIView *v in [facebookHolder subviews]) {
		[v removeFromSuperview];
	}

	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		twitterView.alpha = 0.6;		
		[self performSelectorInBackground:@selector(loadNewData) withObject:nil];
	} else {
		[self hidePopupLoader];
		if([tweets count] > 0) {
			[self loadTwitterView];
		} else {
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,150,300,20)];
			label.backgroundColor = [UIColor clearColor];
			label.textColor = [UIColor darkGrayColor];
			label.numberOfLines = 0;
			label.font = [UIFont boldSystemFontOfSize:13];
			label.textAlignment = UITextAlignmentCenter;
			label.text = @"You must be connected to the internet to view the latest tweets.";
			[label sizeToFit];
			[tweetsHolder addSubview:label];
			[label release];
		}
		
		if([facebookEntries count] > 0) {
			[self loadFacebookView];
		} else {
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,150,300,20)];
			label.backgroundColor = [UIColor clearColor];
			label.textColor = [UIColor darkGrayColor];
			label.numberOfLines = 0;
			label.font = [UIFont boldSystemFontOfSize:13];
			label.textAlignment = UITextAlignmentCenter;
			label.text = @"You must be connected to the internet to view the latest news.";
			[label sizeToFit];
			[facebookHolder addSubview:label];
			[label release];
		}
	}
}

- (void)showPopupLoader:(NSString *)text {
	popupLoaderLabel.text = text;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	popupLoader.frame = CGRectMake(80,370,160,30);
	[UIView commitAnimations];
}

- (void)hidePopupLoader {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	popupLoader.frame = CGRectMake(80,411,160,30);
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark Nav Actions

- (IBAction)switchAction:(id)sender {

	if((UIButton *) sender == twitterButton) {
		// Twitter button was pressed
		[twitterButton setBackgroundImage:[UIImage imageNamed:@"toggleLeft_on.png"] forState:UIControlStateNormal];
		[facebookButton setBackgroundImage:[UIImage imageNamed:@"toggleRight.png"] forState:UIControlStateNormal];
		[self twitterAction];
	}
	else {
		// Facebook button was pressed
		[twitterButton setBackgroundImage:[UIImage imageNamed:@"toggleLeft.png"] forState:UIControlStateNormal];
		[facebookButton setBackgroundImage:[UIImage imageNamed:@"toggleRight_on.png"] forState:UIControlStateNormal];
		[self facebookAction];
	}
}

- (void)twitterAction {
	if(twitterView.alpha == 0.0) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDidStopSelector:@selector(resetView)];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		facebookView.transform = CGAffineTransformMakeScale(1.4,1.4);
		facebookView.alpha = 0.0;
		twitterView.transform = CGAffineTransformMakeScale(1.0,1.0);
		twitterView.alpha = 1.0;
		[UIView commitAnimations];
	}
}

- (void)facebookAction {
	if(facebookView.alpha == 0.0) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDidStopSelector:@selector(resetView)];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		twitterView.transform = CGAffineTransformMakeScale(1.4,1.4);
		twitterView.alpha = 0.0;
		facebookView.transform = CGAffineTransformMakeScale(1.0,1.0);
		facebookView.alpha = 1.0;
		[UIView commitAnimations];
	}
}

- (void)resetView {
	if(twitterView.alpha == 1.0) {
		facebookView.transform = CGAffineTransformMakeScale(0.6,0.6);
	} else if(facebookView.alpha == 1.0) {
		twitterView.transform = CGAffineTransformMakeScale(0.6,0.6);
	}
}


#pragma mark -
#pragma mark Display Views

- (void)loadTwitterView {
	for(UIView *v in [tweetsHolder subviews]) {
		if([v isKindOfClass:[UIView class]] && v.frame.size.width == 320) {
			[v removeFromSuperview];
		}
	}
	[twitterView scrollRectToVisible:CGRectMake(0,0,10,10) animated:YES];
	tweetsHolder.frame = CGRectMake(0,0,320,367);
	twitterView.contentSize = CGSizeMake(320,367);
	
	int y = 0;
	int c = 0;
	for(NSDictionary *d in tweets) {
		UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0,y,320,90)];
		item.backgroundColor = [UIColor clearColor];
		item.tag = c;
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *clubImage = [NSString stringWithFormat:@"/%@",[[d objectForKey:@"user"] objectForKey:@"id"]];

		UIImageView *avatar = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:clubImage]]];
		avatar.frame = CGRectMake(10,10,52,52);
		avatar.contentMode = UIViewContentModeScaleToFill;
		avatar.clipsToBounds = YES;
		avatar.tag = 1;
		[item addSubview:avatar];
		[avatar release];
		
		NSString *text = [NSString stringWithFormat:@"@%@ %@",[[d objectForKey:@"user"] objectForKey:@"screen_name"],[d objectForKey:@"text"]];
		CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(235,150) lineBreakMode:UILineBreakModeWordWrap];
		
		UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(72,10,235,size.height)];
		webView.tag = -1;
		webView.delegate = self;
		webView.dataDetectorTypes = UIDataDetectorTypeAll;
		webView.backgroundColor = [UIColor clearColor];
		webView.opaque = NO;
		
		[webView loadHTMLString:[NSString stringWithFormat:twitterString,[[d objectForKey:@"user"] objectForKey:@"screen_name"],[[d objectForKey:@"user"] objectForKey:@"screen_name"],[d objectForKey:@"text"]] baseURL:nil];

		[item addSubview:webView];
		[webView release];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(72,size.height+12,235,15)];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:10];
		label.textColor = [UIColor darkGrayColor];
		//NSLog(@"time=%@", [d objectForKey:@"created_at"]);
		
		NSDateFormatter* df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"EEE MMM d H:mm:ss Z yyyy"];
		
		NSDate* createDate = [df dateFromString:[d objectForKey:@"created_at"]];
		[df release];
		
		label.text = [NSString stringWithFormat:@"posted %@ from %@",[self getTimeSince:createDate],[self flattenHTML:[d objectForKey:@"source"]]];

		[item addSubview:label];
		[label release];
		
		if(size.height < 37) {
			size.height = 37;
		}
		item.frame = CGRectMake(0,y,320,size.height + 35);
		
		UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rowSeparator.png"]];
		bg.frame = CGRectMake(0,size.height + 32,320,3);
		[item addSubview:bg];
		[bg release];
		
		[tweetsHolder addSubview:item];
		[item release];
		
		y += size.height + 35;
		c++;
	}
	
	loader.hidden = YES;
	twitterView.alpha = 1.0;
	
	tweetsHolder.frame = CGRectMake(0,0,320,y);
	twitterView.contentSize = CGSizeMake(320,y);
	
	stopDownloadingImages = 0;
	[self performSelectorInBackground:@selector(loadTwitterImages) withObject:nil];
	
	reloadButton.userInteractionEnabled = YES;
}

- (void)loadFacebookView {
	for(UIView *v in [facebookHolder subviews]) {
		if([v isKindOfClass:[UIView class]] && v.frame.size.width == 320) {
			[v removeFromSuperview];
		}
	}
	[facebookView scrollRectToVisible:CGRectMake(0,0,10,10) animated:YES];
	facebookHolder.frame = CGRectMake(0,0,320,367);
	facebookView.contentSize = CGSizeMake(320,367);
	
	int y = 0;
	int c = 0;
	
	for(NSDictionary *d in facebookEntries) {
		UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0,y,320,90)];
		item.backgroundColor = [UIColor clearColor];
		item.tag = c;
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *clubImage = [NSString stringWithFormat:@"/%@",[d valueForKey:@"icon"]];
		
		UIImageView *avatar = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:clubImage]]];
		avatar.frame = CGRectMake(10,10,52,52);
		avatar.contentMode = UIViewContentModeScaleToFill;
		avatar.clipsToBounds = YES;
		avatar.tag = 1;
		[item addSubview:avatar];
		[avatar release];
		
		NSString *text = [NSString stringWithFormat:@"%@ %@",[[d objectForKey:@"from"] objectForKey:@"name"],[d objectForKey:@"message"]];
		CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(235,150) lineBreakMode:UILineBreakModeWordWrap];
		
		UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(72,10,235,size.height)];
		webView.tag = -1;
		webView.delegate = self;
		webView.dataDetectorTypes = UIDataDetectorTypeAll;
		webView.backgroundColor = [UIColor clearColor];
		webView.opaque = NO;
		
		[webView loadHTMLString:[NSString stringWithFormat:facebookString,[[d objectForKey:@"from"] valueForKey:@"name"],[d valueForKey:@"message"]] baseURL:nil];
		
		[item addSubview:webView];
		[webView release];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(72,size.height+12,235,15)];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:10];
		label.textColor = [UIColor darkGrayColor];
		
		//NSLog(@"FB created_time=%@", [d objectForKey:@"created_time"]);
		
		NSDateFormatter* df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd'T'H:mm:ssZ"];
		
		NSDate* createDate = [df dateFromString:[d objectForKey:@"created_time"]];
		
		[df release];
		
		
		label.text = [NSString stringWithFormat:@"%@",[self getTimeSince:createDate]];
		[item addSubview:label];
		[label release];
		
		if(size.height < 37) {
			size.height = 37;
		}
		item.frame = CGRectMake(0,y,320,size.height + 35);
		
		UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rowSeparator.png"]];
		bg.frame = CGRectMake(0,size.height + 32,320,3);
		[item addSubview:bg];
		[bg release];
		
		[facebookHolder addSubview:item];
		[item release];
		
		y += size.height + 35;
		c++;		
	}
	
	loader.hidden = YES;
	
	facebookHolder.frame = CGRectMake(0,0,320,y);
	facebookView.contentSize = CGSizeMake(320,y);
	
	stopDownloadingImages = 0;
	[self performSelectorInBackground:@selector(loadFacebookImages) withObject:nil];
	
	reloadButton.userInteractionEnabled = YES;
}

#pragma mark -
#pragma mark Web View

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if(webView.tag == -1) {
		if([[request.URL absoluteString] isEqualToString:@"about:blank"]) {
			return YES;
		} else {
			if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
				[self showWebView:[request.URL absoluteString]];
			} else {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"You must be connected to the internet to follow links." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alertView show];
				[alertView release];
			}
			return NO;
		}
	} else {
		return YES;
	}
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	if(webView == externalWebView) {
		webLoader.hidden = NO;
		[webLoader startAnimating];
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	if(webView == externalWebView) {
		webLoader.hidden = YES;
	} else if([[webView superview] tag] == -2) {
		[webView sizeToFit];
		
		UIView *item = [webView superview];
		for(UIImageView *i in [item subviews]) {
			if([i isKindOfClass:[UIImageView class]]) {
				i.frame = CGRectMake(0,webView.frame.size.height + 20,320,3);
			}
		}
		item.frame = CGRectMake(0,item.frame.size.height,320,webView.frame.size.height + 23);
		
		float y = 0.0;
		int index = [[facebookHolder subviews] indexOfObject:item];
		for(UIView *v in [facebookHolder subviews]) {
			if([[facebookHolder subviews] indexOfObject:v] == index) {
				v.frame = CGRectMake(0,y,320,v.frame.size.height);
				break;
			} else {
				v.frame = CGRectMake(0,y,320,v.frame.size.height);
				y += v.frame.size.height;
			}
		}
		
		facebookHolder.frame = CGRectMake(0,0,320,y);
		facebookView.contentSize = CGSizeMake(320,y);
	}
}

- (void)showWebView:(NSString *)path {
	[externalWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	externalWebView.frame = CGRectMake(0,48,320,362);
	//webControls.frame = CGRectMake(0,44,320,44);
	[UIView commitAnimations];
	[self showWebButtons];
}

- (IBAction)hideWebView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	externalWebView.frame = CGRectMake(0,411,320,328);
	//webControls.frame = CGRectMake(0,-44,320,44);
	[UIView commitAnimations];
	[self hideWebButtons];	
}


#pragma mark -
#pragma mark Nav Actions

- (void)showWebButtons {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	backButton.alpha = 1.0;
	webBackButton.alpha = 1.0;
	webForwardButton.alpha = 1.0;
	webLoader.alpha = 1.0;
	switchHolder.alpha = 0.0;	
	[UIView commitAnimations];
}

- (void)hideWebButtons {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	backButton.alpha = 0.0;	
	webBackButton.alpha = 0.0;
	webForwardButton.alpha = 0.0;
	webLoader.alpha = 0.0;
	switchHolder.alpha = 1.0;
	[UIView commitAnimations];
}

- (IBAction)backAction {
	[self hideWebButtons];
	[self hideWebView];
}



#pragma mark -
#pragma mark Data

- (void)loadNewData {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	stopDownloadingImages = 1;
	SBJSON *jsonParser = [[SBJSON alloc] init];
	
	//TWITTER
	NSLog(@"twitter_feed=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_feed"]);
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"twitter_feed"]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];

	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	NSString *returnString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];

	
	[tweets release];
	tweets = nil;
	tweets = [[jsonParser objectWithString:[returnString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""] error:NULL] retain];
	[returnString release];
	
	[[NSUserDefaults standardUserDefaults] setObject:tweets forKey:@"tweets"];
	[self performSelectorOnMainThread:@selector(loadTwitterView) withObject:nil waitUntilDone:NO];
	[self performSelectorOnMainThread:@selector(hidePopupLoader) withObject:nil waitUntilDone:NO];
	
	//Facebook
	NSLog(@"fb_feed=%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_feed"]);
	
	urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"facebook_feed"]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	
	returnString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
	[facebookEntries release];
	facebookEntries = nil;
	
	facebookEntries = [[[jsonParser objectWithString:[returnString stringByReplacingOccurrencesOfString:@"null" withString:@"\"\""] error:&error] retain] objectForKey:@"data"];	

	
	[[NSUserDefaults standardUserDefaults] setObject:facebookEntries forKey:@"facebookEntries"];
	[self performSelectorOnMainThread:@selector(loadFacebookView) withObject:nil waitUntilDone:NO];
	
	[returnString release];	
	[jsonParser release];
	
	[pool release];
}


#pragma mark -
#pragma mark Images

- (void)refreshImageForTwitterItem:(NSDictionary *)d {
	if(stopDownloadingImages == 0) {
		NSInteger index = [tweets indexOfObject:d];
		
		NSArray *subviews = [tweetsHolder subviews];
		UIView *item = [subviews objectAtIndex:index];
		
		for(UIImageView *i in [item subviews]) {
			if([i isKindOfClass:[UIImageView class]] && i.tag == 1) {
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				NSString *clubImage = [NSString stringWithFormat:@"/%@",[[d objectForKey:@"user"] objectForKey:@"id"]];
				
				i.image = [UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:clubImage]];
			}
		}
	}
}

- (void)loadTwitterImages {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		
		for(NSDictionary *d in tweets) {
			if(stopDownloadingImages == 0) {
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
				
				NSString *clubImage = [NSString stringWithFormat:@"/%@",[[d objectForKey:@"user"] objectForKey:@"id"]];
				
				if(![[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingString:clubImage]]) {
					NSURL *myURL = [NSURL URLWithString:[[d objectForKey:@"user"] objectForKey:@"profile_image_url"]];
					NSData *data = [NSData dataWithContentsOfURL:myURL];
					if(!data) {
						clubImage = nil;
					} else {
						[data writeToFile:[documentsDirectory stringByAppendingString:clubImage] atomically:YES];
					}
				}
				
				[self performSelectorOnMainThread:@selector(refreshImageForTwitterItem:) withObject:d waitUntilDone:NO];
			} else {
				break;
			}
		}
		
	}
	
	[pool release];
}

- (void)refreshImageForFacebookItem:(NSDictionary *)d {
	if(stopDownloadingImages == 0) {
		NSInteger index = [facebookEntries indexOfObject:d];
		
		NSArray *subviews = [facebookHolder subviews];
		UIView *item = [subviews objectAtIndex:index];
		
		for(UIImageView *i in [item subviews]) {
			if([i isKindOfClass:[UIImageView class]] && i.tag == 1) {
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];
//				NSString *clubImage = [NSString stringWithFormat:@"/%@",[d valueForKey:@"id"]];
					NSString *clubImage = [NSString stringWithFormat:@"/%@", [[d objectForKey:@"from"] objectForKey:@"id"]];				
				i.image = [UIImage imageWithContentsOfFile:[documentsDirectory stringByAppendingString:clubImage]];
			}
		}
	}
}

- (void)loadFacebookImages {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		
		for(NSDictionary *d in facebookEntries) {
			if(stopDownloadingImages == 0) {
				NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *documentsDirectory = [paths objectAtIndex:0];

				/*
				NSLog(@"pic=%@", [d objectForKey:@"picture"]);
				
				if([d valueForKey:@"picture"]) {
					NSString *clubImage = [NSString stringWithFormat:@"/%@",[d valueForKey:@"id"]];
					
					if(![[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingString:clubImage]]) {
						NSURL *myURL = [NSURL URLWithString:[d valueForKey:@"picture"]];

						NSData *data = [NSData dataWithContentsOfURL:myURL];
						if(!data) {
							clubImage = nil;
						} else {
							[data writeToFile:[documentsDirectory stringByAppendingString:clubImage] atomically:YES];
						}
					}
				
					[self performSelectorOnMainThread:@selector(refreshImageForFacebookItem:) withObject:d waitUntilDone:YES];
				}
				else {	// Get the person's profile pic to associate with the entry
				 
				*/
				
					// Always use the from picture to display with the entry
					NSString *fromID = [[d objectForKey:@"from"] objectForKey:@"id"];
					NSLog(@"from=%@", fromID);
					
					NSString *fromImage = [NSString stringWithFormat:@"/%@",fromID];
					
					if(![[NSFileManager defaultManager] fileExistsAtPath:[documentsDirectory stringByAppendingString:fromImage]]) {
						
						NSString *fbImage = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture",fromID];
						NSURL *myURL = [NSURL URLWithString:fbImage];
						
						NSData *data = [NSData dataWithContentsOfURL:myURL];
						if(!data) {
							fromImage = nil;
						} else {
							[data writeToFile:[documentsDirectory stringByAppendingString:fromImage] atomically:YES];
						}					
					}
					
					[self performSelectorOnMainThread:@selector(refreshImageForFacebookItem:) withObject:d waitUntilDone:YES];					
				//}
			}
			else {
				break;
			}
		}
		
	}
	
	[pool release];
}


#pragma mark -


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (NSString *)getTimeSince:(NSDate *)startDate {
	//ADJUST FOR LOCAL TIMEZONE
	NSInteger adjust = [[NSTimeZone localTimeZone] secondsFromGMT];
	startDate = [startDate addTimeInterval:18000+adjust];
	
	double time = [[NSDate date] timeIntervalSinceDate:startDate];
	NSString *returnString = @"";
	
	if(time <= 60){
		returnString = @"just now";
	}
	if(60 < time && time <= 3600){
		returnString = [NSString stringWithFormat:@"%.0f %@%@ ago",round(time/60),@"minute",((round(time/60) != 1)?@"s":@"")];
	}
	if(3600 < time && time <= 86400){
		returnString = [NSString stringWithFormat:@"%.0f %@%@ ago",round(time/3600),@"hour",((round(time/3600) != 1)?@"s":@"")];
	}
	if(86400 < time && time <= 604800){
		returnString = [NSString stringWithFormat:@"%.0f %@%@ ago",round(time/86400),@"day",((round(time/86400) != 1)?@"s":@"")];
	}
	if(604800 < time && time <= 2592000){
		returnString = [NSString stringWithFormat:@"%.0f %@%@ ago",round(time/604800),@"week",((round(time/604800) != 1)?@"s":@"")];
	}
	if(2592000 < time && time <= 29030400){
		returnString = [NSString stringWithFormat:@"%.0f %@%@ ago",round(time/2592000),@"month",((round(time/2592000) != 1)?@"s":@"")];
	}
	if(time > 29030400){
		returnString = @"more than a year ago";
	}
	
	return returnString;
}

- (NSString *)flattenHTML:(NSString *)html {
    NSScanner *theScanner;
    NSString *text = nil;
	
    theScanner = [NSScanner scannerWithString:html];
	
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
		
        [theScanner scanUpToString:@">" intoString:&text] ;
		
        html = [html stringByReplacingOccurrencesOfString:[ NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    
    return html;
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[tweets release];
	[facebookEntries release];
}


@end
