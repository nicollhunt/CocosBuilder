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

#import "CCBTransparentView.h"

@implementation CCBTransparentView

- (void)drawRect:(NSRect)rect {
    [[NSColor clearColor] set];
    NSRectFill(rect);
}

// This view hosts the transparent overlay window above the GL view. The overlay
// window only exists to host interactive subviews (the sticky note editor).
// Any event that was not directed at one of those subviews must fall through
// to the GL view underneath, which CCBTransparentWindow handles in sendEvent:.
- (NSView *)hitTest:(NSPoint)point
{
    NSView *hit = [super hitTest:point];
    // Returning nil for the overlay itself lets the window detect that the
    // event should be forwarded to the GL view below.
    return (hit == self) ? nil : hit;
}

@end
