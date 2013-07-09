//
//  PSDetailViewController.m
//  iOSAppception
//
//  Created by Prabhjot on 7/1/13.
//  Copyright (c) 2013 Appception. All rights reserved.
//

#import "PSDetailViewController.h"

@interface PSDetailViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end
@implementation PSDetailViewController

@synthesize scrollView;
@synthesize pageControl;

bool pageControlBeingUsed = YES;
int noOfSynonyms=0;
bool firstTimePageCalled = YES;

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [self.view removeFromSuperview];
    [super viewDidLoad];
    [self configureView];
}


- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    [self configureView];
    }
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}



- (void) configureView
{
    [self configureOldViews];
    [self configureScrollView];
    if (self.labelWord) {
        self.title = [@"Synonyms for: " stringByAppendingString:self.labelWord];
    }
    
    if (self.detailItem) {
        NSString *synonyms = [self.detailItem description];
        NSArray *synonymsArray = [synonyms componentsSeparatedByString:@","];
        noOfSynonyms = synonymsArray.count;
        pageControl.numberOfPages = noOfSynonyms;
        int i = 0;
        for (i = 0; i < synonymsArray.count; i++) {
            [self addLabel:[synonymsArray objectAtIndex:i] :i];
            
        }
        [self addLabel:[synonymsArray objectAtIndex:0] :i];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width *  (noOfSynonyms+1), self.scrollView.frame.size.height);
        synonyms = nil;
        synonymsArray = nil;
    }
    [self.view addSubview: self.scrollView];
    self.labelWord = nil;
}

-(void) configureOldViews
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self removeOldViews];
    }
    else {
        if (!firstTimePageCalled)
        {
            [self removeOldViews];
            //            NSLog(@"remove views called");
        }
        else {
            self.detailDescriptionLabel.text = @"Please select the word to \n view synonyms";
            self.detailDescriptionLabel.textColor = [UIColor grayColor];
            self.detailDescriptionLabel.font = [UIFont fontWithName:@"Arial" size:35];
            firstTimePageCalled = NO;
        }
    }   
}
-(void)removeOldViews
{
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *subV in viewsToRemove) {
        [subV removeFromSuperview];
    }
}

- (void) configureScrollView
{
    self.scrollView = nil;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setDirectionalLockEnabled:YES];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setDelegate:self];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setScrollsToTop:NO];
}

- (void) addLabel: (NSString*)synonym :(int) frameIndex
{ 
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * frameIndex;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setText:synonym];
    label.textColor = [UIColor grayColor];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            label.font = [UIFont fontWithName:@"Arial" size:35];
    } else {
            label.font = [UIFont fontWithName:@"Arial" size:75];
    }
    label.textAlignment = UITextAlignmentCenter;
    [self.scrollView addSubview:label];
    label = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;

    // To make infinite horizontal scroll
    int lastFrameX = self.scrollView.frame.size.width * noOfSynonyms;
    int width = self.scrollView.frame.size.width;
    int height = self.scrollView.frame.size.height;
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * noOfSynonyms;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    if (self.scrollView.contentOffset.x > (lastFrameX)) {
        [self.scrollView scrollRectToVisible:CGRectMake(0,0,width,height) animated:NO];
    }
    if (self.scrollView.contentOffset.x < 0) {
        [self.scrollView scrollRectToVisible:CGRectMake(lastFrameX,0,width,height) animated:NO];
    }
    pageControlBeingUsed = NO;
} 

- (IBAction)changePage {
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self removeOldViews];
    self.scrollView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Synonyms", @"Synonyms");
    }
    return self;
}
							
#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    // NSLog(@"unloading");
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pageControlBeingUsed = NO;
}

@end
