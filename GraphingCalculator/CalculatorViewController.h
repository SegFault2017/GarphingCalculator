//
//  ViewController.h
//  Calculator
//
//  Created by Raymond Tan on 2017-04-30.
//  Copyright © 2017 Raymond Tan. All rights reserved.
//

#import <UIKit/UIKit.h>//import all the IOS interface classes

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *description;
@property (weak, nonatomic) IBOutlet UILabel *display;//hook this to the text label


//a pointer to a UIlabel

//An outlet is just a property of our controller through
//which we can talk to an element in our view
//a strong ointer means the UILabel will stick around until we are done using
//the UILabel
//A weak pointer means the UILabel will only stick around as long as somebody
//else has a strong pointer points to it.
//As so as no one else has a strong pointer to an object we have a weak pointer
//to, that object will go away and our pointer will be cleared.

//Since the window alredy has a strong pointer point to it, weak is a good choice

@end

