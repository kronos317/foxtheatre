//
//  InfoViewController.m
//  VenueConnect
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "InfoViewController.h"
#import "MapAnnotation.h"
#import "VenueConnect.h"
#import "Global.h"

@implementation InfoViewController


#define DEFAULT_POS_Y       49

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//NSLog(@"Load2");//Nic
	if(![[[UIDevice currentDevice] model] hasPrefix:@"iPhone"]) {
		boxCallButton.userInteractionEnabled = NO;
		//[boxCallButton setBackgroundImage:nil forState:UIControlStateNormal];
		//mainCallButton.userInteractionEnabled = NO;
		//[mainCallButton setBackgroundImage:nil forState:UIControlStateNormal];
	}
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"faqs" ofType:@"plist"];
	NSArray *faqs = [NSArray arrayWithContentsOfFile:path];
	
	backButton.alpha = 0.0;
	
    // webView.frame = CGRectMake(320,39,320,361);
    // webView.frame = [self moveFrameHorz:webView.frame :G_WIDTH];
    // webView.frame = [self moveFrameVert:webView.frame :G_HEIGHT];
	
	int y = 460;
	for(NSDictionary *d in faqs) {
		UILabel *q = [[UILabel alloc] initWithFrame:CGRectMake(15,y,290,30)];
		q.backgroundColor = [UIColor clearColor];
		q.font = [UIFont boldSystemFontOfSize:14];
		q.textColor = [UIColor colorWithRed:0.843 green:0.463 blue:0.129 alpha:1.0];
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
	
	mainView.contentSize = CGSizeMake(G_WIDTH, y+10);
	// mainView.frame = CGRectMake(0,39,320,392);
    mainView.frame = [self moveFrameVert:mainView.frame :DEFAULT_POS_Y];
    
	// webView.frame = CGRectMake(0,431,320,361);
    webView.frame = [self moveFrameVert:webView.frame :G_HEIGHT];
    
	// [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[VenueConnect sharedVenueConnect] venueURL]]]];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[VenueConnect sharedVenueConnect] getConfigKey:@"venueURL"]]]];
    
	// mapView.frame = CGRectMake(0,431,320,361);
    mapView.frame = [self moveFrameVert:mapView.frame :G_HEIGHT];
    
	[self placePinsOnMap];
	CLLocationCoordinate2D location;
	// location.latitude = [[[VenueConnect sharedVenueConnect] venueLatitude] doubleValue];
	// location.longitude = [[[VenueConnect sharedVenueConnect] venueLongitude] doubleValue];
    
    location.latitude = [[[VenueConnect sharedVenueConnect] getConfigKey:@"venueLatitude"] doubleValue];
    location.longitude = [[[VenueConnect sharedVenueConnect] getConfigKey:@"venueLongitude"] doubleValue];
    
	[mapView setRegion:MKCoordinateRegionMake(location,MKCoordinateSpanMake(0.01, 0.01)) animated:YES];
}

- (IBAction)callNumber:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Call %@",[[VenueConnect sharedVenueConnect] getConfigKey:@"venueBoxCallNumber"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call",nil];
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
	// mapView.frame = CGRectMake(0,39,320,361);
    mapView.frame = [self moveFrameVert:mapView.frame :DEFAULT_POS_Y];
    
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Web View

- (void)webViewDidStartLoad:(UIWebView *)wView {
	webLoader.hidden = NO;
	[webLoader startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)wView {
	webLoader.hidden = YES;
	[webLoader stopAnimating];
}

- (void)webView:(UIWebView *)wView didFailLoadWithError:(NSError *)error {
	webLoader.hidden = YES;
	[webLoader stopAnimating];
    /*
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Load Failed" message:@"Web site failed to load. You are either not connected to the internet, or the server stopped responding" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	[alertView show];
	[alertView release];	
     */
}

- (BOOL)webView:(UIWebView *)wView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	return TRUE;
}

- (IBAction)visitWebsite:(id)sender {
	if([[VenueConnect sharedVenueConnect] isConnectedToInternet]) {
		//[self hideAddToFavoritesButton];
		[self showBackButton];
		[self showWebButtons];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		// webView.frame = CGRectMake(0,39,320,361);
        webView.frame = [self moveFrameVert:webView.frame :DEFAULT_POS_Y];
        
		// detailView.frame = CGRectMake(-320,39,320,392);
		[UIView commitAnimations];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You must be connected to the internet to buy tickets." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

- (void)showWebButtons {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	webBackButton.alpha = 1.0;
	webForwardButton.alpha = 1.0;
	webLoader.alpha = 1.0;
	[UIView commitAnimations];
}

- (void)hideWebButtons {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	webBackButton.alpha = 0.0;
	webForwardButton.alpha = 0.0;
	webLoader.alpha = 0.0;
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark Map View

- (void)placePinsOnMap {
	[mapView removeAnnotations:[mapView annotations]];
	
	CLLocationCoordinate2D location;

	// location.latitude = [[[VenueConnect sharedVenueConnect] venueLatitude] doubleValue];
	// location.longitude = [[[VenueConnect sharedVenueConnect] venueLongitude] doubleValue];
    
    location.latitude = [[[VenueConnect sharedVenueConnect] getConfigKey:@"venueLatitude"] doubleValue];
    location.longitude = [[[VenueConnect sharedVenueConnect] getConfigKey:@"venueLongitude"] doubleValue];
	
	MapAnnotation *annotation = [[MapAnnotation alloc] initWithCoordinate:location];
	// annotation.title = [[VenueConnect sharedVenueConnect] venueName];
	// annotation.subtitle = [NSString stringWithFormat:@"%@, %@", [[VenueConnect sharedVenueConnect] venueCity], [[VenueConnect sharedVenueConnect] venueState]];
    annotation.title = [[VenueConnect sharedVenueConnect] getConfigKey:@"venueName"];
    annotation.subtitle = [NSString stringWithFormat:@"%@, %@", [[VenueConnect sharedVenueConnect] getConfigKey:@"venueCity"], [[VenueConnect sharedVenueConnect] getConfigKey:@"venueState"]];
    
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
	// NSString *myPrompt = [NSString stringWithFormat:@"Would you like to get directions to the %@? This will close this application and open the native Maps application.", [[VenueConnect sharedVenueConnect] venueName]];
	NSString *myPrompt = [NSString stringWithFormat:@"Would you like to get directions to the %@? This will close this application and open the native Maps application.", [[VenueConnect sharedVenueConnect] getConfigKey:@"venueName"]];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[(MapAnnotation *)[[map annotations] objectAtIndex:[control tag]] title] message:myPrompt delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Directions",nil];
	[alert setTag:1];
	[alert show];
	[alert release];
}


#pragma mark -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if([alertView tag] == 0) {
		if(buttonIndex == 1) {
            // Call
            NSString *number = [[VenueConnect sharedVenueConnect] getConfigKey:@"venueBoxCallNumber"];
            /*
			NSString *number = [[[[[alertView.message stringByReplacingOccurrencesOfString:@"Call (" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@"." withString:@""];
             */
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]]];
		}
	} else if ([alertView tag] == 1){
		if(buttonIndex == 1) {
            // Map
			// NSString *url = [NSString stringWithFormat: @"http://maps.google.com/maps?daddr=%f,%f", [[[VenueConnect sharedVenueConnect] venueLatitude] doubleValue],[[[VenueConnect sharedVenueConnect] venueLongitude] doubleValue]];
            NSString *url = [NSString stringWithFormat: @"http://maps.google.com/maps?daddr=%f,%f", [[[VenueConnect sharedVenueConnect] getConfigKey:@"venueLatitude"] doubleValue],[[[VenueConnect sharedVenueConnect] getConfigKey:@"venueLongitude"] doubleValue]];
            
			[[UIApplication sharedApplication] openURL: [NSURL URLWithString:url]];
		}
	}
    else if ([alertView tag] == 2){
        if (buttonIndex == 1){
            // SMS
            NSString *number = [[VenueConnect sharedVenueConnect] getConfigKey:@"venueBoxTextNumber"];
            MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"";
                controller.recipients = [NSArray arrayWithObjects:number, nil];
                controller.messageComposeDelegate = self;
                [self presentViewController:controller animated:YES completion:nil];
                // [self presentModalViewController:controller animated:YES];
            }
        }
    }
    else if([alertView tag] == 3) {
		if(buttonIndex == 1) {
            // Call
            NSString *number = [[VenueConnect sharedVenueConnect] getConfigKey:@"venueMainCallNumber"];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]]];
		}
	}
    else if ([alertView tag] == 4) {
        if (buttonIndex == 1){
            // SMS
            NSString *number = [[VenueConnect sharedVenueConnect] getConfigKey:@"venueMainTextNumber"];
            MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"";
                controller.recipients = [NSArray arrayWithObjects:number, nil];
                controller.messageComposeDelegate = self;
                [self presentViewController:controller animated:YES completion:nil];
                // [self presentModalViewController:controller animated:YES];
            }
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
	if(mapView.frame.origin.y == DEFAULT_POS_Y) {
		[self hideBackButton];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		// mapView.frame = CGRectMake(0,431,320,361);
        mapView.frame = [self moveFrameVert:mapView.frame :G_HEIGHT];
        
		[UIView commitAnimations];
	}
	else if(webView.frame.origin.y == DEFAULT_POS_Y) {
		[self hideBackButton];
		[self hideWebButtons];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		// webView.frame = CGRectMake(0,431,320,361);
        webView.frame = [self moveFrameVert:webView.frame :G_HEIGHT];
        
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

- (CGRect) moveFrameHorz: (CGRect) rtFrame :(int) newX{
    CGRect rtResult = CGRectMake(newX, rtFrame.origin.y, rtFrame.size.width, rtFrame.size.height);
    return rtResult;
}

- (CGRect) moveFrameVert: (CGRect) rtFrame :(int) newY{
    CGRect rtResult = CGRectMake(rtFrame.origin.x, newY, rtFrame.size.width, rtFrame.size.height);
    return rtResult;
}

- (IBAction)onBtnCallClick:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Call %@",[[VenueConnect sharedVenueConnect] getConfigKey:@"venueBoxCallNumberTitle"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call",nil];
	[alert setTag:0];
	[alert show];
	[alert release];
}

- (IBAction)onBtnTextClick:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Text message to %@",[[VenueConnect sharedVenueConnect] getConfigKey:@"venueBoxTextNumberTitle"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"SMS",nil];
	[alert setTag:2];
	[alert show];
	[alert release];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Sorry, we encountered an unexpected error while sending SMS.\r\nPlease try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert setTag:10];
            [alert show];
            [alert release];
            break;
        }
		case MessageComposeResultSent:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Thank you." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert setTag:10];
            [alert show];
            [alert release];
            
            break;
        }
		default:
			break;
	}
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onBtnMainCallClick:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Call %@",[[VenueConnect sharedVenueConnect] getConfigKey:@"venueMainCallNumberTitle"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Call",nil];
	[alert setTag:3];
	[alert show];
	[alert release];
}

- (IBAction)onBtnMainTextClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Text message to %@",[[VenueConnect sharedVenueConnect] getConfigKey:@"venueMainTextNumberTitle"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"SMS",nil];
	[alert setTag:4];
	[alert show];
	[alert release];
}

@end
