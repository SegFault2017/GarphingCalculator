//
//  GraphingViewController.h
//  GraphingCalculator
//
//  Created by Raymond Tan on 2017-05-07.
//  Copyright © 2017 Raymond Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphingViewController : UIViewController <UISplitViewControllerDelegate>
@property (nonatomic,strong) NSArray *stack; // we need the program to display the graph
@end
