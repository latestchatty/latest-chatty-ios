// Protocols for loading notifications 

@protocol DataLoadingDelegate <NSObject>
@optional
- (id)didFinishLoadingPluralData:(id)dataObject;
- (id)didFinishLoadingData:(id)dataObject;
- (id)otherDataForResponseData:(id)responseData;
@end


@protocol ModelLoadingDelegate <NSObject>
@optional
- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData;
- (void)didFinishLoadingModel:(id)model otherData:(id)otherData;
- (void)didFailToLoadModels;
@end