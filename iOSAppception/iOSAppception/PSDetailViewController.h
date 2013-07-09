//
//  PSDetailViewController.h
//  iOSAppception
//
//  Created by Prabhjot on 7/1/13.
//  Copyright (c) 2013 Appception. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSDetailViewController : UIViewController <UISplitViewControllerDelegate>
{
    UIScrollView* scrollView;
    UIPageControl* pageControl;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;
@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet NSString *labelWord;

-(IBAction)changePage;

@end

