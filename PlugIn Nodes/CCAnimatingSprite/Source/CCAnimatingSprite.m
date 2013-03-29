/*
 * CocosBuilder: http://www.cocosbuilder.com
 *
 * Copyright (c) 2012 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "CCAnimatingSprite.h"

@implementation CCAnimatingSprite

@synthesize delay = _delay;
@synthesize ignorePause = _ignorePause;
@synthesize textureFilename = _textureFilename;

- (id) init
{
    self = [super init];
    if (!self) return NULL;
    
    _textureFilename = nil;
    self.delay = 0.1f;
    
    return self;
}

-(void) updateAnimation
{    
    [self stopAllActions];
  
    if (_textureFilename == nil)
        return;
        
    NSMutableString *filename = [NSMutableString stringWithString:_textureFilename];
    [filename replaceOccurrencesOfString:@".png" 
                              withString:@".plist" 
                                 options:0 
                                   range:NSMakeRange(0, [filename length])];
    
    // Add contents of file to the cache
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:filename];
    
    // Load frames dictionary
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filename];
    
    // Sort all keys alphabetically
    NSArray *allKeys = [[dict objectForKey:@"frames"] allKeys];
    NSArray *sortedKeys = [allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    // Create an array containing all frames
    NSMutableArray *frames = [NSMutableArray arrayWithCapacity:[sortedKeys count]];    
    for (NSString *key in sortedKeys)
    {
        if ([_wildcard length] && [key rangeOfString:_wildcard].location == NSNotFound)
            continue;
        
        CCSpriteFrame *spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:key];
        if (spriteFrame)
        {
            [frames addObject:spriteFrame];
        }
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:frames delay:_delay];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    [self runAction:[CCRepeatForever actionWithAction:animate]];
}

- (void) setDelay:(float)delay
{    
    _delay = delay;
    
    [self updateAnimation];        
}

-(void) setDisplayFrame:(CCSpriteFrame*)frame
{
    [super setDisplayFrame:frame];
    
    if (_textureFilename == frame.textureFilename)
        return;
    
    [_textureFilename release];
    _textureFilename = frame.textureFilename;
    [_textureFilename retain];
    
    [self updateAnimation];        
}

-(NSString *) getWildcard
{
    return _wildcard;
}

-(void) setWildcard:(NSString *)wildcard
{
    [_wildcard release];
    _wildcard = wildcard;
    [_wildcard retain];
    
    [self updateAnimation];
}

@end
