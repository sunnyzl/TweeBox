//
//  ParamsWithBounds.swift
//  TweeBox
//
//  Created by 4faramita on 2017/8/24.
//  Copyright © 2017年 4faramita. All rights reserved.
//

import Foundation

protocol ParamsWithBoundsProtocol: ParamsProtocol {
    
    var sinceID: String? { get set }
    var maxID: String? { get set }
}
