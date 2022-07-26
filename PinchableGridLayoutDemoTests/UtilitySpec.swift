//
//  UtilitySpec.swift
//  PinchableGridLayoutDemoTests
//
//  Created by Daniil Orlov on 26.07.2022.
//

import Quick
import Nimble
@testable import PinchableGridLayoutDemo

class UtilitySpec: QuickSpec {

    override func spec() {

        describe("`clamp` function") {

            it("returns minimum for values less then lower bound") {
                let minimum = 10
                let maximum = 20
                let value = 0

                expect(clamp(value, minimum, maximum)).to(equal(minimum))
            }

            it("returns maximum for values greater then lower bound") {
                let minimum = 10
                let maximum = 20
                let value = 30

                expect(clamp(value, minimum, maximum)).to(equal(maximum))
            }

            it("returns value for values within bounds") {
                let minimum = 10
                let maximum = 20
                let value = 15

                expect(clamp(value, minimum, maximum)).to(equal(value))
            }
        }
    }
}
