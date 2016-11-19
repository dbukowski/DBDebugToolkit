//
//  DBDebugToolkitTests.m
//  DBDebugToolkitTests
//
//  Created by Dariusz Bukowski on 11/19/2016.
//  Copyright (c) 2016 Dariusz Bukowski. All rights reserved.
//

// https://github.com/Specta/Specta

SpecBegin(InitialSpecs)

describe(@"these will pass", ^{
    
    it(@"can do maths", ^{
        expect(1).beLessThan(23);
    });
    
    it(@"can read", ^{
        expect(@"team").toNot.contain(@"I");
    });
    
    it(@"will wait and succeed", ^{
        waitUntil(^(DoneCallback done) {
            done();
        });
    });
});

SpecEnd

