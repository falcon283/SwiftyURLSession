//
//  URLSession+Body+Rx.swift
//  SwiftyURLSession
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation
import RxSwift

extension URLSession {
    
    public func rx_httpRequest<R>(_ request: Request<R>) -> Observable<R?> {
        let observable = Observable<R?>.create({ observer -> Disposable in
            
            self.httpRequest(request) { resource, error in
                if let error = error {
                    observer.onError(error)
                }
                else {
                    observer.onNext(resource)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        })
        
        #if os(iOS)
            return observable.beginBackgroundTask(name: "\(#function)")
        #else
            return observable
        #endif
    }
}
