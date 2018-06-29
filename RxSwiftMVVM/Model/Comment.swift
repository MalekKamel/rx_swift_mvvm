//
//  Comment.swift
//  RxSwiftMVVM
//
//  Created by Sha on 6/23/18.
//

import Foundation
public struct Comment: Decodable{
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
