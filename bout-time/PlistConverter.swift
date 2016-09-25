//
//  PlistConverter.swift
//  bout-time
//
//  Created by Yi YU on 9/24/16.
//  Copyright © 2016 Yi YU. All rights reserved.
//

import Foundation

enum PlistConversionError: Error {
  case InvalidResource
  case ArrayConversionError
}


class PlistConverter {
  class func getArrayFromPlist(fileName: String, fileType: String) throws
      -> [Any] {
    guard let path = Bundle.main.path(forResource: fileName, ofType: fileType)
        else {
      throw PlistConversionError.InvalidResource
    }
    
    guard let retArray = NSArray(contentsOfFile: path),
        let castArray = retArray as? [Any] else {
      throw PlistConversionError.ArrayConversionError
    }
    
    return castArray
  }
}
