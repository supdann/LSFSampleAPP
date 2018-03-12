//
//  Extensions.swift
//  LSFManager
//
//  Created by Daniel Montano on 07.02.18.
//  Copyright © 2018 danielmontano. All rights reserved.
//

import Foundation
import UIKit

// Methods to instantiate nibs easier. From: https://theiconic.tech/instantiating-from-xib-using-swift-generics-632a2b3d8109 (7 Feb 2018)

extension UIView {
    
    static var nib: UINib {
        
        return UINib(nibName: "\(self)", bundle: nil)
    }
}

extension UINib {
    
    func instantiate() -> Any? {
        
        return self.instantiate(withOwner: nil, options: nil).first
    }
}

extension UIView {
    
    static func instantiateFromNib() -> Self? {
        
        func instanceFromNib<T: UIView>() ->T? {
            
            return nib.instantiate() as? T
        }
        
        return instanceFromNib()
    }
}
