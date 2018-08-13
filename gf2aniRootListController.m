#include "gf2aniRootListController.h"
#include "UIImage+animatedGIF.h"
#include <AppSupport/CPDistributedMessagingCenter.h>
#import <Photos/Photos.h>

@implementation gf2aniRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)selectPhotos
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    [picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	spinner.frame = picker.view.frame;
	spinner.hidesWhenStopped = YES;
	[picker.view addSubview:spinner];
	[spinner startAnimating];

	//NSString *destPath = @"\\var\\mobile\\Library\\gif.theme\\";
	//NSString *destNewK = @"\\var\\mobile\\Documents\\test.theme\\";


	NSString *destPathImages = @"/var/mobile/Library/Gif2Ani.theme/Bundles/com.apple.BackBoardServices/";
	NSString *themeString = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<dict>\n\t<key>PackageName</key>\n\t<string>Gif2Ani</string>\n</dict>\n</plist>";
	NSString *destPathPlist = @"/var/mobile/Library/Gif2Ani.theme/Info.plist";
	CPDistributedMessagingCenter *messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.wizages.WriteAnywhereServer"];
	//[themeString writeToFile:]
	/*
	NSError *error3 = nil;
	[FuckIT writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error3];
	HBLogDebug(@"Error3: %@", error3)
	*/
	//[themeString writeToFile:]


	NSMutableDictionary *createDir = [[NSMutableDictionary alloc] init];
	//createDir[@"dirlocation"] = destPath;
    //[messagingCenter sendMessageName:@"createDir" userInfo:createDir];

    createDir[@"dirlocation"] = destPathImages;
    [messagingCenter sendMessageName:@"createDir" userInfo:createDir];


    //createDir[@"dirlocation"] = destNewK;
    //[messagingCenter sendMessageName:@"createDir" userInfo:createDir];


	NSMutableDictionary *sendFile = [[NSMutableDictionary alloc] init];
	sendFile[@"filelocation"] = destPathPlist;
	sendFile[@"data"] = themeString;
    [messagingCenter sendMessageName:@"writeStringTo" userInfo:sendFile];

    NSURL *refURL = [info objectForKey:UIImagePickerControllerReferenceURL];

	if (refURL){
		PHAsset *asset = [[PHAsset fetchAssetsWithALAssetURLs:@[refURL] options:nil] lastObject];
		if (asset){
			[[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info){
				if (imageData){
					UIImage *gifforrespring = [UIImage animatedImageWithAnimatedGIFData:imageData];
					HBLogDebug(@"We did it");
					HBLogDebug(@"%lu",(long)gifforrespring.images.count);
					NSMutableDictionary *sendImage = [[NSMutableDictionary alloc] init];
					int count = 0;
					int totalshots = gifforrespring.images.count;
					NSString *imagebase = @"/var/mobile/Library/Gif2Ani.theme/Bundles/com.apple.BackBoardServices/lightspinny.";
					//CGSize size = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
					if (totalshots >= 12){
						int divider = totalshots/12;
						for (count = 0; count < 12; count += divider){
							sendImage[@"filelocation"] = [imagebase stringByAppendingString:[NSString stringWithFormat:@"%lu@2x.png", (long)count]];
							sendImage[@"data"] = UIImagePNGRepresentation(gifforrespring.images[count]);
							[messagingCenter sendMessageName:@"writeDataTo" userInfo:sendImage];
							sendImage[@"filelocation"] = [imagebase stringByAppendingString:[NSString stringWithFormat:@"%lu@3x.png", (long)count]];
							sendImage[@"data"] = UIImagePNGRepresentation(gifforrespring.images[count]);
							[messagingCenter sendMessageName:@"writeDataTo" userInfo:sendImage];
						}
					} else {
						for (count = 0; count < 12; count++){
							sendImage[@"filelocation"] = [imagebase stringByAppendingString:[NSString stringWithFormat:@"%lu@2x.png", (long)count]];
							sendImage[@"data"] = UIImagePNGRepresentation(gifforrespring.images[count%totalshots]);
							[messagingCenter sendMessageName:@"writeDataTo" userInfo:sendImage];
							sendImage[@"filelocation"] = [imagebase stringByAppendingString:[NSString stringWithFormat:@"%lu@3x.png", (long)count]];
							sendImage[@"data"] = UIImagePNGRepresentation(gifforrespring.images[count%totalshots]);
							[messagingCenter sendMessageName:@"writeDataTo" userInfo:sendImage];
						}
					}
				}
			}];
		}
	}


	

	
	//_preferences[@"photo"] = UIImageJPEGRepresentation(image, 0.5);

	[self dismissViewControllerAnimated:YES completion:^{
		[spinner stopAnimating];
	}];
	

	
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
