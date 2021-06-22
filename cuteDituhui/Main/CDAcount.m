//
//  CDAcount.m
  
//
//  Created by lucifer on 16/7/21.
 
//

#import "CDAcount.h"


#import <objc/runtime.h>
#import <objc/message.h>

#import "NSString+Dir.h"

@implementation CDAcount

#define CDAccountFileName @"account.data"
MJCodingImplementation


-(BOOL)save
{

    NSString *accountPath = [CDAccountFileName appendDocumentDir];
    
    BOOL flag = [NSKeyedArchiver archiveRootObject:self toFile:accountPath];
    
    CDLog(@"%tu",flag);

    return [NSKeyedArchiver archiveRootObject:self toFile:accountPath];
}

+ (instancetype)accountFromSandbox
{

    NSString *accountPath = [CDAccountFileName appendDocumentDir];
    

    CDAcount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:accountPath];
    

    return account;
    
}


@end
