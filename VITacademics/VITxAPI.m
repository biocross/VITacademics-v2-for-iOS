//
//  VITxAPI.m
//  Test2
//
//  Created by Siddharth Gupta on 5/21/13.
//  Copyright (c) 2013 Siddharth Gupta. All rights reserved.
//

#import "VITxAPI.h"


@implementation VITxAPI

-(NSString *)loadAttendanceWithRegistrationNumber: (NSString *)registrationNumber andDateOfBirth: (NSString *)dateOfBirth{
    
    NSString *buildingUrl = [NSString stringWithFormat:@"http://vitacademicsrel.appspot.com/attj/%@/%@", registrationNumber, dateOfBirth];
    NSURL *url = [NSURL URLWithString:buildingUrl];
    NSError *error = nil;
    NSString *text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    
    if(!text){
        NSLog(@"Error = %@", error);
        return @"networkerror";
    }
    else{
        return text;
    }
}

-(NSString *)loadMarksWithRegistrationNumber: (NSString *)registrationNumber andDateOfBirth: (NSString *) dateOfBirth{
    NSString *buildingUrl = [NSString stringWithFormat:@"http://vitacademicsrel.appspot.com/marks/%@/%@", registrationNumber, dateOfBirth];
    NSURL *url = [NSURL URLWithString:buildingUrl];
    NSError *error = nil;
    NSString *text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    
    if(!text){
        NSLog(@"Error = %@", error);
        return @"networkerror";
    }
    else{
        return text;
    }
}

-(int)checkServerStatus{
    NSString *buildingUrl = [NSString stringWithFormat:@"http://vitacademicsrel.appspot.com"];
    NSURL *url = [NSURL URLWithString:buildingUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSError * error = nil;
    NSURLResponse * response = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    NSLog(@"%@", [data description]);
    
    NSInteger httpCode = [(NSHTTPURLResponse *)response statusCode];
    
    if(!httpCode){
        return 0;
    }
    return httpCode;
    
}

-(UIImage *)loadCaptchaIntoImageView{
    
    NSString *registrationNumber;
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if([preferences stringForKey:@"registrationNumber"]){
        registrationNumber = [preferences stringForKey:@"registrationNumber"];
    }
    else{
        registrationNumber = @"Blank";
    }
    
    id path =@"http://vitacademicsrel.appspot.com/captcha/";
    NSString *finalURL = [path stringByAppendingString:registrationNumber];
    NSURL * url= [NSURL URLWithString:finalURL];
    
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    
    
    if (!data){
        NSLog(@"Failed to load the captcha.");
        UIImage *img = [UIImage imageNamed:@"captchaError"];
        return img;
    }
    else{
        UIImage * img = [[UIImage alloc] initWithData:data];
        return img;
    }

}

-(NSString *)verifyCaptchaWithRegistrationNumber: (NSString *)registrationNumber andDateOfBirth: (NSString *)dateOfBirth andCaptcha:(NSString *)captcha{
    
    NSString *url = [NSString stringWithFormat:@"http://vitacademicsrel.appspot.com/captchasub/%@/%@/%@", registrationNumber, dateOfBirth, captcha];
    
    NSURL *finalUrl = [NSURL URLWithString:url];
    NSError* error = nil;
    NSString *result = [NSString stringWithContentsOfURL:finalUrl encoding:NSASCIIStringEncoding error:&error];
    
    if(!result){
        return @"networkerror";
    }
    
    return result;
}

-(NSString *)captchaLessTrasactionWith:(NSString *)registrationNumber andDateOfBirth:(NSString *)dateOfBirth{
    NSString *url = [NSString stringWithFormat:@"http://vitacademicsrel.appspot.com/captchaless/%@/%@", registrationNumber, dateOfBirth];
    
    NSURL *finalUrl = [NSURL URLWithString:url];
    NSError* error = nil;
    NSString *result = [NSString stringWithContentsOfURL:finalUrl encoding:NSASCIIStringEncoding error:&error];
    
    if(!result){
        return @"networkerror";
    }
    
    return result;
}

-(NSString *)loadTimeTableWithRegistrationNumber:(NSString *)registrationNumber andDateOfBirth:(NSString *)dateOfBirth{
    NSString *buildingUrl = [NSString stringWithFormat:@"http://vitacademicstokensystem.appspot.com/gettimetable/%@/%@", registrationNumber, dateOfBirth];
    NSURL *url = [NSURL URLWithString:buildingUrl];
    NSError *error = nil;
    NSString *text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    NSString *final;
    
    if(!text){
        NSLog(@"Error in fetching timetable [VITxAPI] = %@", error);
        //return @"networkerror";
        //final = @"networkerror"
        final = [self loadTimeTableWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
    }
    else{
        NSError *e = nil;
        NSData *ttDataFromString = [text dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: ttDataFromString options: NSJSONReadingMutableContainers error: &e];
        
        if (!jsonArray) {
            NSLog(@"Error parsing JSON: %@", e);
            NSLog(@"Inception1");
            final = [self loadTimeTableWithRegistrationNumber:registrationNumber andDateOfBirth:dateOfBirth];
        }
        else{
            final = text;
        }
        
        
    }
    
    return final;
}

@end

