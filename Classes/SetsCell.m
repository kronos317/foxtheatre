//
//  SetsCell.m
//  VenueConnect
//
//  Created by Keiran Flanigan on 11/9/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SetsCell.h"


@implementation SetsCell

@synthesize title;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [super dealloc];
}


@end
