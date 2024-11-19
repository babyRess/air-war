//
//  PhysicsCategory.swift
//  air_war
//
//  Created by Thanh Dat Nguyen on 19/11/24.
//

struct PhysicsCategory{
    static let None: UInt32 = 0
    static let Player: UInt32 = 0x1<<1
    static let Bullet: UInt32 = 0x1<<2
    static let Enemy: UInt32 = 0x1<<3
    static let EnemyBullet: UInt32 = 0x1<<4
}
