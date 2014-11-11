//
//  BoulderTheaterAppDelegate.h
//  Boulder Theater
//
//  Created by Keiran Flanigan on 11/4/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSON.h"
#import "VenueConnect.h"

@interface BoulderTheaterAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, UITextFieldDelegate> {
	
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
	UIButton *advertFull;
	
	UIView *headerView;
	UIImageView *splashView;
	UIView *blackBG;	
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

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UIView *blackBG;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, assign) NSInteger keyboardIsInUse;
@property (nonatomic, assign) UITextField *currentTextField;
@property (nonatomic, assign) UIButton *advert;
@property (nonatomic, assign) UIButton *advertFull;
@property (nonatomic, retain) NSString *deviceToken;
@property (nonatomic, retain) NSString *deviceAlias;
@property (nonatomic, readonly) NSNumber *finishedInitLoad;

@end
