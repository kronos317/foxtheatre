//
//  ShowCell.h
//  VenueConnect
//
//  Created by Keiran on 11/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShowCell : UITableViewCell {
	IBOutlet UILabel *day;
	IBOutlet UILabel *date;
	IBOutlet UILabel *show;
	IBOutlet UILabel *showtime;	
	IBOutlet UILabel *doorsLabel;	
	IBOutlet UILabel *doors;
}

@property (nonatomic,assign) IBOutlet UILabel *day;
@property (nonatomic,assign) IBOutlet UILabel *date;
@property (nonatomic,assign) IBOutlet UILabel *show;
@property (nonatomic,assign) IBOutlet UILabel *showtime;
@property (nonatomic,assign) IBOutlet UILabel *doorsLabel;
@property (nonatomic,assign) IBOutlet UILabel *doors;

@end
