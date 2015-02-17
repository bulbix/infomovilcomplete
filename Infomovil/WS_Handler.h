//
//  WS_HandlerOrig.h
//  WS_Pruebas
//
//  Created by Ignaki Dominguez Martinez on 28/01/10.
//  Copyright 2010 BAZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TIMEOUTREQUEST 60

@interface WS_Handler : NSObject <NSXMLParserDelegate>
{
	NSArray				*arrNameSpace;
	NSString			*strServiceUrl;
	NSString			*strSoapAction;
	NSDictionary		*dictSopaHeader;
	NSString			*strCurrElement;
	NSString			*strLastElement;
	NSMutableString		*strRespuesta;
	NSData				*dataRespuesta;
	BOOL				bodyFlag;
    
    BOOL                autentica;
}

@property (nonatomic, retain) NSArray *arrNameSpace;
@property (nonatomic, retain) NSString *strServiceUrl;
@property (nonatomic, retain) NSString *strSoapAction;
@property (nonatomic, retain) NSDictionary *dictSopaHeader;
@property (nonatomic, retain) NSString *strCurrElement;
@property (nonatomic, retain) NSString *strLastElement;

@property (nonatomic, retain) NSString *usuarioAut;
@property (nonatomic, retain) NSString *passwordAut;

// Metodos de manejo de cadenas para Web Service
+ (NSString *)formatoCadena:(NSString *)cadena;
- (NSString *)formatoCadena:(NSString *)cadena;
+ (NSString *)corrigeCadena:(NSString *)cadena;
- (NSString *)corrigeCadena:(NSString *)cadena;

// Metodos de creacion de peticiones a Web Service
+ (NSString *)creaPostData:(NSDictionary *)parametros;
- (NSString *)creaPostData:(NSDictionary *)parametros;
+ (NSString *)creaSoapData:(NSDictionary *)parametros ordenado:(BOOL)ordenado;
- (NSString *)creaSoapData:(NSDictionary *)parametros ordenado:(BOOL)ordenado;
+ (NSString *)creaSoapData:(NSDictionary *)parametros ordenado:(BOOL)ordenado strAtribute:(NSString *)strAtribute;
- (NSString *)creaSoapData:(NSDictionary *)parametros ordenado:(BOOL)ordenado strAtribute:(NSString *)strAtribute;
- (NSString *)creaSoapEnvelope:(NSString *)metodo conParametros:(NSDictionary *)parametros ordenado:(BOOL)ordenado xmlInterno:(BOOL)bXmlInter;
- (NSString *)creaSoapEnvelope:(NSString *)metodo conParametro:(NSString *)parametro;

// Metodos de comunicacion de Web Service
- (NSData *)getXmlRespuesta:(NSString *)xmlPeticion conURL:(NSString *)url;
- (NSData *)getXmlRespuesta:(NSString *)xmlPeticion;
- (NSString *)getRespuesta:(NSString *)xmlPeticion conURL:(NSString *)url;
- (NSString *)getRespuesta:(NSString *)xmlPeticion;

//Complementos a consulta de WS 
+ (NSData*)WSGetRequest:(NSString*)strURL;
+ (NSData*)WSPostRequest:(NSString*)strURL param:(NSString*)strParam;

@end
