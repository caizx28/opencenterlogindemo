//
//  FileOperate.h
//  beautyCamera
//
//  Created by jiemin on 13-1-15.
//
//

#import <Foundation/Foundation.h>

@interface FileOperate : NSObject {
    
}

//查看是否某个key在配置文件中存在
+(BOOL)isExistValueOnUserDefautlForKey:(NSString *)key;

//获取tmp的路径
+ (NSString *)getTemporaryPath;

//获取Document的路径
+ (NSString *)getDocumentPath;

//获取Cache目录
+ (NSString *)getCachePath;

//文件路径
+ (NSString *)filePathWithName:(NSString *)name fromDirectory:(NSString *)directory;

//保存图片, 返回图片的路径
+ (NSString *)saveImage:(UIImage *)image withName:(NSString *)name toDirectory:(NSString *)directory;

//保存图片
+ (void)writeImage:(UIImage *)image toFile:(NSString *)file;

//获取图片
+ (UIImage *)getImageWithName:(NSString *)name fromDirectory:(NSString *)directory;

//获取图片
+ (UIImage *)readImageWithFile:(NSString *)file;

//删除图片
+ (void)removeImageWithName:(NSString *)name fromDirectory:(NSString *)directory;

//图片是否存在
+ (BOOL)isFileExistWithName:(NSString *)name fromDirectory:(NSString *)directory;

//文件是否存在
+ (BOOL)isFileExistWithFilePath:(NSString *)filePath;

//判断文件是否在资源包中
+ (BOOL) isFileExistInMainBundle:(NSString *)fileName;

//创建目录
+ (NSString *)createDirectoryWithName:(NSString *)name toDirectory:(NSString *)diretory;

//获取当前目录文件列表
+ (NSArray *)contentsOfFileFromDirectory:(NSString *)directory ;

//获取目录所有文件
+ (NSArray *)AllFileFromDirectory:(NSString *)directory;

+ (NSArray *)AllFileAbsolutePathFromDirectory:(NSString *)directory;

//写文件
+ (void)writeData:(id)data toFilePath:(NSString *)path;

//读取文件
+ (NSString *)readStringFromFilePath:(NSString *)path;

//移动/重命名文件
+ (void)moveSourceFile:(NSString *)srcFile toTargetFile:(NSString *)targetFile WithDirectory:(NSString *)directory;

//复制文件
+ (BOOL)copySourceFile:(NSString *)srcPath toTargetFile:(NSString *)targetPath ;
    
//删除图片
+ (void)removeFile:(NSString *)fileName;

//删除目录director下的所有文件
+ (void)removeAllFileFromDirectiory:(NSString *)directory;

+ (void)removePuzzleAllFileFromDirectiory:(NSString *)directory ;

//删除
+ (void)removeFile:(NSString *)fileName ;

+ (void)removeFile:(NSString *)name fromDirectory:(NSString *)directory ;
    
//从app中获取文件
+ (UIImage *)getImageFromApp:(NSString *)name ofType:(NSString *)type;

//保存图片到相册
+ (void)saveImageToAlbum:(UIImage *)image;

//序列化某个对象，该对象必须实现了NScoding协议
+ (id)readObjectFromRtfFile:(NSString*)filePath;

//反序列化一个对象
+ (BOOL)saveObjectToRtfFile:(id)object savePath:(NSString*)filePath;

//判断是否路径为一个文件夹
+ (BOOL)isDirectoryFromPath:(NSString*)path ;

//读取资源包的文件data
+ (NSData*)readDataFromBundle:(NSString *)fileName;

//将一个字符串写到一个文件
+ (void)writeStringToFile:(NSString*) content path:(NSString*)path ;

//压缩一个文件夹zip
+ (void)compressFolderFromPath:(NSString*)path;

//压缩某个文件zip
+ (void)compressFileFromPath:(NSString*)path ;

//压缩一组文件到zip
+ (void)compressFileFromPaths:(NSArray*)paths;

//解压一个zip到目录下，该文件的目录下
+ (void)decompressionFilefromPath:(NSString*)path;

//解压一个文件到某个目录下
+ (BOOL)decompressionFilefromPath:(NSString*)path  destationPath:(NSString*)destationPath;

+ (BOOL)isNilOrEmptyWith:(NSString*)string;


@end
