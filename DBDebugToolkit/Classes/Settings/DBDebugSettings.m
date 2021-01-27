// The MIT License
//
// Copyright (c) 2016 Dariusz Bukowski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "DBDebugSettings.h"
#import "UIView+DBUserInterfaceToolkit.h"
#import "UIWindow+DBUserInterfaceToolkit.h"
#import "DBBuildInfoProvider.h"

@implementation DBDebugSettings

+ (instancetype)sharedInstance {
    static DBDebugSettings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DBDebugSettings alloc] init];
        [sharedInstance readStringFromFile];
    });
    return sharedInstance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Private methods


#pragma mark - Public methods

- (void)writeStringToFile:(NSString*)aString {
    
    // Build the path, and create if needed.
    self.buildInfoProvider = [DBBuildInfoProvider new];
    NSString* appNameVer = [self.buildInfoProvider applicationNameVer];
    
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString* fileName = [NSString stringWithFormat:@"%@%@",appNameVer,@"DBDebugSettings.json"];
    
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];

    
    //NSLog(@"%@",fileName);
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    // The main act...
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}

- (void)readStringFromFile {
    self.buildInfoProvider = [DBBuildInfoProvider new];
    NSString* appNameVer = [self.buildInfoProvider applicationNameVer];
    
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = [NSString stringWithFormat:@"%@%@",appNameVer,@"DBDebugSettings.json"];
    
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];

    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [self defaultSetting];
        return ;
    }
    // The main act...
    //NSString *saveFileData = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:fileAtPath] encoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithContentsOfFile:fileAtPath];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    [self parseAndSetSettings:dict];
    return ;
}

#pragma mark - Settings fields methods

-(void)updateWidgetEnabled:(BOOL)flag{
    
        self.widgetEnabled = flag;
        [self updateSettingsFile];
        [self.delegate dbDebugSettingsWidgetChange:flag];
    
}

-(void)updateCrashLoggingEnabled:(BOOL)flag{
    self.crashLoggingEnabled = flag;
    [self updateSettingsFile];
    [self.delegate dbDebugSettingsCrashLoggingChange:flag];
}

-(void)updateConsoleLoggingEnabled:(BOOL)flag{
    self.consoleLoggingEnabled = flag;
    [self updateSettingsFile];
    [self.delegate dbDebugSettingsConsoleLoggingChange:flag];
}

-(void)updateNetworkLoggingEnabled:(BOOL)flag{
    self.networkLoggingEnabled = flag;
    [self updateSettingsFile];
    [self.delegate dbDebugSettingsNetworkLoggingChange:flag];
}

-(void)updatePerformanceCaptureEnabled:(BOOL)flag{
    self.performanceCaptureEnabled = flag;
    [self updateSettingsFile];
    [self.delegate dbDebugSettingsPerformanceCaptureChange:flag];
}
//TRIGGERS
-(void)updateLongpressTriggerEnabled:(BOOL)flag{
    self.longpressTriggerEnabled = flag;
    [self updateSettingsFile];
    [self.delegate dbDebugSettingsLongpressTriggerChange:flag];
}

-(void)updateShakeTriggerEnabled:(BOOL)flag{
    self.shakeTriggerEnabled = flag;
    [self updateSettingsFile];
    [self.delegate dbDebugSettingsShakeTriggerChange:flag];
}

-(void)updateTapTriggerEnabled:(BOOL)flag{
    self.tapTriggerEnabled = flag;
    [self updateSettingsFile];
    [self.delegate dbDebugSettingsTapTriggerChange:flag];
}
//selected Presets
-(void)updateSelectedPresets:(NSString *)value{
    self.selectedPresets = value;
    [self updateSettingsFile];
}


-(void)defaultSetting{
   
    if(!self.performanceCaptureEnabled){
        self.performanceCaptureEnabled = true;
        [self.delegate dbDebugSettingsPerformanceCaptureChange:YES];
    }
    if(!self.networkLoggingEnabled){
        self.networkLoggingEnabled = true;
        [self.delegate dbDebugSettingsNetworkLoggingChange:YES];
    }
    if(!self.consoleLoggingEnabled){
        self.consoleLoggingEnabled = true;
        [self.delegate dbDebugSettingsConsoleLoggingChange:YES];
    }
    if(!self.crashLoggingEnabled){
        self.crashLoggingEnabled = true;
        [self.delegate dbDebugSettingsCrashLoggingChange:YES];
    }
    if(!self.widgetEnabled){
        self.widgetEnabled = YES;
        [self.delegate dbDebugSettingsWidgetChange:YES];
    }
    //addtriggers
    if(!self.longpressTriggerEnabled){
        self.longpressTriggerEnabled = false;
        [self.delegate dbDebugSettingsLongpressTriggerChange:NO];
    }
    if(self.shakeTriggerEnabled){
        self.shakeTriggerEnabled = false;
        [self.delegate dbDebugSettingsShakeTriggerChange:NO];
    }
    if(self.tapTriggerEnabled){
        self.tapTriggerEnabled = false;
        [self.delegate dbDebugSettingsTapTriggerChange:NO];
    }
    //presets
    self.selectedPresets = @"-1";
    

    [self updateSettingsFile];

}

-(void)parseAndSetSettings:(NSDictionary*)jsonDict{
    //add triggers
    self.widgetEnabled = [[jsonDict objectForKey:@"widgetEnabled"] boolValue];
    self.crashLoggingEnabled = [[jsonDict objectForKey:@"crashLoggingEnabled"] boolValue];
    self.consoleLoggingEnabled = [[jsonDict objectForKey:@"consoleLoggingEnabled"] boolValue];
    self.networkLoggingEnabled = [[jsonDict objectForKey:@"networkLoggingEnabled"] boolValue];
    self.performanceCaptureEnabled = [[jsonDict objectForKey:@"performanceCaptureEnabled"] boolValue];
    //triggers
    self.longpressTriggerEnabled = [[jsonDict objectForKey:@"longpressTriggerEnabled"] boolValue];
    self.shakeTriggerEnabled = [[jsonDict objectForKey:@"shakeTriggerEnabled"] boolValue];
    self.tapTriggerEnabled = [[jsonDict objectForKey:@"tapTriggerEnabled"] boolValue];
    //presetValues
    self.selectedPresets = [jsonDict objectForKey:@"selectedPresets"];
}

-(void)updateSettingsFile{
    
    //addtriggers
    // Dictionary with several kay/value pairs and the above array of arrays
    NSDictionary *dict = @{@"widgetEnabled" : [self boolValToStr:self.widgetEnabled],
                           @"crashLoggingEnabled" : [self boolValToStr:self.crashLoggingEnabled],
                           @"consoleLoggingEnabled" : [self boolValToStr:self.consoleLoggingEnabled],
                           @"networkLoggingEnabled" : [self boolValToStr:self.networkLoggingEnabled],
                           @"performanceCaptureEnabled" : [self boolValToStr:self.performanceCaptureEnabled],
                           //Triggers
                           @"longpressTriggerEnabled" : [self boolValToStr:self.longpressTriggerEnabled],
                           @"shakeTriggerEnabled" : [self boolValToStr:self.shakeTriggerEnabled],
                           @"tapTriggerEnabled" : [self boolValToStr:self.tapTriggerEnabled],
                           //selectedPresets
                           @"selectedPresets" : self.selectedPresets};
    
    NSError *error = nil;
    NSData *json;
    
    // Dictionary convertable to JSON ?
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        // Serialize the dictionary
        json = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        
        // If no errors, let's view the JSON
        if (json != nil && error == nil)
        {
            NSString *jsonString = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            
            //NSLog(@"JSON: %@", jsonString);
            [self writeStringToFile:jsonString];
            //[jsonString release];
        }
    }
}

- (NSString *)settingsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"DBDebugToolkit"];
}

- (NSString *)boolValToStr:(BOOL)theBool {
    if (theBool == 0)
        return @"NO"; // can change to No, NOOOOO, etc
    else
        return @"YES"; // can change to YEAH, Yes, YESSSSS etc
}

- (void)autolayoutTrace {
    //NSLog(@"ONE");
}

- (void)viewDescription:(UIView *)view {
    
}

- (void)viewControllerHierarchy {
   
}

#pragma mark - Handling flags

- (void)setSlowAnimationsEnabled:(BOOL)slowAnimationsEnabled {
    
}

- (void)setSpeedForWindow:(UIWindow *)window {
  
}

- (void)setColorizedViewBordersEnabled:(BOOL)colorizedViewBordersEnabled {
  
}

- (void)setShowingTouchesEnabled:(BOOL)showingTouchesEnabled {
    
}

- (void)setShowingTouchesEnabledForWindow:(UIWindow *)window {
    
}



@end

