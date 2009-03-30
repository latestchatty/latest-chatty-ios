// Protocols for loading notifications 

@protocol DataLoadingDelegate <NSObject>
- (id)didFinishLoadingPluralData:(id)dataObject;
- (id)didFinishLoadingData:(id)dataObject;
- (id)otherDataForResponseData:(id)responseData;
@end


@protocol ModelLoadingDelegate <NSObject>
- (void)didFinishLoadingAllModels:(NSArray *)models otherData:(id)otherData;
- (void)didFinishLoadingModel:(id)model otherData:(id)otherData;
- (void)didFailToLoadModels;
@end