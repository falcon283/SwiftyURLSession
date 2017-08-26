//
//  URLSession+Body+Rx.swift
//  SwiftyNetwork
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation
import RxSwift

extension URLSession {
    
    public func rx_httpVoidRequest<R>(_ request: Request<R>) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in

            self.httpVoidRequest(request, completion: { error in

                if let error = error {
                    observer.onError(error)
                }
                else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            })

            return Disposables.create()
        }.backgroundTask(name: "\(#function)")
    }
    
    public func rx_httpRequest<R>(_ request: Request<R>) -> Observable<R> {
        return Observable<R>.create({ observer -> Disposable in
            
            self.httpRequest(request) { resource, error in
                if let error = error {
                    observer.onError(error)
                }
                else {
                    observer.onNext(resource!)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }).backgroundTask(name: "\(#function)")
    }
}
