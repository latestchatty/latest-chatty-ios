// Protocol for loading notifications 

@protocol ModelLoadingDelegate <NSObject>

- (void)didFinishLoadingModels:(NSArray *)models;

@end