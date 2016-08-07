//
//  GoogleDirectionsXMLPaeser.m
//  MapRouteSample
//
//  Created by k2 on 11/08/26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoogleDirectionsXMLParser.h"
#import "RouteObject.h"
#import "StepObject.h"

@interface GoogleDirectionsXMLParser (private)
- (void)startElementLocalName:(const xmlChar*)localname 
					   prefix:(const xmlChar*)prefix 
						  URI:(const xmlChar*)URI 
				nb_namespaces:(int)nb_namespaces 
				   namespaces:(const xmlChar**)namespaces 
				nb_attributes:(int)nb_attributes 
				 nb_defaulted:(int)nb_defaulted 
				   attributes:(const xmlChar**)attributes;
- (void)endElementLocalName:(const xmlChar*)localname 
					 prefix:(const xmlChar*)prefix URI:(const xmlChar*)URI;
- (void)endDocumentElementName:(const xmlChar*)name;
- (void)charactersFound:(const xmlChar*)ch 
					len:(int)len;
- (void)warningHandler:(const char*)msg;
- (void)errorHandler:(const char*)msg;
@end


static void endDocumentElementHandler(
                                      void * ctx,
                                      const xmlChar *name)
{
    [(GoogleDirectionsXMLParser*)ctx 
     endDocumentElementName:name];
}


static void startElementHandler(
								void* ctx, 
								const xmlChar* localname, 
								const xmlChar* prefix, 
								const xmlChar* URI, 
								int nb_namespaces, 
								const xmlChar** namespaces, 
								int nb_attributes, 
								int nb_defaulted, 
								const xmlChar** attributes)
{
    [(GoogleDirectionsXMLParser*)ctx 
	 startElementLocalName:localname 
	 prefix:prefix URI:URI 
	 nb_namespaces:nb_namespaces 
	 namespaces:namespaces 
	 nb_attributes:nb_attributes 
	 nb_defaulted:nb_defaulted 
	 attributes:attributes];
}

static void	endElementHandler(
							  void* ctx, 
							  const xmlChar* localname, 
							  const xmlChar* prefix, 
							  const xmlChar* URI)
{
    [(GoogleDirectionsXMLParser*)ctx 
	 endElementLocalName:localname 
	 prefix:prefix 
	 URI:URI];
}

static void	charactersFoundHandler(
								   void* ctx, 
								   const xmlChar* ch, 
								   int len)
{
    [(GoogleDirectionsXMLParser*)ctx 
	 charactersFound:ch len:len];
}

static void warning( 
					void * ctx, 
					const char * msg, 
					... )
{
    //	ParseFSM &fsm = *( static_cast<ParseFSM *>( ctx ) );
    //	va_list args;
    //	va_start(args, msg);
    //	vprintf( msg, args );
    //	va_end(args);
	[(GoogleDirectionsXMLParser*)ctx 
	 warningHandler:msg];
}

static void error( 
				  void * ctx, 
				  const char * msg, 
				  ... )
{
    //	ParseFSM &fsm = *( static_cast<ParseFSM *>( ctx ) );
    //	va_list args;
    //	va_start(args, msg);
    //	vprintf( msg, args );
    //	va_end(args);
	[(GoogleDirectionsXMLParser*)ctx 
	 errorHandler:msg];
}

static xmlSAXHandler _saxHandlerStruct = {
    NULL,            /* internalSubset */
    NULL,            /* isStandalone   */
    NULL,            /* hasInternalSubset */
    NULL,            /* hasExternalSubset */
    NULL,            /* resolveEntity */
    NULL,            /* getEntity */
    NULL,            /* entityDecl */
    NULL,            /* notationDecl */
    NULL,            /* attributeDecl */
    NULL,            /* elementDecl */
    NULL,            /* unparsedEntityDecl */
    NULL,            /* setDocumentLocator */
    NULL,            /* startDocument */
    NULL,			 /* endDocument */
    NULL,            /* startElement*/
    endDocumentElementHandler,/* endElement */
    NULL,            /* reference */
    charactersFoundHandler, /* characters */
    NULL,            /* ignorableWhitespace */
    NULL,            /* processingInstruction */
    NULL,            /* comment */
    warning,         /* warning */
    error,           /* error */
    NULL,            /* fatalError //: unused error() get all the errors */
    NULL,            /* getParameterEntity */
    NULL,            /* cdataBlock */
    NULL,            /* externalSubset */
    XML_SAX2_MAGIC,  /* initialized */
    NULL,            /* private */
    startElementHandler,    /* startElementNs */
    endElementHandler,      /* endElementNs */
    NULL,            /* serror */
};

@implementation GoogleDirectionsXMLParser

//--------------------------------------------------------------//
#pragma mark -- Initialize --
//--------------------------------------------------------------//

- (void)dealloc {
	
	// XMLパーサを解放する
    if (parserContext_)
	{
        xmlFreeParserCtxt(parserContext_), parserContext_ = NULL;
    }
    
    [super dealloc];
}

//--------------------------------------------------------------//
#pragma mark -- methods --
//--------------------------------------------------------------//

- (RouteObject *)loadXmlString:(NSString *)xmlString
{		
    if(!xmlString)
        return nil;
    
    routeObj_ = [[RouteObject alloc]init];
    
	// XMLパーサを作成する
	parserContext_ = xmlCreatePushParserCtxt(&_saxHandlerStruct, self, NULL, 0, NULL);
    
	// type data
    NSData *data = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
	xmlParseChunk(parserContext_, (const char*)[data bytes], [data length], 0);
	
    // XMLパーサを解放する
    if (parserContext_)
    {
        xmlFreeParserCtxt(parserContext_), parserContext_ = NULL;
    }
    
    // ※コメント化
    // NSLog(@"route %@",[routeObj_ description]);
    
    return [routeObj_ autorelease];
}

//-------------------------------------------------------------------------------------//
#pragma mark -- libxml handler --
//-------------------------------------------------------------------------------------//

- (void)startElementLocalName:(const xmlChar*)localname 
					   prefix:(const xmlChar*)prefix 
						  URI:(const xmlChar*)URI 
				nb_namespaces:(int)nb_namespaces 
				   namespaces:(const xmlChar**)namespaces 
				nb_attributes:(int)nb_attributes 
				 nb_defaulted:(int)nb_defaulted 
				   attributes:(const xmlChar**)attributes;
{
	
	//printf("localname %s\n", localname);
	
	if (strncmp((char*)localname, "route", sizeof("route")) == 0) 
	{
        //routeObj_ = [[RouteObject alloc]init];
        return;
    }
    else if(strncmp((char*)localname, "leg", sizeof("leg")) == 0)
    {
        isLeg_ = YES;
        return;
    }
    else if(strncmp((char*)localname, "start_location", sizeof("start_location")) == 0)
    {
        isStartLacation_ = YES;
        return;
    }
    else if(strncmp((char*)localname, "end_location", sizeof("end_location")) == 0)
    {
        isEndLocation_ = YES;
        return;
    }
    else if(strncmp((char*)localname, "duration", sizeof("duration")) == 0)
    {
        isDuration_ = YES;
        return;
    }
    else if(strncmp((char*)localname, "distance", sizeof("distance")) == 0)
    {
        isDistance_ = YES;
        return;
    }
    else if(strncmp((char*)localname, "step", sizeof("step")) == 0)
    {
        isStep_ = YES;
        StepObject* stepObj = [[StepObject alloc] init];
        [routeObj_ addStep:stepObj];
        [stepObj release];
        return;
    }
    else if(strncmp((char*)localname, "southwest", sizeof("southwest")) == 0)
    {
        isSouthwest_ = YES;
        return;
    }
    else if(strncmp((char*)localname, "northeast", sizeof("northeast")) == 0)
    {
        isNortheast_ = YES;
        return;
    }
    
    if (strncmp((char*)localname, "status",                 sizeof("status"))                   == 0	||
        strncmp((char*)localname, "travel_mode",			sizeof("travel_mode"))				== 0	||
        strncmp((char*)localname, "lat",                    sizeof("lat"))                      == 0	||
        strncmp((char*)localname, "lng",                    sizeof("lng"))                      == 0	||
        strncmp((char*)localname, "points",                 sizeof("points"))                   == 0	||
        strncmp((char*)localname, "levels",                 sizeof("levels"))                   == 0	||
        strncmp((char*)localname, "value",					sizeof("value"))					== 0	||
		strncmp((char*)localname, "text",                   sizeof("text"))                     == 0	||
		strncmp((char*)localname, "html_instructions",		sizeof("html_instructions"))		== 0	||
		strncmp((char*)localname, "start_address",			sizeof("start_address"))			== 0	||
		strncmp((char*)localname, "end_address",			sizeof("end_address"))				== 0	
        )
    {
        // 文字列のためのバッファを作成する
		[currentCharacters_ release],currentCharacters_ = nil;
        currentCharacters_ = [[NSMutableString string] retain];
    }
}

- (void)endElementLocalName:(const xmlChar*)localname 
					 prefix:(const xmlChar*)prefix URI:(const xmlChar*)URI;
{
    if([currentCharacters_ length] == 0)
    {
        [currentCharacters_ release],currentCharacters_ = nil;
    }
    
    if(strncmp((char*)localname, "status", sizeof("status")) == 0)
    {
        routeObj_.status = currentCharacters_;
    }
    else if(strncmp((char*)localname, "summary", sizeof("summary")) == 0)
    {
        routeObj_.summary = currentCharacters_;
    }
    else if(strncmp((char*)localname, "travel_mode", sizeof("travel_mode")) == 0)
    {
        StepObject* stepObj = [[routeObj_ steps] lastObject];
        stepObj.travelMode = currentCharacters_;
    }
    else if(strncmp((char*)localname, "lat", sizeof("lat")) == 0)
    {
        if(isLeg_)
        {
            if(isStep_)
            {
                StepObject* stepObj = [[routeObj_ steps] lastObject];
                if(isStartLacation_)
                {
                    stepObj.startLocationLat = [currentCharacters_ doubleValue];
                }
                else if(isEndLocation_)
                {
                    stepObj.endLocationLat = [currentCharacters_ doubleValue];
                }
            }
            else
            {
                if(isStartLacation_)
                {
                    routeObj_.startLocationLat = [currentCharacters_ doubleValue];
                }
                else if(isEndLocation_)
                {
                    routeObj_.endLocationLat = [currentCharacters_ doubleValue];
                }
            }
        }
        else
        {
            if(isSouthwest_)
            {
                routeObj_.southwestLat = [currentCharacters_ doubleValue];
            }
            else if(isNortheast_)
            {
                routeObj_.northeastLat = [currentCharacters_ doubleValue];
            }
        }
    }
    else if(strncmp((char*)localname, "lng", sizeof("lng")) == 0)
    {
        if(isLeg_)
        {
            if(isStep_)
            {
                StepObject* stepObj = [[routeObj_ steps] lastObject];
                if(isStartLacation_)
                {
                    stepObj.startLocationLng = [currentCharacters_ doubleValue];
                }
                else if(isEndLocation_)
                {
                    stepObj.endLocationLng = [currentCharacters_ doubleValue];
                }
            }
            else
            {
                if(isStartLacation_)
                {
                    routeObj_.startLocationLng = [currentCharacters_ doubleValue];
                }
                else if(isEndLocation_)
                {
                    routeObj_.endLocationLng = [currentCharacters_ doubleValue];
                }
            }
        }
        else
        {
            if(isSouthwest_)
            {
                routeObj_.southwestLng = [currentCharacters_ doubleValue];
            }
            else if(isNortheast_)
            {
                routeObj_.northeastLng = [currentCharacters_ doubleValue];
            }
        }
    }
    else if(strncmp((char*)localname, "value", sizeof("value")) == 0)
    {
        if(isLeg_ && !isStep_ && isDuration_)
        {
            routeObj_.durationValue = currentCharacters_;
        }
        else if(isLeg_ && !isStep_ && isDistance_)
        {
            routeObj_.distanceValue = currentCharacters_;
        }
        else if(isLeg_ && isStep_)
        {
            StepObject* stepObj = [[routeObj_ steps] lastObject];
            if(isDuration_)
            {
                stepObj.durationValue = currentCharacters_;
            }
            else if(isDistance_)
            {
                stepObj.distanceValue = currentCharacters_;
            }
        }
    }
    else if(strncmp((char*)localname, "text", sizeof("text")) == 0)
    {
        if(isLeg_ && !isStep_ && isDuration_)
        {
            routeObj_.durationText = currentCharacters_;
        }
        else if(isLeg_ && !isStep_ && isDistance_)
        {
            routeObj_.distanceText = currentCharacters_;
        }
        else if(isLeg_ && isStep_)
        {
            StepObject* stepObj = [[routeObj_ steps] lastObject];
            if(isDuration_)
            {
                stepObj.durationText = currentCharacters_;
            }
            else if(isDistance_)
            {
                stepObj.distanceText = currentCharacters_;
            }
        }
    }
    else if(strncmp((char*)localname, "points", sizeof("points")) == 0)
    {
        StepObject* stepObj = [[routeObj_ steps] lastObject];
        stepObj.polylinePoints = currentCharacters_;
    }
    else if(strncmp((char*)localname, "levels", sizeof("levels")) == 0)
    {
        StepObject* stepObj = [[routeObj_ steps] lastObject];
        stepObj.polylineLevels = currentCharacters_;
    }
    else if(strncmp((char*)localname, "polyline", sizeof("polyline")) == 0)
    {
        StepObject* stepObj = [[routeObj_ steps] lastObject];
        [stepObj setupPolyLine];
    }
    else if(strncmp((char*)localname, "html_instructions", sizeof("html_instructions")) == 0)
    {
        StepObject* stepObj = [[routeObj_ steps] lastObject];
        stepObj.htmlInstructions = currentCharacters_;
    }
    else if(strncmp((char*)localname, "leg", sizeof("leg")) == 0)
    {
        isLeg_ = NO;
        return;
    }
    else if(strncmp((char*)localname, "step", sizeof("step")) == 0)
    {
        isStep_ = NO;
        return;
    }
    else if(strncmp((char*)localname, "start_location", sizeof("start_location")) == 0)
    {
        isStartLacation_ = NO;
        return;
    }		
    else if(strncmp((char*)localname, "end_location", sizeof("end_location")) == 0)
    {
        isEndLocation_ = NO;
        return;
    }
    else if(strncmp((char*)localname, "duration", sizeof("duration")) == 0)
    {
        isDuration_ = NO;
        return;
    }
    else if(strncmp((char*)localname, "distance", sizeof("distance")) == 0)
    {
        isDistance_ = NO;
        return;
    }
    else if(strncmp((char*)localname, "southwest", sizeof("southwest")) == 0)
    {
        isSouthwest_ = NO;
        return;
    }
    else if(strncmp((char*)localname, "northeast", sizeof("northeast")) == 0)
    {
        isNortheast_ = NO;
        return;
    }
    else if(strncmp((char*)localname, "start_address", sizeof("start_address")) == 0)
    {
        routeObj_.startAddress = currentCharacters_;
    }
    else if(strncmp((char*)localname, "end_address", sizeof("end_address")) == 0)
    {
        routeObj_.endAddress = currentCharacters_;
    }
    
	[currentCharacters_ release],currentCharacters_ = nil;
}

- (void)warningHandler:(const char*)msg
{
	printf("warning msg %s\n", msg);
}

- (void)errorHandler:(const char*)msg
{
	printf("error msg %s\n", msg);
}

- (void)charactersFound:(const xmlChar*)ch 
					len:(int)len;
{
	// 文字列を追加する
    if (currentCharacters_)
	{
        NSString*   string = nil;
        string = [[NSString alloc] initWithBytes:ch length:len encoding:NSUTF8StringEncoding];
        [currentCharacters_ appendString:string];
        [string release];
    }
}


@end
