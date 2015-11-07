#import "Cordova/CDV.h"
#import "Cordova/CDVViewController.h"
#import "UIKit/UITouch.h"
#import "ThreeDeeTouch.h"

@implementation ThreeDeeTouch

- (void) deviceIsReady:(CDVInvokedUrlCommand *)command {
  self.initDone = YES;
}

- (void) isAvailable:(CDVInvokedUrlCommand *)command {

  bool avail = NO;

  if (IsAtLeastiOSVersion(@"9")) {
    avail = [self.viewController.traitCollection forceTouchCapability] == UIForceTouchCapabilityAvailable;
  }

  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:avail];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void) enableLinkPreview:(CDVInvokedUrlCommand *)command {
  self.webView.allowsLinkPreview = YES;
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void) disableLinkPreview:(CDVInvokedUrlCommand *)command {
  self.webView.allowsLinkPreview = NO;
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (void) configureQuickActions:(CDVInvokedUrlCommand *)command {
  NSDictionary *actions = [command.arguments objectAtIndex:0];
  
  NSMutableArray *items = [[NSMutableArray alloc] init];

  for (NSDictionary *action in actions) {
    NSString *type = [action objectForKey:@"type"];
    NSString *title = [action objectForKey:@"title"];
    NSString *subtitle = [action objectForKey:@"subtitle"];
    NSString *iconType = [action objectForKey:@"iconType"];
    NSString *iconTemplate = [action objectForKey:@"iconTemplate"];

    UIApplicationShortcutIcon *icon = nil;
    if (iconType != nil) {
      icon = [UIApplicationShortcutIcon iconWithType:[self UIApplicationShortcutIconTypeFromString:[iconType lowercaseString]]];
    } else if (iconTemplate != nil) {
      icon = [UIApplicationShortcutIcon iconWithTemplateImageName:iconTemplate];
    }

    [items addObject:[[UIApplicationShortcutItem alloc]initWithType: type localizedTitle: title localizedSubtitle: subtitle icon: icon userInfo: nil]];
  }

  [UIApplication sharedApplication].shortcutItems = items;
  [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK] callbackId:command.callbackId];
}

- (UIApplicationShortcutIconType) UIApplicationShortcutIconTypeFromString:(NSString*)str {
// iOS 9.0 icons:
       if ([str isEqualToString:@"compose"])       return UIApplicationShortcutIconTypeCompose;
  else if ([str isEqualToString:@"play"])          return UIApplicationShortcutIconTypePlay;
  else if ([str isEqualToString:@"pause"])         return UIApplicationShortcutIconTypePause;
  else if ([str isEqualToString:@"add"])           return UIApplicationShortcutIconTypeAdd;
  else if ([str isEqualToString:@"location"])      return UIApplicationShortcutIconTypeLocation;
  else if ([str isEqualToString:@"search"])        return UIApplicationShortcutIconTypeSearch;
  else if ([str isEqualToString:@"share"])         return UIApplicationShortcutIconTypeShare;

// iOS 9.1 icons:
#ifdef __IPHONE_9_1
  else if ([str isEqualToString:@"prohibit"])      return UIApplicationShortcutIconTypeProhibit;
  else if ([str isEqualToString:@"contact"])       return UIApplicationShortcutIconTypeContact;
  else if ([str isEqualToString:@"home"])          return UIApplicationShortcutIconTypeHome;
  else if ([str isEqualToString:@"marklocation"])  return UIApplicationShortcutIconTypeMarkLocation;
  else if ([str isEqualToString:@"favorite"])      return UIApplicationShortcutIconTypeFavorite;
  else if ([str isEqualToString:@"love"])          return UIApplicationShortcutIconTypeLove;
  else if ([str isEqualToString:@"cloud"])         return UIApplicationShortcutIconTypeCloud;
  else if ([str isEqualToString:@"invitation"])    return UIApplicationShortcutIconTypeInvitation;
  else if ([str isEqualToString:@"confirmation"])  return UIApplicationShortcutIconTypeConfirmation;
  else if ([str isEqualToString:@"mail"])          return UIApplicationShortcutIconTypeMail;
  else if ([str isEqualToString:@"message"])       return UIApplicationShortcutIconTypeMessage;
  else if ([str isEqualToString:@"date"])          return UIApplicationShortcutIconTypeDate;
  else if ([str isEqualToString:@"time"])          return UIApplicationShortcutIconTypeTime;
  else if ([str isEqualToString:@"capturephoto"])  return UIApplicationShortcutIconTypeCapturePhoto;
  else if ([str isEqualToString:@"capturevideo"])  return UIApplicationShortcutIconTypeCaptureVideo;
  else if ([str isEqualToString:@"task"])          return UIApplicationShortcutIconTypeTask;
  else if ([str isEqualToString:@"taskcompleted"]) return UIApplicationShortcutIconTypeTaskCompleted;
  else if ([str isEqualToString:@"alarm"])         return UIApplicationShortcutIconTypeAlarm;
  else if ([str isEqualToString:@"bookmark"])      return UIApplicationShortcutIconTypeBookmark;
  else if ([str isEqualToString:@"shuffle"])       return UIApplicationShortcutIconTypeShuffle;
  else if ([str isEqualToString:@"audio"])         return UIApplicationShortcutIconTypeAudio;
  else if ([str isEqualToString:@"update"])        return UIApplicationShortcutIconTypeUpdate;
#endif

  else {
    NSLog(@"Invalid iconType passed to the 3D Touch plugin. So not adding one.");
    return 0;
  }
}
@end