//
//  ScreenUtil.swift
//  JOYSTIQ
//
//  Created by Connor on 7/22/24.
//
//  This is a utility file to make a single computation of the devices height and width
//  Prevents a large amount of height / width computation in each view that uses responsive layouts

import UIKit

struct ScreenUtil {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}
