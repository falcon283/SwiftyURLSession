//
//  URLSession+Body+Rx.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation
import RxSwift

public protocol Task {
    associatedtype T: URLSessionTask
    associatedtype R: Resource
    
    var task: T { get }
    var result: R? { get }
}

extension URLSession {
    
    public func rxDataRequest<R>(_ request: Request<R>,
                                 startNow: Bool = true,
                                 validator: @escaping ((StatusCode)->(Bool)) = URLSession.validateExcept4XX) -> Observable<DataTask<R>> {
        
        let observable = Observable<DataTask<R>>.create({ observer -> Disposable in
            
            var task: URLSessionDataTask!

            task = self.dataRequest(request, startNow: false) { result, error in
                if let error = error {
                    observer.onError(error)
                }
                else {
                    observer.onNext(DataTask(task, result: result))
                    observer.onCompleted()
                }
            }
            
            observer.onNext(DataTask(task))
            task.resumed(startNow)
            
            return Disposables.create()
        })
        
        return observable.runWhileInBackgroundIfSupported(name: "\(#function)")
    }
    
    public func rxUploadRequest<R>(_ request: Request<R>,
                                   data: Data,
                                   startNow: Bool = true,
                                   validator: @escaping ((StatusCode)->(Bool)) = URLSession.validateExcept4XX) -> Observable<UploadTask<R>> {
        
        let observable = Observable<UploadTask<R>>.create({ observer -> Disposable in
            
            var task: URLSessionUploadTask!

            task = self.uploadRequest(request, data: data, startNow: false) { result, error in
                if let error = error {
                    observer.onError(error)
                }
                else {
                    observer.onNext(UploadTask(task, result: result))
                    observer.onCompleted()
                }
            }
            
            observer.onNext(UploadTask(task))
            task.resumed(startNow)
            
            return Disposables.create()
        })
        
        return observable.runWhileInBackgroundIfSupported(name: "\(#function)")
    }
    
    public func rxDownloadRequest<R>(_ request: Request<R>,
                                     resumeData: Data? = nil,
                                     startNow: Bool = true,
                                     validator: @escaping ((StatusCode)->(Bool)) = URLSession.validateExcept4XX) -> Observable<DownloadTask<R>> {
        
        let observable = Observable<DownloadTask<R>>.create({ observer -> Disposable in
            
            var task: URLSessionDownloadTask!
            
            task = self.downloadRequest(request, resumeData: resumeData, startNow: false) { result, error in
                
                if let error = error {
                    observer.onError(error)
                }
                else {
                    observer.onNext(DownloadTask(task, result: result))
                    observer.onCompleted()
                }
            }
            
            observer.onNext(DownloadTask(task))
            task.resumed(startNow)
            
            return Disposables.create()
        })
        
        return observable.runWhileInBackgroundIfSupported(name: "\(#function)")
    }
}

public struct DataTask<T: Resource> : Task {
    
    public let task: URLSessionDataTask
    public let result: T?
    
    public init(_ task: URLSessionDataTask, result: T? = nil) {
        self.task = task
        self.result = result
    }
}

public struct UploadTask<T: Resource> : Task {
    
    public let task: URLSessionUploadTask
    public let result: T?
    
    public init(_ task: URLSessionUploadTask, result: T? = nil) {
        self.task = task
        self.result = result
    }
}

public struct DownloadTask<T: Resource> : Task {
    
    public let task: URLSessionDownloadTask
    public let result: T?
    
    public init(_ task: URLSessionDownloadTask, result: T? = nil) {
        self.task = task
        self.result = result
    }
}
