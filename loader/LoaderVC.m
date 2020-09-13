/**
  * GreenPois0n Medicine - LoaderVC.m
  * Copyright (C) 2010 Chronic-Dev Team
  * Copyright (C) 2010 Nicolas Haunold
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation, either version 3 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **/

#import "LoaderVC.h"
#import "UIProgressHUD.h"
#import <unistd.h> 
#import "untar.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@interface UIDevice (LoaderExt) 
- (BOOL)isWildcat;
@end

@implementation LoaderVC

- (void)addHUDWithText:(NSString *)text {
	[self.view setUserInteractionEnabled:NO];
	[_myHud setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	[_myHud setText:text];
	[_myHud showInView:[[UIApplication sharedApplication] keyWindow]];
}

- (void)removeHUD {
	[_myHud hide];
	[self.view setUserInteractionEnabled:YES];
}

- (void)showOptions:(id)sender {
	// sigh
	UIActionSheet *_ = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Loader.app" otherButtonTitles:nil];
	[_ setTag:0x8BAA];
	[_ showInView:self.view];
	[_ release];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initView];
	// Loading Sources
}

- (void)initView {
	UIColor *bgcolor = [[UIColor alloc]initWithRed:246.0/255.0 green:246.0/255.0 blue:256.0/255.0 alpha:1.0];
	UIColor *textcolor = [[UIColor alloc]initWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0];
	UIColor *circ1c = [[UIColor alloc]initWithRed:179.0/255.0 green:93.0/255.0 blue:76.0/255.0 alpha:1.0];
	UIColor *circ2c = [[UIColor alloc]initWithRed:128.0/255.0 green:159.0/255.0 blue:168.0/255.0 alpha:1.0];
	self.view.backgroundColor = bgcolor;
	self.view.clipsToBounds = YES;
 	CAShapeLayer *circle1 = [CAShapeLayer layer];
	CAShapeLayer *circle2 = [CAShapeLayer layer];
    
    [circle1 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-self.view.frame.size.height/6, -self.view.frame.size.height/6, self.view.frame.size.height/3, self.view.frame.size.height/3)] CGPath]];
	[circle2 setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.view.frame.size.width-self.view.frame.size.height/6, self.view.frame.size.height-self.view.frame.size.height/6, self.view.frame.size.height/3, self.view.frame.size.height/3)] CGPath]];

	circle1.fillColor = circ1c.CGColor;
	circle2.fillColor = circ2c.CGColor;
    
    [[self.view layer] addSublayer:circle1];
	[[self.view layer] addSublayer:circle2];
    CGFloat lmvr = 0.0;
    
    int *version = [[[UIDevice currentDevice] systemVersion] intValue];
    if(version <= 6) {
        lmvr = 25.0;
    }
	UILabel *dec_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width-20, (self.view.frame.size.height/6) + lmvr)];
	[dec_label setFont:[UIFont fontWithName:@"MazzardM-Bold" size:self.view.frame.size.height/12]];
    dec_label.backgroundColor = [UIColor clearColor];
    dec_label.textAlignment = UITextAlignmentRight;
    dec_label.textColor = textcolor;
    dec_label.numberOfLines = 0;
    dec_label.lineBreakMode = UILineBreakModeWordWrap;
    dec_label.text = @"Deca5\nJailbreak";
    [self.view addSubview:dec_label];
	

	jbbutton = [UIButton buttonWithType:UIButtonTypeCustom];

	jbbutton.backgroundColor = [UIColor blackColor];

	[jbbutton addTarget:self action:@selector(installCydia:) forControlEvents:UIControlEventTouchUpInside];
	jbbutton.frame = CGRectMake(0, 0, self.view.frame.size.height/12, self.view.frame.size.height/12);
	jbbutton.center = CGPointMake(self.view.frame.size.width/2,
                                       self.view.frame.size.height/2 - 20);
	jbbutton.clipsToBounds = YES;

	jbbutton.layer.cornerRadius = (self.view.frame.size.height/12)/2.0f;
	[jbbutton setTitle:@"J" forState:UIControlStateNormal];

	[self.view addSubview:jbbutton];
	jblabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.width/2 + 90, self.view.frame.size.width, self.view.frame.size.height/6)];
	[jblabel setFont:[UIFont fontWithName:@"MazzardM-Medium" size:20]];
    jblabel.backgroundColor = [UIColor clearColor];
    jblabel.textAlignment = UITextAlignmentCenter;
    jblabel.textColor = [UIColor blackColor];
    jblabel.numberOfLines = 0;
    jblabel.lineBreakMode = UILineBreakModeWordWrap;
    jblabel.text = @"Jailbreak";
    [self.view addSubview:jblabel];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

// -------
// Loader Delegates

- (void)dealloc {
	if(_sourceDict) [_sourceDict release];
	
	[_queue release];
	[_myHud release];
	[super dealloc];
}

-(void) installCydia:(UIButton*)sender
 {
	 _myHud = [[UIProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication] keyWindow]];
	[self addHUDWithText:@"Installing Cydia..."];
	jbbutton.hidden = YES;
	jblabel.hidden = YES;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
	int *version = [[[UIDevice currentDevice] systemVersion] intValue];
	NSString *path = [NSString stringWithFormat: @"/Applications/Jailbreak.app/Cydia-%d.tar", version];
	char *cpath = [path UTF8String];
	NSLog(@"%@", path); 
	untar(cpath, "/");
	system("/bin/su -c /usr/bin/uicache mobile");	
	[_myHud setText:@"Done! Rebooting..."];
	sleep(2);
	reboot(1);

	});
 }





@end
