//
//  AmazingAudioReact.m
//  AmazingAudioReact
//
//  Created by Joe Wood on 4/25/15.
//  Copyright (c) 2015 Joe Wood. All rights reserved.
//

#import "AmazingAudio.h"


#import "NativeAudio.h"
#import <AVFoundation/AVAudioSession.h>


#import "RCTLog.h"
//#import "TheAmazingAudioEngine.h"
#import "RCTUtils.h"


@interface AmazingAudioReact ()

@end


@implementation AmazingAudioReact {
    AVAudioSession *_audioController;
  //  NSMutableDictionary *_callbacks;
    NSMutableDictionary *_data;
    NSMutableDictionary *_audioMapping;
    NSDictionary *_initError;
}
RCT_EXPORT_MODULE();




- (instancetype)init
{
    NSLog(@"Initializing Audio");
    self = [super init];
    if (self) {
        _data = [[NSMutableDictionary alloc] init];
        _audioMapping = [[NSMutableDictionary alloc] init];

//        _audioController = [[AEAudioController alloc]
//                            initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription]
//                            inputEnabled:NO]; // don't forget to autorelease if you don't use ARC!
//        NSError *error = NULL;
//        BOOL result = [_audioController start:&error];
//        if ( !result ) {
//            NSLog(@"Error Initiatizing Audio");
//            _initError = RCTMakeError(@"Cannot Initialize", error,nil);
//        } else {
//            NSLog(@"Amazing Audio Initialized.");
//            _initError = nil;
//        }
    }
    return self;
}




RCT_EXPORT_METHOD(initAudioContext:(RCTResponseSenderBlock)callback) {
    
    AudioSessionInitialize(NULL, NULL, nil , nil);
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
    
    // Allows the application to mix its audio with audio from other apps.
    if (![session setCategory:AVAudioSessionCategoryAmbient
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
        
        NSLog (@"Error setting audio session category.");
        return;
    }
    
    [session setActive: YES error: nil];
}



- (bool)checkError:(RCTResponseSenderBlock)callback {
    if (_initError && _audioController) callback(@[_initError]);
    return (!!_initError);
}


RCT_EXPORT_METHOD(waveLoadUrl:(NSString *)url  callback:(RCTResponseSenderBlock)callback)  {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data==nil) {
         callback(@[RCTMakeError(@"File does not exist", nil, @{@"url":url})]);
         return;
    }
    _data[RCTKeyForInstance(data)] = data;
        
        //    if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
        
//        NSURL *pathURL = [NSURL fileURLWithPath : path];
//        CFURLRef soundFileURLRef = (CFURLRef) CFBridgingRetain(pathURL);
//        SystemSoundID soundID;
//        AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
//        _audioMapping[audioID] = [NSNumber numberWithInt:soundID];

        callback(@[[NSNull null],@{
                       @"handle":RCTKeyForInstance(data),
//                       @"duration":[NSString stringWithFormat:@"%lf",loop.duration]
                       }]);
};

RCT_EXPORT_METHOD(waveUnloadUrl:(NSString *)handle  callback:(RCTResponseSenderBlock)callback)  {
    NSData* data = _data[handle];
    if (data==nil) {
        callback(@[RCTMakeError(@"Cannot find wave", nil, @{@"handle":handle})]);
    }
    [_data removeObjectForKey: handle];
    callback(@[[NSNull null],@{@"handle":handle}]);
}
                    
RCT_EXPORT_METHOD(waveList:(NSString *)handle  callback:(RCTResponseSenderBlock)callback)  {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    for (NSData* key in _data) {
        [array addObject:RCTKeyForInstance(key)];
    }
    callback(@[[NSNull null],@{@"handles":array}]);
}
                    
                    /*
                    
RCT_EXPORT_METHOD(waveUnloadUrl:(NSString *)loopKey  callback:(RCTResponseSenderBlock)callback)  {

//    NSString *callbackId = command.callbackId;
//    NSArray* arguments = command.arguments;
//    NSString *audioID = [arguments objectAtIndex:0];
    
    if ( !_audioMapping ) {
        callback(@[RCTMakeError(@"Not initialized", nil, @{@"handle":loopKey})]); 
    }
    NSObject* asset = audioMapping[audioID];
    
    if (asset == nil){
        callback(@[RCTMakeError(@"Cannot find loop", nil, @{@"handle":loopKey})]); 
        return;
    }
    
    if ([asset isKindOfClass:[NativeAudioAsset class]]) {
        NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
        [_asset unload];
    } else if ( [asset isKindOfClass:[NSNumber class]] ) {
        NSNumber *_asset = (NSNumber*) asset;
        AudioServicesDisposeSystemSoundID([_asset intValue]);
    }
    _audioMapping removeObjectForKey: audioID];*/
//    callback(@[[NSNull null],@{@"handle":loopKey}]);
//};


RCT_EXPORT_METHOD(play:(NSString *)loopKey options:(NSDictionary*)options callback:(RCTResponseSenderBlock)callback) {
    if (_initError) { callback(@[_initError]); return; }

    AVAudioPlayer *player = [[AVAudioPlayer alloc] in
    
    NSString *audioID = loopKey;
    NSObject* asset = audioMapping[audioID];
    
    if (asset == nil){
        callback(@[RCTMakeError(@"Cannot find loop", nil, @{@"handle":loopKey})]); 
        return;
    }
    
    NSNumber *_asset = (NSNumber*) asset;
    AudioServicesPlaySystemSound([_asset intValue]);

                    


//     if (!_audioController) { callback(@[RCTMakeError(@"Not intialized no audioController", @{@"handle":loopKey}, nil)]); return; }
//     NSLog(@"Playing Loop %@",loopKey);
//     AEAudioFilePlayer *loop = _loops[loopKey];
//     if (!loop) { callback(@[RCTMakeError(@"Cannot find loop", nil, @{@"handle":loopKey})]); return; }
// 
//     loop.removeUponFinish = YES;
//     loop.loop = !!options[@"loop"];
//     if (options[@"volume"]) loop.volume = [options[@"volume"] floatValue];
//     if (options[@"currentTime"]) loop.currentTime = [options[@"currentTime"] floatValue];
   // if (options[@"duration"]) loop.duration = [options[@"duration"] floatValue];
    
    loop.completionBlock = ^{
        callback(@[[NSNull null],@{@"handle":loopKey}]);
    };
    [_audioController addChannels:@[loop]];
}


RCT_EXPORT_METHOD(update:(NSString *)loopKey options:(NSDictionary*)options callback:(RCTResponseSenderBlock)callback) {
    if (_initError) { callback(@[_initError]); return; }
    if (!_audioController) { callback(@[RCTMakeError(@"Not intialized no audioController", @{@"handle":loopKey}, nil)]); return; }
    AEAudioFilePlayer *loop = _loops[loopKey];
    if (!loop) { callback(@[RCTMakeError(@"Cannot find loop", @{@"handle":loopKey}, nil)]); }
    if (options[@"volume"]) loop.volume = [options[@"volume"] floatValue];
    callback(@[[NSNull null],@{@"handle":loopKey, @"currentTime":[NSString stringWithFormat:@"%lf",[loop currentTime]]}]);
}
    

RCT_EXPORT_METHOD(stop:(NSString *)loopKey callback:(RCTResponseSenderBlock)callback) {
    if (_initError) { callback(@[_initError]); return; }
    if (!_audioController) { callback(@[RCTMakeError(@"Not intialized no audioController", @{@"handle":loopKey}, nil)]); return; }
    AEAudioFilePlayer *loop = _loops[loopKey];
    if (!loop) { callback(@[RCTMakeError(@"Cannot find loop", @{@"handle":loopKey}, nil)]); }
    [_audioController removeChannels:@[loop]];
    callback(@[[NSNull null],@{@"handle":loopKey, @"currentTime":[NSString stringWithFormat:@"%lf",[loop currentTime]]}]);
}


static NSString *RCTKeyForInstance(id instance)
{
    return [NSString stringWithFormat:@"%p", instance];
}
                 
                 
                 
@end







- (void) stop:(CDVInvokedUrlCommand *)command
{
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];
    
    if ( audioMapping ) {
        NSObject* asset = audioMapping[audioID];
        
        if (asset != nil){
            
            if ([asset isKindOfClass:[NativeAudioAsset class]]) {
                NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
                // Music assets are faded out
                [_asset stopWithFade];
                
                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", INFO_PLAYBACK_STOP, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: RESULT] callbackId:callbackId];
                
            } else if ( [asset isKindOfClass:[NSNumber class]] ) {
                
                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_TYPE_RESTRICTED, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
                
            }
            
        } else {
            
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    } else {
        NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];    }
}

- (void) loop:(CDVInvokedUrlCommand *)command
{
    
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];
    
    
    if ( audioMapping ) {
        NSObject* asset = audioMapping[audioID];
        
        if (asset != nil){
            
            
            if ([asset isKindOfClass:[NativeAudioAsset class]]) {
                NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
                [_asset loop];
                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", INFO_PLAYBACK_LOOP, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: RESULT] callbackId:callbackId];
                
            } else if ( [asset isKindOfClass:[NSNumber class]] ) {
                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_TYPE_RESTRICTED, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
            }
            
            else {
                
                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
            }
        } else {
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        };
    }
}

- (void) unload:(CDVInvokedUrlCommand *)command
{
    
    
}

- (void) setVolumeForComplexAsset:(CDVInvokedUrlCommand *)command
{
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];
    NSNumber *volume = nil;
    
    if ( [arguments count] > 1 ) {
        
        volume = [arguments objectAtIndex:1];
        
        if([volume isEqual:nil]) {
            
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_VOLUME_NIL, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    } else if (([volume floatValue] < 0.0f) || ([volume floatValue] > 1.0f)) {
        
        NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_VOLUME_FORMAT, audioID];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
    }
    
    if ( audioMapping ) {
        NSObject* asset = [audioMapping objectForKey: audioID];
        
        if (asset != nil){
            
            if ([asset isKindOfClass:[NativeAudioAsset class]]) {
                NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
                [_asset setVolume:volume];
                
                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", INFO_VOLUME_CHANGED, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: RESULT] callbackId:callbackId];
                
            } else if ( [asset isKindOfClass:[NSNumber class]] ) {
                
                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_TYPE_RESTRICTED, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
                
            }
            
        } else {
            
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    } else {
        NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];    }
}

- (void) sendCompleteCallback:(NSString*)forId {
    NSString* callbackId = self->completeCallbacks[forId];
    if (callbackId) {
        NSDictionary* RESULT = [NSDictionary dictionaryWithObject:forId forKey:@"id"];
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:RESULT] callbackId:callbackId];
        [self->completeCallbacks removeObjectForKey:forId];
    }
}

static void (mySystemSoundCompletionProc)(SystemSoundID ssID,void* clientData)
{
    NativeAudio* nativeAudio = (__bridge NativeAudio*)(clientData);
    NSNumber *idAsNum = [NSNumber numberWithInt:ssID];
    NSArray *temp = [nativeAudio->audioMapping allKeysForObject:idAsNum];
    NSString *audioID = [temp lastObject];
    
    [nativeAudio sendCompleteCallback:audioID];
    
    // Cleanup, these cb are one-shots
    AudioServicesRemoveSystemSoundCompletion(ssID);
}

- (void) addCompleteListener:(CDVInvokedUrlCommand *)command
{
    NSString *callbackId = command.callbackId;
    NSArray* arguments = command.arguments;
    NSString *audioID = [arguments objectAtIndex:0];
    
    [self.commandDelegate runInBackground:^{
        if (audioMapping) {
            
            NSObject* asset = audioMapping[audioID];
            
            if (asset != nil){
                
                if(completeCallbacks == nil) {
                    completeCallbacks = [NSMutableDictionary dictionary];
                }
                completeCallbacks[audioID] = command.callbackId;
                
                if ([asset isKindOfClass:[NativeAudioAsset class]]) {
                    NativeAudioAsset *_asset = (NativeAudioAsset*) asset;
                    [_asset setCallbackAndId:^(NSString* audioID) {
                        [self sendCompleteCallback:audioID];
                    } audioId:audioID];
                    
                } else if ( [asset isKindOfClass:[NSNumber class]] ) {
                    NSNumber *_asset = (NSNumber*) asset;
                    AudioServicesAddSystemSoundCompletion([_asset intValue],
                                                          NULL,
                                                          NULL,
                                                          mySystemSoundCompletionProc,
                                                          (__bridge void *)(self));
                }
            } else {
                
                NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
                [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
            }
            
        } else {
            
            NSString *RESULT = [NSString stringWithFormat:@"%@ (%@)", ERROR_REFERENCE_MISSING, audioID];
            [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: RESULT] callbackId:callbackId];
        }
    }];
}

@end
