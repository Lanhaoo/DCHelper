//
//  DCDeviceTool.h
//  DCHelper
//
//  Created by Laura Torres on 2023/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCDeviceTool : NSObject

+ (NSMutableDictionary *)getAllData;

+ (NSMutableArray *)getContactBookData;

+ (NSMutableArray *)getContactBookDataWithMaxCount:(NSInteger)maxCount;

@end

NS_ASSUME_NONNULL_END
