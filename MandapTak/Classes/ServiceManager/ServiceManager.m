//
//  ServiceManager.m
//  Giddh
//
//  Created by Admin on 15/04/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ServiceManager.h"
#import "Location.h"
#define domainName @"http://giddh.com/api/"
@implementation ServiceManager

SYNTHESIZE_SINGLETON_METHOD(ServiceManager, sharedManager);

-(void)getLocationFromCityInput:(NSString*)input withCompletionBlock:(LocationCompletionBlock)completionBlock{

    NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=%@&types=(cities)&input=%@",@"AIzaSyC9K13OuB5DkOglwas3dT08KcamgqNanhA",input];
    NSLog(@"%@",strUrl);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]]];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error) {
            NSDictionary *responce=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"%@",responce);
            NSMutableArray *arrLocation = [NSMutableArray array];
            NSArray *arrPrediction = [responce valueForKey:@"predictions"];
            for(NSDictionary *dictLocation in arrPrediction){
                Location *location = [[Location alloc]init];
                NSArray * arrTerms = [dictLocation valueForKey:@"terms"];
                location.descriptions = [dictLocation valueForKey:@"description"];
                location.placeId = [dictLocation valueForKey:@"place_id"];

                if(arrTerms.count==3){
                    NSDictionary *cityDict = [arrTerms objectAtIndex:0];
                    NSDictionary *stateDict = [arrTerms objectAtIndex:1];
                    NSDictionary *countryDict = [arrTerms objectAtIndex:2];
                    location.state = [stateDict valueForKey:@"value"];
                    location.city = [cityDict valueForKey:@"value"];
                    location.country = [countryDict valueForKey:@"value"];
                    [arrLocation addObject:location];
                }
                
            }
            completionBlock (arrLocation,nil);
        }
        else {
            completionBlock (nil,error);
        }
    }];

}
-(void)FetchPhotosUsingUserId:(NSString*)userId withPicId:(NSString*)picId withCompletionBlock:(FbPhotosCompletionBlock)completionBlock{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",picId]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (!error) {
            NSDictionary *responce=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                       completionBlock (responce,nil);
        }
        else {
            completionBlock (nil,error);
        }
    }];

}

@end
