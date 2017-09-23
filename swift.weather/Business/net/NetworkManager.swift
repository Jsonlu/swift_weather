//
//  NetworkManager.swift
//  swift.weather
//
//  Created by JsonLu on 2017/9/23.
//  Copyright © 2017年 JsonLu. All rights reserved.
//


import UIKit
import AFNetworking


/// Swift 的枚举支持任意数据类型
/// switch / enum 在 OC 中都只是支持整数
/**
 - 如果日常开发中，发现网络请求返回的状态码是 405，不支持的网络请求方法
 - 首先应该查找网路请求方法是否正确
 */
enum HTTPMethod {
    case GET
    case POST
}

/// 网络管理工具
class NetworkManager: AFHTTPSessionManager {
    
    /// 静态区／常量／闭包
    /// 在第一次访问时，执行闭包，并且将结果保存在 shared 常量中
    static let shared: NetworkManager = {
        // 实例化对象
        let instance = NetworkManager()
        
        // 设置响应反序列化支持的数据类型
        instance.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        // 返回对象
        return instance
        
    }()
    
    // 将成功和失败的回调写在一个逃逸闭包中(请求)
    /// 封装 AFN 的 GET / POST 请求
    ///
    /// - parameter method:     GET / POST
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter completion: 完成回调[json(字典／数组), 是否成功]
    
    func request(requestType :HTTPMethod, url : String, parameters : [String : Any], resultBlock : @escaping([String : Any]?, Error?) -> ()) {
        
        // 成功闭包
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            resultBlock(responseObj as? [String : Any], nil)
        }
        
        // 失败的闭包
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            resultBlock(nil, error)
        }
        
        // Get 请求
        if requestType == .GET {
            get(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        // Post 请求
        if requestType == .POST {
            post(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
    }
    // MARK: - 封装 AFN 方法
    /// 上传文件必须是 POST 方法，GET 只能获取数据
    /// 封装 AFN 的上传文件方法
    ///
    /// - parameter URLString:  URLString
    /// - parameter parameters: 参数字典
    /// - parameter name:       接收上传数据的服务器字段(name - 要咨询公司的后台) `pic`
    /// - parameter data:       要上传的二进制数据
    /// - parameter completion: 完成回调
    func upload(urlString: String, parameters: AnyObject?, constructingBodyWithBlock:((_ formData:AFMultipartFormData) -> Void)?, uploadProgress: ((_ progress:Progress) -> Void)?, success: ((_ responseObject:AnyObject?) -> Void)?, failure: ((_ error: NSError) -> Void)?) -> Void {
        
        
        NetworkManager.shared.post(urlString, parameters: parameters, constructingBodyWith: { (formData) in
            
            
        }, progress: { (progress) in
            uploadProgress!(progress)
        }, success: { (task, objc) in
            if objc != nil {
                
                success!(objc as AnyObject?)
                
            }
        }, failure: { (task, error) in
            failure!(error as NSError)
            
        })
        
    }
    
    
    
    //
    
    /*
     // 将成功和失败的回调分别写在两个逃逸闭包中
     func request(requestType : HTTPMethod, url : String, parameters : [String : Any], succeed : @escaping([String : Any]?) -> (), failure : @escaping(Error?) -> ()) {
     
     // 成功闭包
     let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
     succeed(responseObj as? [String : Any])
     }
     
     // 失败的闭包
     let failureBlock = { (task: URLSessionDataTask?, error: Error) in
     failure(error)
     }
     
     // Get 请求
     if requestType == .Get {
     get(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
     }
     
     // Post 请求
     if requestType == .Post {
     post(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
     }
     }
     
     */
    
}
