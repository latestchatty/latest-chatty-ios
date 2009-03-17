// Protocol for loading notifications 

@protocol ModelLoadingDelegate

- (void)didFinishLoadingModels:(NSArray *)models;

@end