//
//  FoxAppDelegate.h
//  Fox
//
//  Created by Keiran Flanigan on 11/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"

@interface FoxAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UITextFieldDelegate> {
    UIWindow *window;
	NSNumber *finishedInitLoad;
	
	NSString *deviceToken;
	NSString *deviceAlias;
	
    UITabBarController *tabBarController;
	SBJSON *jsonParser;
	
	NSUserDefaults *defaults;
	NSInteger keyboardIsInUse;
	IBOutlet UIView *textFieldBar;
	UITextField *currentTextField;
	
	UIButton *advert;
	
	UIView *headerView;
	UIImageView *splashView;
	UIView *signUpView;
	UITextField *signUpEmail;
	UITextField *signUpNumber;
	UITextField *signUpName;
}

- (void)refreshAd;
- (void)downloadAdImages;

- (void)keyboardWillShow;
- (void)keyboardWillHide;
- (IBAction)textFieldPreviousAction;
- (IBAction)textFieldNextAction;
- (IBAction)textFieldDoneAction:(id)sender;

- (void)showSignUpForm;
- (void)hideSplashView;
- (void)killSplashView;

- (void)showHeader;
- (void)hideHeader;

- (void)signUpAction;
- (void)postSignup;
- (NSString *)getEncodeString:(NSString *)string;

- (void)toggleAdvert;
- (void)changeAdvertImage;

- (void)setupDefaults;
- (BOOL)isConnectedToInternet;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, assign) NSInteger keyboardIsInUse;
@property (nonatomic, assign) UITextField *currentTextField;
@property (nonatomic, assign) UIButton *advert;
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, retain) NSString *deviceAlias;
@property (nonatomic, readonly) NSNumber *finishedInitLoad;

@end
