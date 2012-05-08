//
//  BUTTViewController.m
//  jfkldsa
//
//  Created by Sean Wolter on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BUTTViewController.h"

@interface BUTTViewController ()
@property (weak, nonatomic) IBOutlet UIButton *noPrtyButt;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollyView;
@property (strong, nonatomic) UIImageView *fartbutt;
@property (assign, nonatomic) NSInteger lastPage;
@property (assign, nonatomic) BOOL isPartying;
@end

@implementation BUTTViewController
@synthesize noPrtyButt;
@synthesize scrollyView;
@synthesize fartbutt;
@synthesize lastPage;
@synthesize isPartying;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lastPage = 0;
    self.isPartying = NO;
    
    self.scrollyView.contentSize = CGSizeMake(960.0, 300.0);
    self.scrollyView.delegate = self;
    
    self.noPrtyButt.hidden = YES;
    self.noPrtyButt.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    self.fartbutt = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0,386.0,300.0)];
    self.fartbutt.animationImages = [NSArray arrayWithObjects:    
                                    [UIImage imageNamed:@"100.tiff"],
                                    [UIImage imageNamed:@"101.tiff"],
                                    [UIImage imageNamed:@"102.tiff"],
                                    [UIImage imageNamed:@"103.tiff"],
                                    [UIImage imageNamed:@"104.tiff"],
                                    [UIImage imageNamed:@"105.tiff"],
                                    nil];
    self.fartbutt.animationDuration = .25;
    self.fartbutt.animationRepeatCount = 0;
    [self.fartbutt startAnimating];
    [self.scrollyView insertSubview:self.fartbutt atIndex:0];
    [self updateStrobeView];
}

- (void)viewDidUnload
{
    [self setFartbutt:nil];
    [self setScrollyView:nil];
    [self setNoPrtyButt:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)updateStrobeView
{
    NSArray *imageArray = [NSArray arrayWithObjects:
                           [self randomColorImage],
                           [self randomColorImage],
                           [self randomColorImage],
                           [self randomColorImage],
                           [self randomColorImage],
                           nil];

    CGFloat theEnd = (self.lastPage + 1) * 480.0;
    UIImageView *strobe = [[UIImageView alloc] initWithFrame:CGRectMake(theEnd,0.0,480.0,300.0)];
    strobe.animationImages = imageArray;
    strobe.animationDuration = 0.12;
    strobe.animationRepeatCount = 0;
    [strobe startAnimating];
    [self.scrollyView addSubview:strobe];
}

- (UIImage*)randomColorImage
{
    CGFloat red = (arc4random() % 256);
    CGFloat green = (arc4random() % 256);
    CGFloat blue = (arc4random() % 256);
    CGSize size = CGSizeMake(480.0,300.0);
    
    UIColor *color = [UIColor colorWithRed:red/256 green:green/256 blue:blue/256 alpha:1.0];
    UIGraphicsBeginImageContext( size );
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    UIImage *colorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return colorImg;
}

- (void)partyAutoScroll
{
    if (self.isPartying) {
        [self.scrollyView setContentOffset:CGPointMake(self.scrollyView.contentSize.width - 480.0,0.0) animated:TRUE];
        [self createAnotherPage];
        [self performSelector:@selector(partyAutoScroll) withObject:nil afterDelay:0.5f];
    } else {
        self.scrollyView.contentSize = CGSizeMake(960.0, 300.0);
        [self.scrollyView setContentOffset:CGPointZero animated:TRUE];
        self.lastPage = 0;
        self.noPrtyButt.hidden = YES;
        self.noPrtyButt.transform = CGAffineTransformMakeScale(0.1, 0.1);
        for (UIButton *button in self.scrollyView.subviews) {
            button.transform = CGAffineTransformIdentity;
        }
    }
}

- (void)createAnotherPage
{
    self.lastPage++;
    self.scrollyView.contentSize = CGSizeMake(self.scrollyView.contentSize.width + 480.0, 300.0);
    [self updateStrobeView];
}

- (void)moveYerButt
{
    if (self.isPartying) {
        CGFloat xCoord = (arc4random() % 480);
        CGFloat yCoord = (arc4random() % 300);
        [UIView animateWithDuration:0.5f animations:^{
            self.noPrtyButt.frame = CGRectMake(xCoord, 
                                               yCoord, 
                                               self.noPrtyButt.frame.size.width, 
                                               self.noPrtyButt.frame.size.height);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(moveYerButt) withObject:nil afterDelay:0.5f];
        }];
    }
}

#pragma mark IBACTIONS
- (IBAction)tappedAwesome:(id)sender 
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    NSMutableArray *newAnimationArray = [NSMutableArray arrayWithCapacity:[self.fartbutt.animationImages count]];
    dispatch_async(queue, ^{
        float randomFloat = arc4random() % 100;
        CIContext *context = [CIContext contextWithOptions:nil];
        for (UIImage *img in self.fartbutt.animationImages) {
            CIImage *beginImage = [CIImage imageWithCGImage:[img CGImage]];
            CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                          keysAndValues: kCIInputImageKey, beginImage, 
                                @"inputIntensity", [NSNumber numberWithFloat:randomFloat], nil];
            CIImage *outputImage = [filter outputImage];
            CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
            [newAnimationArray addObject:[UIImage imageWithCGImage:cgimg]];
            CGImageRelease(cgimg);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.fartbutt stopAnimating];
            self.fartbutt.animationImages = newAnimationArray;
            [self.fartbutt startAnimating];
        });
    });
    
    UIButton *butt = (UIButton *)sender;
    butt.enabled = NO;
    [UIView animateWithDuration:1.0f animations:^{
        butt.transform = CGAffineTransformMakeScale(0.01,4000.0);
        
        CGAffineTransform scale = CGAffineTransformMakeScale(5.0, 5.0);
        CGAffineTransform rotate = CGAffineTransformMakeRotation(5.0*M_PI);
        CGAffineTransform translate = CGAffineTransformMake(.8946, .1247, .331, .78789, .359, 1.2);
        CGAffineTransform combine = CGAffineTransformConcat(translate, rotate);
        self.fartbutt.transform = CGAffineTransformConcat(combine, scale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1.0f animations:^{
            self.fartbutt.transform = butt.transform = CGAffineTransformIdentity;
            butt.enabled = YES;
        }];
    }];
}

- (IBAction)tappedPRTY:(id)sender 
{
    UIButton *butt = (UIButton *)sender;
    self.noPrtyButt.hidden = NO;
    self.isPartying = YES;
    
    [UIView animateWithDuration:0.7f animations:^{
        butt.transform = CGAffineTransformMakeScale(0.1,0.1);
        self.noPrtyButt.transform = CGAffineTransformIdentity;
    }];

    [self performSelector:@selector(partyAutoScroll) withObject:nil afterDelay:0.5f];
    [self performSelector:@selector(moveYerButt) withObject:nil afterDelay:1.0f];
    butt.transform = CGAffineTransformIdentity;
}

- (IBAction)tappedNoPRTY:(id)sender 
{
    self.isPartying = NO;
}

#pragma mark ScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //infinite scroll view!
    CGPoint currentOffset = scrollyView.contentOffset;
    if (currentOffset.x > (self.lastPage * 480)) {
        [self createAnotherPage];
    }
}

@end










