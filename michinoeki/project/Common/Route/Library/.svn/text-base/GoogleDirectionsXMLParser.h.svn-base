//
//  GoogleDirectionsXMLPaeser.h
//  MapRouteSample
//
//  Created by k2 on 11/08/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libxml/xmlreader.h>
#import <libxml/tree.h>

@class RouteObject;

@interface GoogleDirectionsXMLParser : NSObject {
@private
	xmlParserCtxtPtr		parserContext_;
	NSMutableString*        currentCharacters_;
    RouteObject*            routeObj_;
    BOOL                    isLeg_;
    BOOL                    isStep_;
    BOOL                    isStartLacation_;
    BOOL                    isEndLocation_;
    BOOL                    isDuration_;
    BOOL                    isDistance_;
    BOOL                    isSouthwest_;
    BOOL                    isNortheast_;
}

- (RouteObject *)loadXmlString:(NSString *)xmlString;

@end
