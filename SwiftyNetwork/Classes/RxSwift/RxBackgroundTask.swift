//
//  RxBackgroundTask.swift
//  SwiftyNetwork
//
//  Created by FaLcON2 on 23/08/2017.
//  Copyright © 2017 Gabriele Trabucco. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    public func backgroundTask(name: String? = nil, expirationHandler: (()->())? = nil) -> RxSwift.Observable<Self.E> {
        let taskId = UIApplication.shared.beginBackgroundTask(withName: name, expirationHandler: expirationHandler)
        return asObservable().do(onCompleted: { UIApplication.shared.endBackgroundTask(taskId) })
    }
}