//
//  TTTLanguageSelectionController.h
//  Tap to Translate
//
//  Created by Mohamed Marbouh on 2016-12-14.
//  Copyright © 2016 Mohamed Marbouh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DZNEmptyDataSet/UIScrollView+EmptyDataSet.h"

@interface TTTLanguageSelectionController : UITableViewController <DZNEmptyDataSetSource>

@property BOOL isInput;

@end
