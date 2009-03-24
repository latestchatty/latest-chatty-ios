// Protocols for loading notifications 

@protocol ModelLoadingDelegate <NSObject>
- (void)didFinishLoadingModels:(NSArray *)models;
@end

@protocol DataLoadingDelegate <NSObject>
- (id)didFinishLoadingData:(id)dataObject;
@end
