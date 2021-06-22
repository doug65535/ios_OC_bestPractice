//
//  AppDelegate.h
  
//
//  Created by lucifer on 16/7/21.
 
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    BMKMapManager* _mapManager;
    
    UINavigationController *navigationController;
        
}

@property (strong, nonatomic) UIWindow *window;




@end

