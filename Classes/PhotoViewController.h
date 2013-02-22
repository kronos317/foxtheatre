//
//  PhotoViewController.h
//  UDR
//
//  Created by Keiran Flanigan on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoViewController : UIViewController <UINavigationBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {
	IBOutlet UITableView *albums;
	IBOutlet UIScrollView *thumbs;
	IBOutlet UIView *imagesView;
	IBOutlet UIView *imagesHolder;
	IBOutlet UILabel *imagesName;
	
	NSInteger stopDownloading;
	NSThread *photosThread;
	NSThread *specificThread;
	
	UIViewController *parent;
	NSArray *source;
	NSInteger sourceIndex;
	NSInteger imageIndex;
	
	CGPoint startingPoint;
}

- (void)setSource:(NSArray *)src;
- (void)setSourceInBackground:(id)src;
- (void)downloadPhotos;

- (void)refreshThumb:(NSDictionary *)d;
- (void)reloadThumbs;
- (void)redrawAll;

- (void)doneAction;
- (void)backAction;

- (IBAction)movePhotos:(id)sender;

@property (nonatomic,assign) UIViewController *parent;

@end
