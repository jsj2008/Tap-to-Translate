//
//  TTTCopyingOptionsDelegate.m
//  
//
//  Created by Mohamed Marbouh on 2016-06-15.
//
//

#import "headers/headers.h"

@implementation TTTCopyingOptionsDelegate

- (void)tableView:(TTTGoogleStyleSelectionView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	switch(indexPath.row) {
		case 0:
			[TapToTranslate copyTextAndExit];
			break;
		case 1:
			[TapToTranslate openInGoogleTranslateApp];
			break;
		default:
			break;
	}
}

@end
