//
//  FileOperate.m
//  beautyCamera
//
//  Created by jiemin on 13-1-15.
//
//

#import "FileOperate.h"

#import "NSStringAddition.h"
#import "ZipArchive.h"

@implementation FileOperate

//获取tmp的路径
+ (NSString *)getTemporaryPath {
    return NSTemporaryDirectory();
}

//获取Document的路径
+ (NSString *)getDocumentPath {
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[pathsArray objectAtIndex:0] stringByAppendingFormat:@"/"];
    return documentsDirectory;
}

//获取Cache目录
+ (NSString *)getCachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/"];
    //NSLog(@"%@", path);
    return path;
}
//获取文件夹路径
+ (NSString *)getDirectoryWithName:(NSString *)name fromPath: (NSString *)path{
    NSString *directory = [NSString stringWithFormat:@"%@%@/", path, name];
    return directory;
}

//文件路径
+ (NSString *)filePathWithName:(NSString *)name fromDirectory:(NSString *)directory {
    NSString *path = [NSString stringWithFormat:@"%@%@", directory, name];
    return path;
}

//保存图片， 返回图片的路径
+ (NSString *)saveImage:(UIImage *)image withName:(NSString *)name toDirectory:(NSString *)directory {
    NSString * dir = directory;
    if (image == nil ||[dir isEmptyOrWhitespace]||dir == nil) {
//        JRLogDebug(@"%@ not exist", name);
        NSLog(@"%@ not exist", name);
        dir = DOCUMENTPATH;
    }
    NSString *save_path = [NSString stringWithFormat:@"%@/%@", dir, name];
  //  NSLog(@"save_path=%@", save_path);
    BOOL success = NO;
    if ([name hasSuffix:@".png"]) {
      success =   [UIImagePNGRepresentation(image) writeToFile:save_path atomically:YES];
    }
    else if ([name hasSuffix:@".jpg"]) {
      success =  [UIImageJPEGRepresentation(image, 1.0f) writeToFile:save_path atomically:YES];
    }
    return save_path;
}

//保存图片
+ (void)writeImage:(UIImage *)image toFile:(NSString *)file {
    if (image == nil) {
        NSLog(@"writeImage not exist");
        return;
    }
    
    if ([file hasSuffix:@".png"]) {
        [UIImagePNGRepresentation(image) writeToFile:file atomically:YES];
    }
    else if ([file hasSuffix:@".jpg"]) {
        [UIImageJPEGRepresentation(image, 1.0f) writeToFile:file atomically:YES];
    }
}

//获取图片
+ (UIImage *)getImageWithName:(NSString *)name fromDirectory:(NSString *)directory {
    NSString *path = [NSString stringWithFormat:@"%@%@", directory, name];
    return [UIImage imageWithContentsOfFile:path];
}

//获取图片
+ (UIImage *)readImageWithFile:(NSString *)file {
    return [UIImage imageWithContentsOfFile:file];
}

//删除图片
+ (void)removeImageWithName:(NSString *)name fromDirectory:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path = [NSString stringWithFormat:@"%@%@", directory, name];
    //NSLog(@"path=%@", path);
    [fileManager removeItemAtPath:path error:nil];
}

//删除文件
+ (void)removeFileWithName:(NSString *)name fromDirectory:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", directory, name];
    //NSLog(@"path=%@", path);
    [fileManager removeItemAtPath:path error:nil];
}

//删除
+ (void)removeFile:(NSString *)fileName {
    [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
}

//图片是否存在
+ (BOOL)isFileExistWithName:(NSString *)name fromDirectory:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path = [NSString stringWithFormat:@"%@%@", directory, name];
    if ([fileManager fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}

//文件是否存在
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return YES;
    }
    return NO;
}

//创建目录,返回目录的路径
+ (NSString *)createDirectoryWithName:(NSString *)name toDirectory:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@", directory, name];
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    return path;
}

//获取当前目录文件列表
+ (NSArray *)contentsOfFileFromDirectory:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:directory error:nil];
    return fileArray;
}

//获取目录所有文件
+ (NSArray *)AllFileFromDirectory:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileArray = [fileManager subpathsAtPath:directory];
    return fileArray;
}

+ (NSArray *)AllFileAbsolutePathFromDirectory:(NSString *)directory {
    NSArray* filearry = [FileOperate AllFileFromDirectory:directory];
    NSMutableArray *absolutePaths = [[[NSMutableArray alloc] init] autorelease];
    
//    [filearry enumerateEachObjectUsingBlock:^(id obj){
//        [absolutePaths addObject:[NSString stringWithFormat:@"%@/%@",directory,obj]];
//    }];
    return absolutePaths;
}

//写文件
+ (void)writeData:(id)data toFilePath:(NSString *)path {
    
}

//读取文件
+ (NSString *)readStringFromFilePath:(NSString *)path {
    NSData *reader = [NSData dataWithContentsOfFile:path];
    NSString *stringData = [[[NSString alloc] initWithData:reader encoding:NSUTF8StringEncoding] autorelease];
    return stringData;
}

//移动/重命名文件
+ (void)moveSourceFile:(NSString *)srcFile toTargetFile:(NSString *)targetFile WithDirectory:(NSString *)directory {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *srcPath = [directory stringByAppendingPathComponent:srcFile];
    NSString *targetPath = [directory stringByAppendingPathComponent:targetFile];
    
   // NSLog(@"%@", srcPath);
  //  NSLog(@"%@", targetPath);
    if ([fileManager moveItemAtPath:srcPath toPath:targetPath error:&error] != YES)//判断能移动
        NSLog(@"Unable to move file: %@", [error localizedDescription]);

}

//复制文件
+ (BOOL)copySourceFile:(NSString *)srcPath toTargetFile:(NSString *)targetPath {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager copyItemAtPath:srcPath toPath:targetPath error:&error] != YES){
        NSLog(@"copy file: %@", [error localizedDescription]);
        return NO ;
    }else{
        return YES;
    }
}

//删除文件
+ (void)removeFile:(NSString *)name fromDirectory:(NSString *)directory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
     NSString *path = [directory stringByAppendingPathComponent:name];
    [fileManager removeItemAtPath:path error:nil];
}

//删除目录director下的所有文件
+ (void)removeAllFileFromDirectiory:(NSString *)directory {
    for (NSString *fileName in [FileOperate AllFileFromDirectory:directory]) {
        [FileOperate removeImageWithName:fileName fromDirectory:directory];
    }
}

//删除目录director下的所有文件
+ (void)removePuzzleAllFileFromDirectiory:(NSString *)directory {
    for (NSString *fileName in [FileOperate AllFileFromDirectory:directory]) {
        [FileOperate removeFileWithName:fileName fromDirectory:directory];
    }
}

//从app中获取文件
+ (UIImage *)getImageFromApp:(NSString *)name ofType:(NSString *)type {
    UIImage *image = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:[[NSBundle mainBundle] pathForResource:name ofType:type]])
	{
		image = [UIImage imageNamed:name];
	} 
    return image;
}

//保存到相册
+ (void)saveImageToAlbum:(UIImage *)image {
   UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

+ (BOOL)isDirectoryFromPath:(NSString*)path  {
    BOOL flag = NO;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&flag];
    if (isExist&&flag) {
        return YES;
    } else {
        return NO;
    }
}

+ (id)readObjectFromRtfFile:(NSString*)filePath
{
	id unarchiveObject = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
	return unarchiveObject;
}

+ (BOOL)saveObjectToRtfFile:(id)object savePath:(NSString*)filePath
{
	return  [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

+(BOOL)isExistValueOnUserDefautlForKey:(NSString *)findkey
{
    NSDictionary * allSettings = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    NSArray * allKeys = [allSettings allKeys];
    for(NSString * key in allKeys){
        if ([key isEqualToString:findkey]) {
            return YES;
        }
    }
    return NO;
}

+ (NSData *)readDataFromBundle:(NSString *)fileName
{
    NSString * expandedName = [fileName pathExtension];
    NSString * Name = [fileName stringByDeletingPathExtension];
    NSString *file = [[NSBundle mainBundle] pathForResource:Name ofType:expandedName];
    NSData * data = [NSData dataWithContentsOfFile:file];
    return  data;
}

+ (void)writeStringToFile:(NSString*) content path:(NSString*)path {
    NSData* Data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [Data writeToFile:path atomically:YES];
}

+ (void)compressFileFromPaths:(NSArray*)paths {
    if (paths != nil &&[paths count]>0) {
        for (NSString * path  in paths) {
            [FileOperate compressFileFromPath:path];
        }
    }
}

+ (void)compressFileFromPath:(NSString*)path {
    if (path == nil ||[path isEqualToString:@""]||![FileOperate isFileExistWithFilePath:path]) {
        return;
    }
    if ([FileOperate isDirectoryFromPath:path]) {
        [FileOperate compressFolderFromPath:path];
    } else {
        NSString *saveParentpath = [path stringByDeletingLastPathComponent];
        NSString *fileName = [[path lastPathComponent] stringByDeletingPathExtension];
        NSString * savepath = [NSString stringWithFormat:@"%@/%@.zip",saveParentpath,fileName];
        ZipArchive* zip = [[ZipArchive alloc] init];
        BOOL ret = [zip CreateZipFile2:savepath];
        ret = [zip addFileToZip:path newname:[path lastPathComponent]];
        [zip release];
    }
    
}

+ (void)compressFolderFromPath:(NSString*)path {
    
    if (path == nil ||[path isEqualToString:@""]||![FileOperate isFileExistWithFilePath:path]) {
        return;
    }
    
    NSString *saveParentpath = [path stringByDeletingLastPathComponent];
    NSString *fileName = [[path lastPathComponent] stringByDeletingPathExtension];
    NSString * savepath = [NSString stringWithFormat:@"%@/%@.zip",saveParentpath,fileName];
    NSArray * subFilepaths = [FileOperate AllFileAbsolutePathFromDirectory:path];
    ZipArchive* zip = [[ZipArchive alloc] init];
    BOOL ret = [zip CreateZipFile2:savepath];
    for (NSString * subFilepath in subFilepaths) {
        NSString *fileName = [subFilepath lastPathComponent];
        ret = [zip addFileToZip:subFilepath newname:fileName];
    }
    [zip release];
}

+ (void)decompressionFilefromPath:(NSString*)path {
    if (path == nil ||[path isEqualToString:@""]||![FileOperate isFileExistWithFilePath:path]) {
        return;
    }
    ZipArchive* zip = [[ZipArchive alloc] init];
    NSString *parentpath = [path stringByDeletingLastPathComponent];
    NSString *fileName = [[path lastPathComponent] stringByDeletingPathExtension];
    NSString * savePath = [NSString stringWithFormat:@"%@/%@",parentpath,fileName];
    if( [zip UnzipOpenFile:path] )
    {
        BOOL ret = [zip UnzipFileTo:savePath overWrite:YES];
        if( NO== ret )
        {
        }
        [zip UnzipCloseFile];
    }
    [zip release];
}

+ (BOOL)decompressionFilefromPath:(NSString*)path  destationPath:(NSString*)destationPath {
    BOOL ret = NO ;
    if (path == nil ||[path isEqualToString:@""]||![FileOperate isFileExistWithFilePath:path]) {
        return ret;
    }
    ZipArchive* zip = [[ZipArchive alloc] init];
    NSString *parentpath = [path stringByDeletingLastPathComponent];
    NSString *fileName = [[path lastPathComponent] stringByDeletingPathExtension];
    if( [zip UnzipOpenFile:path] )
    {
        ret = [zip UnzipFileTo:destationPath overWrite:YES];
        if( NO== ret )
        {
        }
        [zip UnzipCloseFile];
    }
    [zip release];
    return ret ;
}

+ (BOOL) isFileExistInMainBundle:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}

+ (BOOL)isNilOrEmptyWith:(NSString*)string {
    if (string == nil ||([string length] == 0) || [[string trimmedWhitespaceString] length] == 0) {
        return YES;
    }
    return NO;
}

@end
