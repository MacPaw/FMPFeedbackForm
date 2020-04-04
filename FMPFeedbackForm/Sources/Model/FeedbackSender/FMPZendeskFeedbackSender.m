//
//  FMPZendeskFeedbackSender.m
//  FMPFeedbackForm
//
//  Created by Anton Barkov on 21.01.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

#import "FMPZendeskFeedbackSender.h"
#import "FMPValidatedParameters.h"
#import "NSError+FMPExtensions.h"
#import "NSString+FMPExtensions.h"
#import "NSObject+FMPExtensions.h"

typedef void (^FMPUploadFilesCompletion)(NSError *_Nullable error, NSString *_Nullable uploadsToken);

@interface FMPZendeskFeedbackSender ()
@property (nonatomic, copy) NSString *authToken;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *subdomain;
@end

@implementation FMPZendeskFeedbackSender

@synthesize maxAttachmentsCount;
@synthesize maxAttachmentFileSize;

- (instancetype)initWithZendeskSubdomain:(NSString *)subdomain
                               authToken:(NSString *)authToken
                             productName:(NSString *)productName
{
    self = [super init];
    if (self)
    {
        self.subdomain = subdomain;
        self.authToken = authToken;
        self.productName = productName;
        self.maxAttachmentsCount = 10;
        self.maxAttachmentFileSize = 20;
    }
    return self;
}

- (void)sendFeedbackWithParameters:(NSDictionary<FMPFeedbackParameter, id> *)parameters completion:(FMPSendFeedbackCompletion)completion
{
    // Validate required parameters
    NSError *validationError = nil;
    FMPValidatedParameters *validParameters = [self validateRequiredParameters:parameters error:&validationError];
    if (validationError)
    {
        if (completion)
        {
            completion(validationError);
        }
        return;
    }
    
    // User info
    NSMutableDictionary *requesterDict = [NSMutableDictionary dictionaryWithDictionary:@{
        @"email": validParameters.email
    }];
    NSString *name = [NSString fmp_dynamicCastObject:parameters[FMPFeedbackParameterName]];
    if (name.length > 0)
    {
        [requesterDict setObject:name forKey:@"name"];
    }
    
    // Upload files if needed
    NSMutableArray<NSURL *> *filesToUpload = [NSMutableArray new];
    NSArray<NSURL *> *attachments = [NSArray fmp_dynamicCastObject:parameters[FMPFeedbackParameterAttachments]];
    if (attachments.count > 0)
    {
        [filesToUpload addObjectsFromArray:attachments];
    }
    NSURL *systemProfileURL = [NSURL fmp_dynamicCastObject:parameters[FMPFeedbackParameterSystemProfile]];
    if (systemProfileURL)
    {
        [filesToUpload addObject:systemProfileURL];
    }
    
    __weak typeof(self) weakSelf = self;
    [self uploadAttachments:filesToUpload
               uploadsToken:nil
                      email:validParameters.email
                 completion:^(NSError * _Nullable error, NSString *_Nullable uploadsToken) {
        if (error)
        {
            completion(error);
        }
        else
        {
            __strong typeof(weakSelf) _self = weakSelf;
            
            // Subject with product name
            NSString *subject = [NSString stringWithFormat:@"[%@] %@", _self.productName, validParameters.subject];
            
            // Ticket comment and attachments
            NSMutableDictionary *commentDict = [NSMutableDictionary dictionaryWithDictionary:@{
                @"body": validParameters.details
            }];
            if (uploadsToken)
            {
                [commentDict setObject:[NSArray arrayWithObject:uploadsToken] forKey:@"uploads"];
            }
            
            // Prepare request
            NSDictionary *bodyDict = @{
                @"request": @{
                        @"requester": [requesterDict copy],
                        @"subject": subject,
                        @"comment": [commentDict copy]
                }
            };
            NSError *jsonError = nil;
            NSData *body = [NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:&jsonError];
            if (jsonError)
            {
                if (completion)
                {
                    completion([NSError fmp_errorWithCode:FMPErrorCodeInvalidJSON description:jsonError.description]);
                }
                return;
            }
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.zendesk.com/api/v2/requests.json", _self.subdomain]];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setValue:[_self authHeaderValueWithEmail:validParameters.email] forHTTPHeaderField:@"Authorization"];
            [request setHTTPBody:body];
            [request setHTTPMethod:@"POST"];
            
            // Send request
            NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                         completionHandler:^(NSData * _Nullable data,
                                                                                             NSURLResponse * _Nullable response,
                                                                                             NSError * _Nullable error) {
                completion([_self validateRequest:request response:response error:error]);
            }];
            [task resume];
        }
    }];
    
    
}

// MARK: - Upload attachments

// Recursively uploads every file in the `attachments` array, completes with an error if an upload fails
- (void)uploadAttachments:(NSArray<NSURL *> *)attachments
             uploadsToken:(NSString *)uploadsToken
                    email:(NSString *)email
               completion:(FMPUploadFilesCompletion)completion
{
    if (attachments.count == 0)
    {
        if (completion)
        {
            completion(nil, uploadsToken);
        }
        return;
    }
    
    NSError *readFileError = nil;
    NSURL *fileURL = [attachments firstObject];
    NSData *fileData = [NSData dataWithContentsOfURL:fileURL options:0 error:&readFileError];
    if (readFileError)
    {
        if (completion)
        {
            completion([NSError fmp_errorWithCode:FMPErrorCodeFailedReadFile description:readFileError.description], uploadsToken);
        }
        return;
    }
    
    // Form a URL with file name and previous uploads token
    NSString *tokenString = uploadsToken ? [NSString stringWithFormat:@"&token=%@", uploadsToken] : @"";
    NSString *fileNameString = [fileURL.lastPathComponent
                                stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSString *urlString = [NSString stringWithFormat:@"https://%@.zendesk.com/api/v2/uploads.json?filename=%@%@",
                           self.subdomain, fileNameString, tokenString];
    
    // Prepeare request
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/binary" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[self authHeaderValueWithEmail:email] forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:fileData];
    [request setHTTPMethod:@"POST"];
    
    // Send requst
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                 completionHandler:^(NSData * _Nullable data,
                                                                                     NSURLResponse * _Nullable response,
                                                                                     NSError * _Nullable error) {
        __strong typeof(weakSelf) _self = weakSelf;
        NSError *requestError = [_self validateRequest:request response:response error:error];
        if (requestError)
        {
            if (completion)
            {
                completion(requestError, uploadsToken);
            }
            return;
        }
        
        NSString *newUploadsToken = nil;
        if (!uploadsToken)
        {
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *uploadDict = [responseJSON objectForKey:@"upload"];
            newUploadsToken = [uploadDict objectForKey:@"token"];
        }
        else
        {
            newUploadsToken = uploadsToken;
        }
        
        NSMutableArray *mutableAttachments = [attachments mutableCopy];
        [mutableAttachments removeObject:fileURL];
        [_self uploadAttachments:[mutableAttachments copy] uploadsToken:newUploadsToken email:email completion:completion];
    }];
    [task resume];
}

// MARK: - Helper methods

- (NSString *)authHeaderValueWithEmail:(NSString *)email
{
    NSString *authStr = [NSString stringWithFormat:@"%@/token:%@", email, self.authToken];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authStrData = [[NSString alloc]
                             initWithData:[authData base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed]
                             encoding:NSASCIIStringEncoding];
    return [NSString stringWithFormat:@"Basic %@", authStrData];
}

- (NSError *)validateRequest:(NSURLRequest *)request
                    response:(NSURLResponse *)response
                       error:(NSError *)error
{
    if (error)
    {
        // No Internet connection error
        if ([error.domain isEqualTo:NSURLErrorDomain] && error.code == -1009)
        {
            return [NSError fmp_errorWithCode:FMPErrorCodeBadInternet description:@"No Internet connection."];
        }
        else
        {
            return [NSError fmp_errorWithCode:FMPErrorCodeFailedSendRequest description:[NSString stringWithFormat:@"Failed to send request with error:%@", error]];
        }
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode / 100 != 2)
    {
        return [NSError fmp_errorWithCode:FMPErrorCodeBadResponse description:
                [NSString stringWithFormat:@"Bad response returned by request: %@. Response: %@", request, response]];
    }
    
    return nil;
}

- (FMPValidatedParameters *)validateRequiredParameters:(NSDictionary<FMPFeedbackParameter, id> *)parameters
                                                 error:(NSError **)errorPtr
{
    NSString *email = [NSString fmp_dynamicCastObject:parameters[FMPFeedbackParameterEmail]];
    if (!email)
    {
        *errorPtr = [NSError fmp_errorWithCode:FMPErrorCodeInvalidType description:@"Invalid value passed for email parameter."];
        return nil;
    }
    if (!email.fmp_isValidEmail)
    {
        *errorPtr = [NSError fmp_errorWithCode:FMPErrorCodeInvalidEmail description:@"Email string is invalid."];
        return nil;
    }
    
    NSString *subject = [NSString fmp_dynamicCastObject:parameters[FMPFeedbackParameterSubject]];
    if (!subject)
    {
        *errorPtr = [NSError fmp_errorWithCode:FMPErrorCodeInvalidType description:@"Invalid value passed for subject parameter."];
        return nil;
    }
    if (subject.length == 0)
    {
        *errorPtr = [NSError fmp_errorWithCode:FMPErrorCodeInvalidSubject description:@"Subject string should not be empty."];
        return nil;
    }
    
    NSString *details = [NSString fmp_dynamicCastObject:parameters[FMPFeedbackParameterDetails]];
    if (!details)
    {
        *errorPtr = [NSError fmp_errorWithCode:FMPErrorCodeInvalidType description:@"Invalid value passed for details parameter."];
        return nil;
    }
    if (details.length == 0)
    {
        *errorPtr = [NSError fmp_errorWithCode:FMPErrorCodeInvalidDetails description:@"Details string should not be empty."];
        return nil;
    }
    
    return [[FMPValidatedParameters alloc] initWithEmail:email subject:subject details:details];
}

@end
