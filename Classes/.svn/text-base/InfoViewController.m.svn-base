//
//  InfoViewController.m
//  Fox
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "MapAnnotation.h"


@implementation InfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
	
	if(![[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) {
		boxCallButton.userInteractionEnabled = NO;
		[boxCallButton setBackgroundImage:nil forState:UIControlStateNormal];
		mainCallButton.userInteractionEnabled = NO;
		[mainCallButton setBackgroundImage:nil forState:UIControlStateNormal];
	}
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"faqs" ofType:@"plist"];
	NSArray *faqs = [NSArray arrayWithContentsOfFile:path];
	
	int y = 395;
	for(NSDictionary *d in faqs) {
		UILabel *q = [[UILabel alloc] initWithFrame:CGRectMake(15,y,290,30)];
		q.backgroundColor = [UIColor clearColor];
		q.font = [UIFont boldSystemFontOfSize:14];
		q.textColor = [UIColor colorWithRed:0.933 green:0.694 blue:0.066 alpha:1.0];
		q.numberOfLines = 0;
		q.text = [d objectForKey:@"question"];
		[q sizeToFit];
		[mainView addSubview:q];
		[q release];
		
		y += q.frame.size.height + 5;
		
		UILabel *a = [[UILabel alloc] initWithFrame:CGRectMake(15,y,290,30)];
		a.backgroundColor = [UIColor clearColor];
		a.font = [UIFont systemFontOfSize:13];
		a.textColor = [UIColor whiteColor];
		a.numberOfLines = 0;
		a.text = [d objectForKey:@"answer"];
		[a sizeToFit];
		[mainView addSubview:a];
		[a release];
		
		y += a.frame.size.height + 15;
	}
	
	mainView.contentSize = CGSizeMake(320,y+10);
	mainView.frame = CGRectMake(0,39,320,392);
	
	mapView.frame = CGRectMake(0,431,320,361);
	[self placePinsOnMap];
	CLLocationCoordinate2D location;
	location.latitude = 40.007744;
	location.longitude = -105.276058;
	[mapView setRegion:MKCoordinateRegionMake(location,MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
}

- (IBAction)callNumber:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Call %@",[sender titleForState:UIControlStateNormal]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call",nil];
	[alert setTag:0];
	[alert show];
	[alert release];
}

- (IBAction)showMap {
	[self showBackButton];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	mapView.frame = CGRectMake(0,39,320,361);
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark Map View

- (void)placePinsOnMap {
	[mapView removeAnnotations:[mapView annotations]];
	
	CLLocationCoordinate2D location;
	
	location.latitude = 40.007744;
	location.longitude = -105.276058;
	
	MapAnnotation *annotation = [[MapAnnotation alloc] initWithCoordinate:location];
	annotation.title = @"Fox Theatre";
	annotation.subtitle = @"Boulder, CO";
	[mapView addAnnotation:annotation];
	[annotation release];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
	MKPinAnnotationView *annotationView = nil;
	MKPinAnnotationView *imageAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
	
	if(nil == imageAnnotationView) {
		imageAnnotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"] autorelease];
	}
	annotationView = imageAnnotationView;
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	annotationView.rightCalloutAccessoryView = button;
	button.tag = [[mapView annotations] indexOfObject:annotation];
	
	[annotationView setPinColor:MKPinAnnotationColorRed];
	[annotationView setEnabled:YES];
	[annotationView setCanShowCallout:YES];
	[annotationView setAnimatesDrop:YES];
	
	return annotationView;
}

- (void)mapView:(MKMapView *)map annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[(MapAnnotation *)[[map annotations] objectAtIndex:[control tag]] title] message:@"Would you like to get directions to the Fox Theatre? This will close the Fox application and open the native Maps application." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Directions",nil];
	[alert setTag:1];
	[alert show];
	[alert release];
}


#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if([alertView tag] == 0) {
		if(buttonIndex == 1) {
			NSString *number = [[[[[alertView.message stringByReplacingOccurrencesOfString:@"Call (" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]]];
		}
	} else {
		if(buttonIndex == 1) {
			NSString *url = [NSString stringWithFormat: @"http://maps.google.com/maps?daddr=40.007744,-105.276058"];
			[[UIApplication sharedApplication] openURL: [NSURL URLWithString:url]];
		}
	}
}


- (void)showBackButton {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	backButton.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)hideBackButton {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	backButton.alpha = 0.0;
	[UIView commitAnimations];
}

- (IBAction)backAction {
	if(mapView.frame.origin.y == 39) {
		[self hideBackButton];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		mapView.frame = CGRectMake(0,431,320,361);
		[UIView commitAnimations];
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
