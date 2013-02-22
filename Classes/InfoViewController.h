//
//  InfoViewController.h
//  Fox
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface InfoViewController : UIViewController <UIScrollViewDelegate,MKMapViewDelegate,UIAlertViewDelegate> {
	IBOutlet UIScrollView *mainView;
	IBOutlet MKMapView *mapView;
	IBOutlet UIButton *backButton;
	
	IBOutlet UIButton *boxCallButton;
	IBOutlet UIButton *mainCallButton;
}

- (void)hideBackButton;
- (void)showBackButton;

- (IBAction)callNumber:(id)sender;
- (IBAction)showMap;
- (void)placePinsOnMap;

- (IBAction)backAction;

@end
