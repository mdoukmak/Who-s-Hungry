//
//  FirstViewController.m
//  WhosHungry
//
//  Created by Muhammad Doukmak on 11/21/14.
//  Copyright (c) 2014 Muhammad Doukmak. All rights reserved.
//

#import "FirstViewController.h"
#import <AddressBook/AddressBook.h>
#import "InviteViewController.h"

@interface FirstViewController ()
@property NSMutableArray *totalNumbers;
@end

@implementation FirstViewController
- (IBAction)userIsHungry:(UIButton *)sender {
   }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CFErrorRef * error = NULL;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
 {
     if (granted)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
             CFIndex numberOfPeople = ABAddressBookGetPersonCount(addressBook);
             NSLog(@"Number of people: %ld", numberOfPeople);
             for(int i = 0; i < numberOfPeople; i++){
                 ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
                 ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
                 
                 for (CFIndex i = 0; i < ABMultiValueGetCount(phoneNumbers); i++) {
                     NSString *phoneNumber = (__bridge_transfer NSString *) ABMultiValueCopyValueAtIndex(phoneNumbers, i);
                     [_totalNumbers addObject:phoneNumber];
                     NSLog(@"Current number:%@", phoneNumber);
                 }
             }
         });
     }
 }
                                             
   NSLog(@"Total numbers[0]: %@", [_totalNumbers objectAtIndex:0]);
 );
    //NSLog(@"Total numbers[0]: %@", [_totalNumbers objectAtIndex:0]);
    InviteViewController *ivc = [segue destinationViewController];
    [ivc setContactNumbers:_totalNumbers];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
