//
//  CalendarViewController.h
//  Fox
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoxAppDelegate.h"

@class AudioStreamer;

@interface CalendarViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIWebViewDelegate> {
	FoxAppDelegate *appDelegate;
	
	NSArray *shows;
	NSMutableArray *favorites;
	NSUserDefaults *defaults;
	NSString *currentView;
	NSInteger currentShow;
	UIView *currentSongView;
	
	AudioStreamer *streamer;
	
	IBOutlet UIView *tablesHolder;
	IBOutlet UIButton *flipButton;
	IBOutlet UITableView *showsTable;
	IBOutlet UITableView *favoritesTable;
	
	IBOutlet UIScrollView *detailView;
	IBOutlet UIWebView *webView;
	IBOutlet UIButton *backButton;
	IBOutlet UIButton *addToFavoritesButton;
	IBOutlet UIButton *webBackButton;
	IBOutlet UIButton *webForwardButton;
	IBOutlet UIActivityIndicatorView *webLoader;
	
	IBOutlet UIImageView *detailImage;
	IBOutlet UILabel *detailDate;
	IBOutlet UILabel *detailPresents;
	IBOutlet UILabel *detailHeadliner;
	IBOutlet UILabel *detailOpener;
	IBOutlet UILabel *detailDoorsTime;
	IBOutlet UILabel *detailShowTime;
	IBOutlet UILabel *detailPrice;
	IBOutlet UILabel *detailAges;
	IBOutlet UIButton *detailTicketsButton;
	IBOutlet UILabel *detailWriteUpHeader;
	IBOutlet UILabel *detailWriteUp;
}

- (void)loadShows;
- (void)reloadTables;
- (IBAction)flipTables;
- (void)accessoryAction:(id)sender;

- (void)downloadImage:(NSString *)image;
- (void)changeDetailImage:(NSString *)clubImage;

- (void)playbackStateChanged:(NSNotification *)aNotification;
- (void)playSong:(id)sender;
- (void)stopSong:(id)sender;

- (IBAction)buyTicketsAction;

- (void)showBackButton;
- (void)hideBackButton;
- (void)showAddToFavoritesButton;
- (void)hideAddToFavoritesButton;
- (void)showFavoritesButton;
- (void)hideFavoritesButton;
- (void)showWebButtons;
- (void)hideWebButtons;
- (IBAction)addToFavoritesAction;
- (IBAction)backAction;

- (BOOL)isConnectedToInternet;

@end
