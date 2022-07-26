//
//  Utility.swift
//  PinchableGridLayoutDemo
//
//  Created by Daniil Orlov on 20.07.2022.
//

import Foundation

func clamp<T: Comparable>(_ value: T, _ minimum: T, _ maximum: T) -> T {
    max(min(value, maximum), minimum)
}
