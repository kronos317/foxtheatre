//
//  WallViewController.m
//  BoulderTheater
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WallViewController.h"
#import "BoulderTheaterAppDelegate.h"
#import "FlurryAPI.h"
#import "FBConnect/FBConnect.h"
#import "MGTwitterEngine.h"
#import "JSON.h"
#import "VenueConnect.h"


@implementation WallViewController


- (void)viewDidLoad {
	appDelegate = (BoulderTheaterAppDelegate *)[[UIApplication sharedApplication] delegate];
	loggedIntoFB = 0;
	loggedIntoTwitter = 0;
	addingPost = 0;
	
	session = [[FBSession sessionForApplication:[[VenueConnect sharedVenueConnect] facebookAPIKey] secret:[[VenueConnect sharedVenueConnect] facebookAPISecret] delegate:self] retain];

	[session resume];
	
	alertView.frame = CGRectMake(0,-224,320,224);
	username.textColor = [UIColor colorWithRed:0.176 green:0.663 blue:0.882 alpha:1.0];
	comment.font = [UIFont systemFontOfSize:15];
	comment.textColor = [UIColor grayColor];
	
	postImage = nil;
	imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.allowsImageEditing = YES;
	imagePicker.delegate = self;
	
	twitterLoginView.frame = CGRectMake(6,50,308,214);
	twitterLoginView.alpha = 0.0;
	twitterLoginView.transform = CGAffineTransformMakeScale(0.7, 0.7);
	
	webView.backgroundColor = [UIColor clearColor];
	
	twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
	[twitterEngine setClientName:[[VenueConnect sharedVenueConnect] venueName] version:@"1.1" URL:[[VenueConnect sharedVenueConnect] venueURL] token:@""];
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet] && [[NSUserDefaults standardUserDefaults] objectForKey:@"tw_user"]) {
		[twitterEngine setUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"tw_user"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"tw_pass"]];
		twitterLoginCheck = [[twitterEngine checkUserCredentials] retain];
	}
	
	[self loadWall];
}


- (void)manualLoad {
	
}


- (void)loadWallString {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *wallString;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if([defaults objectForKey:@"username"]) {
		username.text = [defaults objectForKey:@"username"];
		username.userInteractionEnabled = NO;
		usernameBG.hidden = YES;
	}
	
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		NSString *url = [NSString stringWithFormat:@"%@&action=view", [[VenueConnect sharedVenueConnect] appServerWallURL]];
		
		NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
		NSData *urlData;
		NSURLResponse *response;
		NSError *error;
		urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
		
		NSString *returnString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
		wallString = [NSString stringWithFormat:@"%@",returnString];
		[returnString release];
		
		[defaults setObject:wallString forKey:@"wall"];
	}
	
	[self performSelectorOnMainThread:@selector(displayWall) withObject:nil waitUntilDone:NO];
	
	[pool release];
}

- (BOOL)wallNeedsLoading {
	if(!twitterEngine) {
		twitterEngine = [[MGTwitterEngine alloc] initWithDelegate:self];
		[twitterEngine setClientName:[[VenueConnect sharedVenueConnect] venueName] version:@"1.1" URL:[[VenueConnect sharedVenueConnect] venueURL] token:@""];
		if([[VenueConnect sharedVenueConnect] isConnectedToInternet] && [[NSUserDefaults standardUserDefaults] objectForKey:@"tw_user"]) {
			[twitterEngine setUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"tw_user"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"tw_pass"]];
			twitterLoginCheck = [[twitterEngine checkUserCredentials] retain];
		}
	}
	
	if(webView.request) {
		return FALSE;
	} else {
		return TRUE;
	}
}

- (void)loadWall {
	[self resetPost];
	
	[self performSelectorInBackground:@selector(loadWallString) withObject:nil];
}

- (IBAction)reloadWall {
	loader.hidden = NO;
	[loader startAnimating];
	[webView loadHTMLString:@"" baseURL:[NSURL URLWithString:[[VenueConnect sharedVenueConnect] rageDigitalBaseURL]]];
	
	[self performSelectorInBackground:@selector(loadWallString) withObject:nil];
}

- (void)displayWall {
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		NSString *wallString = [[NSUserDefaults standardUserDefaults] objectForKey:@"wall"];
		[webView loadHTMLString:wallString baseURL:nil];
	} else if([[NSUserDefaults standardUserDefaults] objectForKey:@"wall"]) {
		NSMutableString *wallString = [NSMutableString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"wall"]];
		NSRange index = [wallString rangeOfString:@"</style>"];
		
		NSString *newString = @"img{display:none;padding:0;margin:0;}";
		
		[wallString insertString:newString atIndex:index.location];
		
		[webView loadHTMLString:wallString baseURL:nil];
	} else {
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,210,300,20)];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor darkGrayColor];
		label.numberOfLines = 0;
		label.font = [UIFont boldSystemFontOfSize:13];
		label.textAlignment = UITextAlignmentCenter;
		label.text = @"You must be connected to the internet to view the newest wall posts.";
		[label sizeToFit];
		[self.view insertSubview:label belowSubview:webView];
		[label release];
	}
}

- (void)loadTempWallWithUsername:(NSString *)nameString andComment:(NSString *)commentString {
	NSMutableString *wallString = [NSMutableString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"wall"]];
	NSRange index = [wallString rangeOfString:@"<body>"];
	
	NSString *newString = [NSString stringWithFormat:@"<div class=\"item\"><span style=\"color:white;\"><img src=\"%@\" /><br />%@</span><br /><div style=\"color: white;margin-top:3px;font-size:8pt;\">Posted just now by <strong>%@</strong></div></div>",[[VenueConnect sharedVenueConnect] uploadPostImageURL], (([commentString isEqualToString:@"Comment"])?@"":commentString),nameString];
	
	[wallString insertString:newString atIndex:(index.location + index.length)];
	
	[webView loadHTMLString:wallString baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)wView {
	if(![[[wView.request URL] absoluteString] isEqualToString:[[VenueConnect sharedVenueConnect] rageDigitalBaseURL]]) {
		loader.hidden = YES;
	} else {
		loader.hidden = NO;
	}
}


- (IBAction)addPost {
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		addingPost = 1;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		alertView.frame = CGRectMake(0,40,320,224);
		[UIView commitAnimations];
		if([username.text isEqualToString:@""]) {
			[username becomeFirstResponder];
		} else {
			[comment becomeFirstResponder];
		}
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You must be connected to the internet to post to the wall." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (IBAction)cancelPost:(id)sender {
	addingPost = 0;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	if([sender isKindOfClass:[UIButton class]]) {
		[UIView setAnimationDidStopSelector:@selector(resetPost)];
	}
	[UIView setAnimationDelegate:self];	
	alertView.frame = CGRectMake(0,-224,320,224);
	[UIView commitAnimations];
	
	if([username isFirstResponder]) {
		[username resignFirstResponder];
	}
	if([comment isFirstResponder]) {
		[comment resignFirstResponder];
	}
}

- (void)resetPost {
	comment.text = @"Comment";
	comment.textColor = [UIColor grayColor];
	[photoButton setBackgroundImage:[UIImage imageNamed:@"alertPhotoButton.png"] forState:UIControlStateNormal];
	postImage = nil;
	loader.hidden = YES;
}

- (IBAction)addImage {
	if(![[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) {
		if([username isFirstResponder]) {
			[username resignFirstResponder];
		}
		if([comment isFirstResponder]) {
			[comment resignFirstResponder];
		}
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[appDelegate hideHeader];
		[self presentModalViewController:imagePicker animated:YES];
	} else {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Your Image Location..." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo Album",@"Camera",nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[actionSheet showFromTabBar:[[appDelegate tabBarController] tabBar]];
		[actionSheet release];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
	postImage = [img retain];
	[photoButton setBackgroundImage:img forState:UIControlStateNormal];
	[self dismissModalViewControllerAnimated:YES];
	[appDelegate showHeader];
	if([username.text isEqualToString:@""]) {
		[username becomeFirstResponder];
	} else {
		[comment becomeFirstResponder];
	}
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissModalViewControllerAnimated:YES];
	[appDelegate showHeader];
	if([username.text isEqualToString:@""]) {
		[username becomeFirstResponder];
	} else {
		[comment becomeFirstResponder];
	}
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(buttonIndex == 0) {
		if([username isFirstResponder]) {
			[username resignFirstResponder];
		}
		if([comment isFirstResponder]) {
			[comment resignFirstResponder];
		}
		imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		[appDelegate hideHeader];
		[self presentModalViewController:imagePicker animated:YES];
	} else if(buttonIndex == 1) {
		if([username isFirstResponder]) {
			[username resignFirstResponder];
		}
		if([comment isFirstResponder]) {
			[comment resignFirstResponder];
		}
		imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[appDelegate hideHeader];
		[self presentModalViewController:imagePicker animated:YES];
	}
}

- (IBAction)submitPost {
	if(postImage || (![comment.text isEqualToString:@""] && ![comment.text isEqualToString:@"Comment"])) {
		[self cancelPost:self];
		[self loadTempWallWithUsername:username.text andComment:comment.text];
		[self performSelectorInBackground:@selector(performPost:) withObject:[NSDictionary dictionaryWithObjectsAndKeys:username.text,@"username",comment.text,@"comment",nil]];
		[FlurryAPI logEvent:@"Wall Post"];
		
		if(facebookIcon.frame.origin.x == 29) {
			[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"postToFacebook"];
		} else {
			[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"postToFacebook"];
		}
		
		if(twitterIcon.frame.origin.x == 29) {
			[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"postToTwitter"];
		} else {
			[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"postToTwitter"];
		}
	}
}

- (void)performPost:(NSDictionary *)postInfo {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *usernameText = [postInfo objectForKey:@"username"];
	NSString *commentText = [postInfo objectForKey:@"comment"];
	[defaults setObject:usernameText forKey:@"username"];
	
	NSString *imageString;
	NSData *imageData = UIImageJPEGRepresentation(postImage,0.7);
	
	NSString *urlString = [NSString stringWithFormat:@"%@&action=add&name=%@&device=%@&comment=%@",[[VenueConnect sharedVenueConnect] appServerWallURL], [self getEncodeString:usernameText],[[UIDevice currentDevice] uniqueIdentifier],(([commentText isEqualToString:@"Comment"])?@"":[self getEncodeString:commentText])];
	NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:[NSURL URLWithString:urlString]];
	[request setHTTPMethod:@"POST"];
	
	if(postImage) {
		NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
		NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
		[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
		
		NSMutableData *body = [NSMutableData data];
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
		[body appendData:[NSData dataWithData:imageData]];
		[body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[request setHTTPBody:body];
	}
	
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
	imageString = [NSString stringWithString:returnString];
	[returnString release];
	
	//POST TO FACEBOOK?
	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"postToFacebook"] isEqualToString:@"YES"]) {
		if(postImage) {
			[self performSelectorOnMainThread:@selector(postToFacebookWithImage:) withObject:imageString waitUntilDone:NO];
		} else {
			[self performSelectorOnMainThread:@selector(postToFacebookWithImage:) withObject:nil waitUntilDone:NO];
		}
	}
	
	//POST TO TWITTER?
	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"postToTwitter"] isEqualToString:@"YES"]) {
		
		if(postImage) {
			//BITLY THE IMAGE URL AND TACK IT ON
			NSString *token = @"R_a46f495c5d5ad0c83e9f87651f5b80d6";
			
			NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.bit.ly/shorten?version=2.0.1&longUrl=http://www.ragedigi.com/apps/%@&login=ragedigi&apiKey=%@",imageString,token]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
			NSURLResponse *response;
			NSError *error;
			NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
			
			returnString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
			SBJSON *jsonParser = [[SBJSON alloc] init];
			NSDictionary *results = [jsonParser objectWithString:returnString error:NULL];
			NSLog(@"bitly: %@",results);
			NSString *imageURL = @"";
			if([[results objectForKey:@"errorMessage"] isEqualToString:@""]) {
				imageURL = [[[results objectForKey:@"results"] objectForKey:[NSString stringWithFormat:@"%@/apps/%@",[[VenueConnect sharedVenueConnect] rageDigitalBaseURL], imageString]] objectForKey:@"shortUrl"];
				NSLog(@"i: %@",imageURL);
			}
			
			if(commentText.length > 102) {
				commentText = [NSString stringWithFormat:@"%@...",[commentText substringToIndex:99]];
			}
			commentText = [NSString stringWithFormat:@"%@ %@ #%@",commentText,imageURL, [[VenueConnect sharedVenueConnect] twitterCommentSignature]];
			
			[jsonParser release];
			[returnString release];
		} else {
			if(commentText.length > 123) {
				commentText = [NSString stringWithFormat:@"%@...",[commentText substringToIndex:120]];
			}
			commentText = [NSString stringWithFormat:@"%@ #%@",commentText, [[VenueConnect sharedVenueConnect] twitterCommentSignature]];
		}
		
		[self performSelectorOnMainThread:@selector(postToTwitter:) withObject:commentText waitUntilDone:NO];
	}
	
	[self performSelectorOnMainThread:@selector(loadWall) withObject:nil waitUntilDone:NO];
	
	[pool release];
}


#pragma mark -
#pragma mark Text Field/View


- (void)textViewDidBeginEditing:(UITextView *)textView {
	if(textView == comment) {
		if([comment.text isEqualToString:@"Comment"]) {
			comment.text = @"";
			comment.textColor = [UIColor darkGrayColor];
		}
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if(textView == comment) {
		if([comment.text isEqualToString:@""]) {
			comment.text = @"Comment";
			comment.textColor = [UIColor grayColor];
		}
	}
}


#pragma mark -
#pragma mark Touches

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	if([touch view] == facebookIcon) {
		float newX = [touch locationInView:facebookView].x;
		if(newX < 17) {
			newX = 17;
		} else if(newX > 45) {
			newX = 45;
		}
		facebookIcon.frame = CGRectMake(newX-16,1,33,33);
	} else if([touch view] == twitterIcon) {
		float newX = [touch locationInView:twitterView].x;
		if(newX < 17) {
			newX = 17;
		} else if(newX > 45) {
			newX = 45;
		}
		twitterIcon.frame = CGRectMake(newX-16,1,33,33);
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	
	if([touch view] == facebookIcon) {
		float newX = [touch locationInView:facebookView].x;
		if(newX < 31) {
			newX = 17;
		} else {
			newX = 45;
		}
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.1];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		facebookIcon.frame = CGRectMake(newX-16,1,33,33);
		[UIView commitAnimations];
		
		if(newX == 45) {
			if(loggedIntoFB == 1) {
				if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"hasFBPerms"] isEqualToString:@"YES"]) {
					[UIView beginAnimations:nil context:NULL];
					[UIView setAnimationDuration:0.3];
					[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
					[UIView setAnimationDelegate:self];	
					alertView.frame = CGRectMake(0,-224,320,224);
					[UIView commitAnimations];
					
					if([username isFirstResponder]) {
						[username resignFirstResponder];
					}
					if([comment isFirstResponder]) {
						[comment resignFirstResponder];
					}
				}
			} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You must first login to publish to Facebook.  Would you like to login to Facebook?" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Login",nil];
				[alert setTag:-1];
				[alert show];
				[alert release];
			}
		}
	} else if([touch view] == twitterIcon) {
		float newX = [touch locationInView:twitterView].x;
		if(newX < 31) {
			newX = 17;
		} else {
			newX = 45;
		}
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.1];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		twitterIcon.frame = CGRectMake(newX-16,1,33,33);
		[UIView commitAnimations];
		
		if(newX == 45) {
			if(loggedIntoTwitter != 1) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You must first login to publish to Twitter.  Would you like to login to Twitter?" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Login",nil];
				[alert setTag:-2];
				[alert show];
				[alert release];
			}
		}
	}
}


#pragma mark -
#pragma mark Facebook Delegate

- (void)showFacebookLogin {
	if(![session resume]) {
		FBLoginDialog* dialog = [[[FBLoginDialog alloc] initWithSession:session] autorelease];
		[dialog show];
	}
}

- (void)getFacebookStreamPerms {
	FBPermissionDialog* dialog = [[[FBPermissionDialog alloc] init] autorelease];
	dialog.delegate = self;
	dialog.permission = @"publish_stream";
	[dialog show];
}

- (void)postToFacebookWithImage:(NSString *)imageString {
	NSString *attachment = @"";
	if(imageString) {
		attachment = [NSString stringWithFormat:@"{\"name\":\"%@ posted:\", \"media\": [{\"type\": \"image\", \"src\": \"%@/apps/%@\", \"href\": \"%@/\"}], \"description\": \"%@\"}",
					  username.text,
					  [[VenueConnect sharedVenueConnect] rageDigitalBaseURL],
					  imageString,
					  [[VenueConnect sharedVenueConnect] venueURL],
					  comment.text];
	} else {
		attachment = [NSString stringWithFormat:@"{\"name\":\"%@ posted:\", \"media\": [{\"type\": \"image\", \"src\": \"%@\", \"href\": \"%@/\"}], \"description\": \"%@\"}",
					  username.text,
					  [[VenueConnect sharedVenueConnect] facebookPostIcon],
					  [[VenueConnect sharedVenueConnect] venueURL],
					  comment.text];
	}
	
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
	NSString *myMessage = [NSString stringWithFormat:@" just posted to the %@ Live Fan Wall.", [[VenueConnect sharedVenueConnect] venueName]];
	[params setObject:myMessage forKey:@"message"];
	[params setObject:attachment forKey:@"attachment"];
	
	NSString *appMessage = [NSString stringWithFormat:@"Download %@ App", [[VenueConnect sharedVenueConnect] appName]];
	NSString *appURL = [NSString stringWithFormat:@"%@", [[VenueConnect sharedVenueConnect] appStoreURL]];
	

	
    NSString *action_links = [NSString stringWithFormat:@"[{\"text\":\"%@\",\"href\":\"%@\"}]", appMessage, appURL];
	NSLog(@"str=%@", action_links);
	
    [params setObject:action_links forKey:@"action_links"];
	
    [[FBRequest requestWithDelegate:self] call:@"facebook.Stream.publish" params:params];
}

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	loggedIntoFB = 1;
	if([[[NSUserDefaults standardUserDefaults] objectForKey:@"postToFacebook"] isEqualToString:@"YES"]) {
		facebookIcon.frame = CGRectMake(29,1,33,33);
	}
	if(addingPost == 1) {
		if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"hasFBPerms"] isEqualToString:@"YES"]) {
			[self getFacebookStreamPerms];
		}
	}
}

- (void)sessionDidNotLogin:(FBSession*)session {
	printf("DIALOGNOT ");
}

- (void)dialogDidSucceed:(FBDialog*)dialog {
	[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"hasFBPerms"];
	[self addPost];
}

- (void)dialogDidCancel:(FBDialog*)dialog {
	[[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"hasFBPerms"];
	facebookIcon.frame = CGRectMake(1,1,33,33);
	if(addingPost == 1) {
		[self addPost];
	}
}

- (void)request:(FBRequest*)request didLoad:(id)result {
	//NSLog(@"result: %@",result);
}

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error {
	//NSLog(@"error: %@",error);
}


#pragma mark -
#pragma mark Twitter Engine

- (void)showTwitterLogin {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	twitterLoginView.alpha = 1.0;
	twitterLoginView.transform = CGAffineTransformMakeScale(1.0, 1.0);
	[UIView commitAnimations];
}

- (IBAction)cancelTwitterLogin {
	[twitterLoginUsername resignFirstResponder];
	[twitterLoginPassword resignFirstResponder];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	twitterLoginView.alpha = 0.0;
	twitterLoginView.transform = CGAffineTransformMakeScale(0.7, 0.7);
	[UIView commitAnimations];
	
	twitterIcon.frame = CGRectMake(1,1,33,33);
	if(addingPost == 1) {
		[self addPost];
	}
}

- (IBAction)performTwitterLogin {
	twitterLoginCancelButton.alpha = 0.0;
	twitterLoginSignInButton.alpha = 0.0;
	twitterLoginLoader.hidden = NO;
	
	NSString *usernameTwitter = twitterLoginUsername.text;
	NSString *passwordTwitter = twitterLoginPassword.text;
	
	[twitterEngine setUsername:usernameTwitter password:passwordTwitter];
	twitterLoginCheck = [[twitterEngine checkUserCredentials] retain];
}

- (void)postToTwitter:(NSString *)commentText {
	[twitterEngine sendUpdate:commentText];
}

- (void)requestSucceeded:(NSString *)requestIdentifier {
	if([requestIdentifier isEqualToString:twitterLoginCheck]) {
		//LOGIN SUCCEEDED
		loggedIntoTwitter = 1;
		if([[[NSUserDefaults standardUserDefaults] objectForKey:@"postToTwitter"] isEqualToString:@"YES"]) {
			twitterIcon.frame = CGRectMake(29,1,33,33);
		}
		if(addingPost == 1) {
			[[NSUserDefaults standardUserDefaults] setObject:twitterLoginUsername.text forKey:@"tw_user"];
			[[NSUserDefaults standardUserDefaults] setObject:twitterLoginPassword.text forKey:@"tw_pass"];
			
			[twitterLoginUsername resignFirstResponder];
			[twitterLoginPassword resignFirstResponder];
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			twitterLoginView.alpha = 0.0;
			twitterLoginView.transform = CGAffineTransformMakeScale(0.7, 0.7);
			[UIView commitAnimations];
			
			[self addPost];
		}
	}
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error {
	if([requestIdentifier isEqualToString:twitterLoginCheck]) {
		//LOGIN FAILED
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tw_user"];
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tw_pass"];
		
		twitterLoginCancelButton.alpha = 1.0;
		twitterLoginSignInButton.alpha = 1.0;
		twitterLoginLoader.hidden = YES;
		
		twitterLoginPassword.text = @"";
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"We were unable to sign into Twitter at this time. Feel free to try agian." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)identifier {
	
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)identifier {
	
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)identifier {
	
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)identifier {
	
}

- (void)imageReceived:(UIImage *)image forRequest:(NSString *)identifier {
	
}

#pragma mark -

- (void)alertView:(UIAlertView *)alert didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if(alert.tag == -1) {
		if(buttonIndex == 0) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.1];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			facebookIcon.frame = CGRectMake(1,1,33,33);
			[UIView commitAnimations];
		} else {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			alertView.frame = CGRectMake(0,-224,320,224);
			[UIView commitAnimations];
			
			if([username isFirstResponder]) {
				[username resignFirstResponder];
			}
			if([comment isFirstResponder]) {
				[comment resignFirstResponder];
			}
			
			[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showFacebookLogin) userInfo:nil repeats:NO];
		}
	} else if(alert.tag == -2) {
		if(buttonIndex == 0) {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.1];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			twitterIcon.frame = CGRectMake(1,1,33,33);
			[UIView commitAnimations];
		} else {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			alertView.frame = CGRectMake(0,-224,320,224);
			[UIView commitAnimations];
			
			[twitterLoginUsername becomeFirstResponder];
			
			[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showTwitterLogin) userInfo:nil repeats:NO];
		}
	}
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (NSString *)getEncodeString:(NSString *)string {
	return [[[string stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"] stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[session release];
	[twitterEngine release];
	[twitterLoginCheck release];
	[displayCountries release];
	[postImage release];
	[imagePicker release];
}

@end
