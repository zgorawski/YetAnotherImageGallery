//
//  Response.swift
//  YetAnotherImageGallery
//
//  Created by Zbigniew Górawski on 21/02/2017.
//  Copyright © 2017 Zbigniew Górawski. All rights reserved.
//

enum Response<T, E: Error> {
    
    case success(T)
    case error(E)
}
