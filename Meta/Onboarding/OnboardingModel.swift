//
//  OnboardingModel.swift
//  Meta
//
//  Created by Elias on 05/05/2020.
//  Copyright © 2020 Elias Igbalajobi. All rights reserved.
//

import Foundation

struct OnboardingModel: Equatable {
    var imageUri: String!
    var description: String!
    
    static func == (lhs: OnboardingModel, rhs: OnboardingModel) -> Bool {
        return lhs.imageUri == rhs.imageUri && lhs.description == rhs.description
    }
}
