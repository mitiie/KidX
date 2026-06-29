//
//  AlphabetLetter.swift
//  KidX
//
//  Created by mt on 14/6/26.
//

import Foundation

struct AlphabetLetter {
    let uppercase: String
    let lowercase: String
    let primaryHex: UInt32
    let secondaryHex: UInt32

    var displayText: String {
        uppercase + lowercase
    }

    static let all: [AlphabetLetter] = [
        .init(uppercase: "A", lowercase: "a", primaryHex: 0xD94B9A, secondaryHex: 0xF07BB9),
        .init(uppercase: "B", lowercase: "b", primaryHex: 0x149FE3, secondaryHex: 0x66C7F5),
        .init(uppercase: "C", lowercase: "c", primaryHex: 0xA7D84B, secondaryHex: 0xD9EA45),
        .init(uppercase: "D", lowercase: "d", primaryHex: 0xE21B78, secondaryHex: 0xF06FA9),
        .init(uppercase: "E", lowercase: "e", primaryHex: 0xFF9634, secondaryHex: 0xFFD452),
        .init(uppercase: "F", lowercase: "f", primaryHex: 0x0FA8D6, secondaryHex: 0x5BC8EA),
        .init(uppercase: "G", lowercase: "g", primaryHex: 0xF04444, secondaryHex: 0xFF6767),
        .init(uppercase: "H", lowercase: "h", primaryHex: 0xEF6BA2, secondaryHex: 0xF5A0C2),
        .init(uppercase: "I", lowercase: "i", primaryHex: 0x4F66C8, secondaryHex: 0x7A86DD),
        .init(uppercase: "J", lowercase: "j", primaryHex: 0x1C8A54, secondaryHex: 0x8ACB4B),
        .init(uppercase: "K", lowercase: "k", primaryHex: 0x00AEEA, secondaryHex: 0x69D1F4),
        .init(uppercase: "L", lowercase: "l", primaryHex: 0x8E61BD, secondaryHex: 0xD56FA8),
        .init(uppercase: "M", lowercase: "m", primaryHex: 0x14AEE5, secondaryHex: 0x73D2F2),
        .init(uppercase: "N", lowercase: "n", primaryHex: 0x8D61BD, secondaryHex: 0xB984D1),
        .init(uppercase: "O", lowercase: "o", primaryHex: 0x52C978, secondaryHex: 0xA8DE74),
        .init(uppercase: "P", lowercase: "p", primaryHex: 0xF05B3C, secondaryHex: 0xFF9C3A),
        .init(uppercase: "Q", lowercase: "q", primaryHex: 0xCF3D8E, secondaryHex: 0xEF72B2),
        .init(uppercase: "R", lowercase: "r", primaryHex: 0x4EBBCB, secondaryHex: 0x7ED7E0),
        .init(uppercase: "S", lowercase: "s", primaryHex: 0xD82480, secondaryHex: 0xEC69AA),
        .init(uppercase: "T", lowercase: "t", primaryHex: 0xFF9A2E, secondaryHex: 0xFFD35A),
        .init(uppercase: "U", lowercase: "u", primaryHex: 0x1BADE0, secondaryHex: 0x7ED5F2),
        .init(uppercase: "V", lowercase: "v", primaryHex: 0xD32232, secondaryHex: 0xF45D65),
        .init(uppercase: "W", lowercase: "w", primaryHex: 0x83C941, secondaryHex: 0xB8DF54),
        .init(uppercase: "X", lowercase: "x", primaryHex: 0xEF5738, secondaryHex: 0xFF805B),
        .init(uppercase: "Y", lowercase: "y", primaryHex: 0x7657B9, secondaryHex: 0x9B79D2),
        .init(uppercase: "Z", lowercase: "z", primaryHex: 0x28A9D4, secondaryHex: 0x6BD2E6)
    ]
}
