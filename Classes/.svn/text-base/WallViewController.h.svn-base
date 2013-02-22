//
//  WallViewController.h
//  Fox
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoxAppDelegate.h"
#import "FBConnect/FBConnect.h"
#import "MGTwitterEngine.h"


@class FBSession;

@interface WallViewController : UIViewController <UIWebViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate,FBDialogDelegate,FBSessionDelegate,FBRequestDelegate,MGTwitterEngineDelegate> {
	FoxAppDelegate *appDelegate;
	FBSession *session;
	NSInteger loggedIntoFB;
	
	MGTwitterEngine *twitterEngine;
	NSInteger loggedIntoTwitter;
	
	NSInteger addingPost;
	NSDictionary *displayCountries;
	
	IBOutlet UIWebView *webView;
	UIImagePickerController *imagePicker;
	UIImage *postImage;
	
	IBOutlet UIView *alertView;
	IBOutlet UITextField *username;
	IBOutlet UIImageView *usernameBG;
	IBOutlet UITextView *comment;
	IBOutlet UIButton *photoButton;
	
	IBOutlet UIActivityIndicatorView *loader;
	
	IBOutlet UIView *facebookView;
	IBOutlet UIImageView *facebookIcon;
	
	IBOutlet UIView *twitterView;
	IBOutlet UIImageView *twitterIcon;
	
	NSString *twitterLoginCheck;
	IBOutlet UIView *twitterLoginView;
	IBOutlet UITextField *twitterLoginUsername;
	IBOutlet UITextField *twitterLoginPassword;
	IBOutlet UIButton *twitterLoginCancelButton;
	IBOutlet UIButton *twitterLoginSignInButton;
	IBOutlet UIActivityIndicatorView *twitterLoginLoader;
}

- (void)manualLoad;

- (BOOL)isConnectedToInternet;
- (NSString *)getEncodeString:(NSString *)string;

- (void)loadWallString;
- (void)loadWall;
- (IBAction)reloadWall;
- (void)displayWall;
- (BOOL)wallNeedsLoading;
- (void)loadTempWallWithUsername:(NSString *)nameString andComment:(NSString *)commentString;

- (IBAction)addPost;
- (IBAction)cancelPost:(id)sender;
- (void)resetPost;
- (void)performPost:(NSDictionary *)postInfo;

- (IBAction)addImage;
- (IBAction)submitPost;

- (void)showFacebookLogin;
- (void)getFacebookStreamPerms;
- (void)postToFacebookWithImage:(NSString *)imageString;

- (void)showTwitterLogin;
- (IBAction)cancelTwitterLogin;
- (IBAction)performTwitterLogin;
- (void)postToTwitter:(NSString *)commentText;

@end
