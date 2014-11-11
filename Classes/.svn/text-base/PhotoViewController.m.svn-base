//
//  PhotoViewController.m
//  UDR
//
//  Created by Keiran Flanigan on 10/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "GalleryViewController.h"


@implementation PhotoViewController

@synthesize parent;


- (void)viewDidLoad {
	sourceIndex = 0;
	stopDownloading = 0;
	
	albums.frame = CGRectMake(-320,0,320,480);
	thumbs.frame = CGRectMake(0,0,320,480);
	imagesView.frame = CGRectMake(320,0,320,480);
}

#pragma mark -
#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	return [source count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier"];
	
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"identifier"] autorelease];
	}
	
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	cell.textLabel.text = [[source objectAtIndex:indexPath.row] objectForKey:@"name"];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	sourceIndex = indexPath.row;
	[self reloadThumbs];
	
	[specificThread cancel];
	specificThread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadSpecificPhotos) object:nil];
	[specificThread start];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	albums.frame = CGRectMake(-320,0,320,480);
	thumbs.frame = CGRectMake(0,0,320,480);
	[UIView commitAnimations];
}

#pragma mark -

- (void)setSource:(id)src {
	stopDownloading = 0;
	
	[source release];
	source = nil;
	[self reloadThumbs];
	
	if([src isKindOfClass:[NSArray class]]) {
		source = [[NSArray arrayWithArray:src] retain];
		//LOAD PHOTOS IN BG
		[photosThread cancel];
		photosThread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadPhotos) object:nil];
		[photosThread start];
		
		[self reloadThumbs];
		thumbs.frame = CGRectMake(0,0,320,480);
		imagesView.frame = CGRectMake(320,0,320,480);
	} else {
		[self performSelectorInBackground:@selector(setSourceInBackground:) withObject:src];
	}
}

- (void)setSourceInBackground:(id)src {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:src] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
	NSString *returnString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
	
	SBJSON *jsonParser = [[SBJSON alloc] init];
	source = [[[jsonParser objectWithString:[[returnString substringToIndex:[returnString length]-1] substringFromIndex:15] error:&error] objectForKey:@"items"] retain];
	[jsonParser release];
	[returnString release];
	
	//LOAD PHOTOS IN BG
	[photosThread cancel];
	photosThread = [[NSThread alloc] initWithTarget:self selector:@selector(downloadPhotos) object:nil];
	[photosThread start];

	[self reloadThumbs];
	thumbs.frame = CGRectMake(0,0,320,480);
	imagesView.frame = CGRectMake(320,0,320,480);
	
	[pool release];
}

- (void)downloadPhotos {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	printf("DOWNLOAD");
	NSString *temp = NSTemporaryDirectory();
	
	for(NSDictionary *d in source) {
		
		if(stopDownloading == 0) {
			
			NSArray *pieces = [[[d objectForKey:@"media"] objectForKey:@"m"] componentsSeparatedByString:@"/"];
			NSString *clubImage = [NSString stringWithFormat:@"/%@",[pieces lastObject]];
			NSLog(@"i: %@",clubImage);
			if(![[NSFileManager defaultManager] fileExistsAtPath:[temp stringByAppendingString:clubImage]]) {
				NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[d objectForKey:@"media"] objectForKey:@"m"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
				NSData *data = [NSData dataWithContentsOfURL:myURL];
				if(!data) {
					clubImage = nil;
				} else {
					[data writeToFile:[temp stringByAppendingString:clubImage] atomically:YES];
				}
			}
			
			[self performSelectorOnMainThread:@selector(refreshThumb:) withObject:d waitUntilDone:NO];
		
		}
		
	}
	
	[pool release];
}

- (void)downloadSpecificPhotos {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSString *temp = NSTemporaryDirectory();
	
	for(NSDictionary *d in source) {
		
		if(stopDownloading == 0) {
			
			NSArray *pieces = [[[d objectForKey:@"media"] objectForKey:@"m"] componentsSeparatedByString:@"/"];
			NSString *clubImage = [NSString stringWithFormat:@"/%@",[pieces lastObject]];
			NSLog(@"i: %@",clubImage);
			if(![[NSFileManager defaultManager] fileExistsAtPath:[temp stringByAppendingString:clubImage]]) {
				NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[d objectForKey:@"media"] objectForKey:@"m"] stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
				NSData *data = [NSData dataWithContentsOfURL:myURL];
				if(!data) {
					clubImage = nil;
				} else {
					[data writeToFile:[temp stringByAppendingString:clubImage] atomically:YES];
				}
				
				[self performSelectorOnMainThread:@selector(refreshThumb:) withObject:d waitUntilDone:NO];
			}
		
		}
		
	}
	
	[pool release];
}

- (void)refreshThumb:(NSDictionary *)d {
	UIButton *b = [[thumbs subviews] objectAtIndex:[source indexOfObject:d]];
	UIImageView *i = [[imagesHolder subviews] objectAtIndex:[source indexOfObject:d]];
	
	NSString *temp = NSTemporaryDirectory();
	NSArray *pieces = [[[d objectForKey:@"media"] objectForKey:@"m"] componentsSeparatedByString:@"/"];
	NSString *clubImage = [NSString stringWithFormat:@"/%@",[pieces lastObject]];
	
	UIImage *thumb = [UIImage imageWithContentsOfFile:[temp stringByAppendingString:clubImage]];
	
	[b setImage:thumb forState:UIControlStateNormal];
	i.image = thumb;
}

- (void)reloadThumbs {
	for(UIButton *b in [thumbs subviews]) {
		[b removeFromSuperview];
	}
	
	for(UIImageView *v in [imagesHolder subviews]) {
		if([v isKindOfClass:[UIImageView class]]) {
			[v removeFromSuperview];
		}
	}
	
	int c = 0;
	int x = 2;
	int y = 5;
	
	for(NSDictionary *d in source) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(x,y,75,75);
		button.clipsToBounds = YES;
		button.contentMode = UIViewContentModeScaleAspectFill;
		button.backgroundColor = [UIColor darkGrayColor];
		button.tag = c;
		[button addTarget:self action:@selector(showImage:) forControlEvents:UIControlEventTouchUpInside];
		
		NSString *temp = NSTemporaryDirectory();
		NSArray *pieces = [[[d objectForKey:@"media"] objectForKey:@"m"] componentsSeparatedByString:@"/"];
		NSString *clubImage = [NSString stringWithFormat:@"/%@",[pieces lastObject]];
		
		UIImage *thumb = [UIImage imageWithContentsOfFile:[temp stringByAppendingString:clubImage]];

		[button setImage:thumb forState:UIControlStateNormal];
		[thumbs addSubview:button];
		
		UIImageView *bigImage = [[UIImageView alloc] initWithImage:thumb];
		bigImage.frame = CGRectMake(c*320,0,320,387);
		bigImage.contentMode = UIViewContentModeScaleAspectFit;
		[imagesHolder addSubview:bigImage];
		[bigImage release];
		
		[self redrawAll];
		
		c++;
		if(c%4 == 0) {
			x = 2;
			y += 80;
		} else {
			x += 80;
		}
	}
	if(c%4 != 0) {
		y += 80;
	}
	if(y < 480) {
		y = 481;
	}
	thumbs.contentSize = CGSizeMake(320,y);
	imagesHolder.frame = CGRectMake(imagesHolder.frame.origin.x,44,c*320,387);
}

- (void)redrawAll {
	[thumbs setNeedsDisplay];
	[imagesHolder setNeedsDisplay];
}

- (void)showImage:(id)sender {
	imageIndex = [sender tag];
	imagesName.text = [[source objectAtIndex:[sender tag]] objectForKey:@"title"];
	imagesHolder.frame = CGRectMake(-320 * [sender tag],44,imagesHolder.frame.size.width,387);
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];	
	thumbs.frame = CGRectMake(-320,0,320,480);
	imagesView.frame = CGRectMake(0,0,320,480);
	[UIView commitAnimations];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)doneAction {
	stopDownloading = 1;
	[(GalleryViewController *)parent hidePhotoViewer];
}

- (void)backAction {
	if(imagesView.frame.origin.x == 0) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		thumbs.frame = CGRectMake(0,0,320,480);
		imagesView.frame = CGRectMake(320,0,320,480);
		[UIView commitAnimations];
	} else {
		stopDownloading = 1;
		[(GalleryViewController *)parent hidePhotoViewer];
	}
}


- (IBAction)movePhotos:(id)sender {
	if([sender tag] == 0) {
		if(imageIndex > 0) {
			imageIndex--;
			imagesName.text = [[source objectAtIndex:imageIndex] objectForKey:@"title"];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			imagesHolder.frame = CGRectMake(imageIndex*-320,44,imagesHolder.frame.size.width,imagesHolder.frame.size.height);
			[UIView commitAnimations];
		}
	} else {
		if(imageIndex < [source count]-1) {
			imageIndex++;
			imagesName.text = [[source objectAtIndex:imageIndex] objectForKey:@"name"];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			imagesHolder.frame = CGRectMake(imageIndex*-320,44,imagesHolder.frame.size.width,imagesHolder.frame.size.height);
			[UIView commitAnimations];
		}
	}
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	startingPoint = [touch locationInView:imagesView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSInteger holderX = imageIndex * -320;
	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:imagesView];
	float diffX = currentPoint.x - startingPoint.x;
	imagesHolder.frame = CGRectMake(holderX + diffX,44,imagesHolder.frame.size.width,imagesHolder.frame.size.height);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSInteger holderX = imageIndex * -320;
	UITouch *touch = [touches anyObject];
	CGPoint currentPoint = [touch locationInView:imagesView];
	float diffX = currentPoint.x - startingPoint.x;
	
	if(diffX > 80) {
		if(imageIndex > 0) {
			imageIndex--;
			imagesName.text = [[source objectAtIndex:imageIndex] objectForKey:@"title"];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			imagesHolder.frame = CGRectMake(imageIndex*-320,44,imagesHolder.frame.size.width,imagesHolder.frame.size.height);
			[UIView commitAnimations];
		} else {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			imagesHolder.frame = CGRectMake(holderX,44,imagesHolder.frame.size.width,imagesHolder.frame.size.height);
			[UIView commitAnimations];
		}
	} else if(diffX < -80) {
		if(imageIndex < [source count]-1) {
			imageIndex++;
			imagesName.text = [[source objectAtIndex:imageIndex] objectForKey:@"title"];
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			imagesHolder.frame = CGRectMake(imageIndex*-320,44,imagesHolder.frame.size.width,imagesHolder.frame.size.height);
			[UIView commitAnimations];
		} else {
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
			[UIView setAnimationDelegate:self];	
			imagesHolder.frame = CGRectMake(holderX,44,imagesHolder.frame.size.width,imagesHolder.frame.size.height);
			[UIView commitAnimations];
		}
	} else {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelegate:self];	
		imagesHolder.frame = CGRectMake(holderX,44,imagesHolder.frame.size.width,imagesHolder.frame.size.height);
		[UIView commitAnimations];
	}
}


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
	[source release];
	[photosThread release];
}


@end
