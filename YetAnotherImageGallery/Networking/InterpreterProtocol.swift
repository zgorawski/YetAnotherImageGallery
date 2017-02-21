//
//  InterpreterProtocol.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

import Foundation

protocol NetworkResponseInterpreter {
    
    associatedtype SuccessType
    associatedtype ErrorType: Error
    
    func interpret(data: Data?, response: HTTPURLResponse?, error: Error?) -> Response<SuccessType, ErrorType>
}
