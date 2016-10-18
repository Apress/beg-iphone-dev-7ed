//
//  PhysicsCategories.h
//  TextShooter
//
//  Created by Kim Topley on 8/9/14.
//  Copyright (c) 2014 Apress. All rights reserved.
//

#ifndef TextShooter_PhysicsCategories_h
#define TextShooter_PhysicsCategories_h

typedef NS_OPTIONS(uint32_t, PhysicsCategory) {
    PlayerCategory        =  1 << 1,
    EnemyCategory         =  1 << 2,
    PlayerMissileCategory =  1 << 3,
    GravityFieldCategory  =  1 << 4
};

#endif
