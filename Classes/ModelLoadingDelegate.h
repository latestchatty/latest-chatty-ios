// Protocols for loading notifications 

@protocol DataLoadingDelegate <NSObject>
- (id)didFinishLoadingPluralData:(id)dataObject;
- (id)didFinishLoadingData:(id)dataObject;
@end


@protocol ModelLoadingDelegate <NSObject>
- (void)didFinishLoadingAllModels:(NSArray *)models;
- (void)didFinishLoadingModel:(id)model;
@end