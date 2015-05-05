//
//  WS_HandlerOrig.m
//  WS_Pruebas
//
//  Created by Ignaki Dominguez Martinez on 28/01/10.
//  Copyright 2010 BAZ. All rights reserved.
//

#import "WS_Handler.h"
#import "NSStringUtiles.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation WS_Handler

@synthesize arrNameSpace;
@synthesize strServiceUrl;
@synthesize strSoapAction;
@synthesize dictSopaHeader;
@synthesize strCurrElement;
@synthesize strLastElement;
@synthesize usuarioAut, passwordAut;

-(id)init
{
	if ( (self = [super init]) )
	{
		strRespuesta	= nil;
		dataRespuesta	= nil;
		strSoapAction	= nil;
		dictSopaHeader	= nil;
		strLastElement	= nil;
		bodyFlag		= NO;
        usuarioAut      = nil;
        passwordAut     = nil;
	}
	return self;
}

- (void)dealloc
{
	[arrNameSpace	release];
	[strServiceUrl	release];
	[strSoapAction	release];
	[dictSopaHeader	release];
	[strCurrElement	release];
	[strLastElement	release];
	[strRespuesta	release];
	[dataRespuesta	release];
    [usuarioAut     release];
    [passwordAut    release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark Web Service's String Managment Methods
/**
 *	Manda sobreescribe caracteres especiales por codigo del html en una cadena para que mantengan el formato valido de xml (version clase)
 *	@param cadena: informacion que se desea limpiar
 *	@return representacion del data corregido en NSString, nil en caso de que el data sea nulo
 *	@since 2010-03-22
 *	@version 1.1
 */
+ (NSString *)formatoCadena:(NSString *)cadena
{
	WS_Handler *wsH	= [[WS_Handler alloc] init];
	NSString *respuesta	= [[wsH formatoCadena:cadena] retain];
	[wsH release];
	return [respuesta autorelease];
}

/**
 *	Sobreescribe caracteres especiales por codigo del html en una cadena para que mantengan el formato valido de xml
 *	@param cadena: informacion que se desea limpiar
 *	@return representacion del data corregido en NSString, nil en caso de que el data sea nulo
 *	@since 2010-01-26
 */
- (NSString *)formatoCadena:(NSString *)cadena
{
	if ( cadena != nil )
	{
		NSMutableString *mstrLimpia = [[[NSMutableString alloc] initWithString:cadena] autorelease];
		[mstrLimpia replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@"<" withString:@"&lt;"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		[mstrLimpia replaceOccurrencesOfString:@">" withString:@"&gt;"  options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		return mstrLimpia;
	}else
		return nil;
}

/**
 *	Manda a corregir la cadena dada
 *	@param cadena: cadena con la informacion a ser corregida
 *	@return nueva cadena corregida en caso de que la cadena recibida sea diferente de nil
 *			nil en caso contrario
 *	@version 1.1
 */
+ (NSString *)corrigeCadena:(NSString *)cadena
{
	WS_Handler *wsH	= [[WS_Handler alloc] init];
	NSString *respuesta	= [[wsH corrigeCadena:cadena] retain];
	[wsH release];
	return [respuesta autorelease];
}

/**
 *	Cambia el caracter < en su representacion html (&lt;) por este mismo
 *	@param cadena: cadena con la informacion a ser corregida
 *	@return nueva cadena corregida en caso de que la cadena recibida sea diferente de nil
 *			nil en caso contrario
 */
- (NSString *)corrigeCadena:(NSString *)cadena
{
	if (cadena != nil)
	{
		NSMutableString *mstrLimpia = [[[NSMutableString alloc] initWithString:cadena] autorelease];
		[mstrLimpia replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mstrLimpia length])];
		return mstrLimpia;
	} else
		return nil;
}

#pragma mark -
#pragma mark Create Web Service's Request Methods
/**
 *	Manda a crear el cuerpo de una peticion tipo POST
 *	@param parametros: diccionario con la informacion de los parametros a enviar
 *	@return cadena con formato
 *	@since 2010-02-04
 *	@version 1.1
 */
+ (NSString *)creaPostData:(NSDictionary *)parametros
{
	WS_Handler *wsH	= [[WS_Handler alloc] init];
	NSString *respuesta	= [[wsH creaPostData:parametros] retain];
	[wsH release];
	return [respuesta autorelease];
}

/**
 *	Crea el cuerpo de una peticion tipo POST
 *	@param parametros: diccionario con la informacion de los parametros a enviar
 *	@return cadena con formato
 *	@since 2010-02-04
 */
- (NSString *)creaPostData:(NSDictionary *)parametros
{
	NSMutableString *mstrParam	= [[NSMutableString alloc] init];
	NSMutableString *mstrTemp	= [[NSMutableString alloc] init];
	
	for ( id llave in [parametros allKeys] )
	{
		[mstrTemp setString:[parametros objectForKey:llave]];
		[mstrParam appendFormat:@"%@ =%@ &",llave,mstrTemp];
	}
	
	[mstrTemp replaceCharactersInRange:NSMakeRange([mstrTemp length]-1, 1) withString:@""];
	
	[mstrParam release];
	
	return [mstrTemp autorelease];
}

/**
 *	Manda a crear un bloque de xml de peticion para webServices con soap, con una lista de parametros con una bandera que 
 *	determina si llevan un orden alfabetico	debe ocuparse cuando hay una lista de parametros dentro de otra
 *	@param parametros: diccionario con la informacion de los parametro a ingresar
 *	@param ordenado: bandera que indica si deben ir ordenados los parametros por orden alfabetico o no
 *	@return regresa la cadena con el xml armado
 *	@since 2010-03-22
 *	@version 1.1
 */
+ (NSString *)creaSoapData:(NSDictionary *)parametros ordenado:(BOOL)ordenado
{
	WS_Handler *wsH	= [[WS_Handler alloc] init];
	NSString *respuesta	= [[wsH creaSoapData:parametros ordenado:ordenado] retain];
	[wsH release];
	return [respuesta autorelease];
}

/**
 *	Crea un bloque de xml de peticion para webServices con soap, con una lista de parametros con una bandera que determina 
 *	si llevan un orden alfabetico debe ocuparse cuando hay una lista de parametros dentro de otra
 *	@param parametros: diccionario con la informacion de los parametro a ingresar
 *	@param ordenado: bandera que indica si deben ir ordenados los parametros por orden alfabetico o no
 *	@return regresa la cadena con el xml armado
 *	@since 2010-03-22
 */
- (NSString *)creaSoapData:(NSDictionary *)parametros ordenado:(BOOL)ordenado
{
	return [self creaSoapData:parametros ordenado:ordenado strAtribute:nil];
}


/**
 *	Manda a crear un bloque de xml de peticion para webServices con soap, donde los tags llevan atributos, con una lista de
 *	parametros con una bandera que determina si llevan un orden alfabetico debe ocuparse cuando hay una lista de parametros
 *	dentro de otra
 *	@param parametros: diccionario con la informacion de los parametro a ingresar
 *	@param ordenado: bandera que indica si deben ir ordenados los parametros por orden alfabetico o no
 *	@param strAtribute: cadena de atributo(s) que van dentro de cada unos de los tag del xml, en caso de no ser necesario
 *						se manda un nil
 *	@return regresa la cadena con el xml armado
 *	@since 2010-03-22
 *	@version 1.1
 */
+ (NSString *)creaSoapData:(NSDictionary *)parametros ordenado:(BOOL)ordenado strAtribute:(NSString *)strAtribute
{
	WS_Handler *wsH	= [[WS_Handler alloc] init];
	NSString *respuesta	= [[wsH creaSoapData:parametros ordenado:ordenado strAtribute:strAtribute] retain];
	[wsH release];
	return [respuesta autorelease];
}

/**
 *	Crea un bloque de xml de peticion para webServices con soap, donde los tags llevan atributos, con una lista de
 *	parametros con una bandera que determina si llevan un orden alfabetico debe ocuparse cuando hay una lista de parametros
 *	dentro de otra
 *	@param parametros: diccionario con la informacion de los parametro a ingresar
 *	@param ordenado: bandera que indica si deben ir ordenados los parametros por orden alfabetico o no
 *	@param strAtribute: cadena de atributo(s) que van dentro de cada unos de los tag del xml, en caso de no ser necesario
 *						se manda un nil
 *	@return regresa la cadena con el xml armado
 *	@since 2010-03-22
 */			
- (NSString *)creaSoapData:(NSDictionary *)parametros ordenado:(BOOL)ordenado strAtribute:(NSString *)strAtribute
{
	NSMutableString *mstrParam = [[NSMutableString alloc] init];
	NSArray *llaves;
	
	if ( ordenado )
		llaves = [[parametros allKeys] sortedArrayUsingSelector:@selector(compare:)];
	else
		llaves = [parametros allKeys];
	
	for ( id llave in llaves )
	{
		NSString *strTemp = [parametros objectForKey:llave];
		if ( strAtribute )
			[mstrParam appendFormat:@"<%@ %@>%@</%@>",llave,strAtribute,[self formatoCadena:strTemp],llave];
		else
			[mstrParam appendFormat:@"<%@>%@</%@>",llave,[self formatoCadena:strTemp],llave];
	}
	
	return [mstrParam autorelease];
}

/**
 *	Crea un xml de peticion para webServices con soap, con una lista de parametros con una bandera que determina si llevan un orden alfabetico
 *	@param metodo: nombre del metodo a ejecutar
 *	@param parametros: diccionario con la informacion de los parametro a ingresar
 *	@param ordenado: bandera que indica si deben ir ordenados los parametros por orden alfabetico o no
 *	@param bXmlInter: bandera que indica si entre los parametros existe un xml interno que deban ser limpiados
 *	@return regresa la cadena con el xml armado
 */
- (NSString *)creaSoapEnvelope:(NSString *)metodo conParametros:(NSDictionary *)parametros ordenado:(BOOL)ordenado xmlInterno:(BOOL)bXmlInter
{
	NSMutableString *mstrParam	= [[NSMutableString alloc] init];
	NSString *strTemp			= nil;
	NSArray *llaves;
	
	if (ordenado && [parametros count])
		llaves = [[parametros allKeys] sortedArrayUsingSelector:@selector(compare:)];
	else
		llaves = [parametros allKeys];

	for ( id llave in llaves )
	{
		strTemp = ( bXmlInter ) ? [self formatoCadena:[parametros objectForKey:llave]] : [parametros objectForKey:llave];
        if ( [NSString isEmptyString:strTemp] )
            [mstrParam appendFormat:@"<%@/>",llave];
        else
            [mstrParam appendFormat:@"<%@>%@</%@>",llave,strTemp,llave];
	}
	
	strTemp = [self creaSoapEnvelope:metodo conParametro:mstrParam];
	[mstrParam release];
	
	return strTemp;
}

/**
 *	Crea un xml de peticion para webServices con soap
 *	@param metodo: nombre del metodo a ejecutar
 *	@param parametro: cadena con la informacion del parametro a ingresar esta no debe llevar signos de <, >, &
 *	@return regresa la cadena con el xml armado
 */
- (NSString *)creaSoapEnvelope:(NSString *)metodo conParametro:(NSString *)parametro
{
	NSMutableString *mstrXml = [[NSMutableString alloc] initWithString: @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
								"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
								"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
								//"xmlns:wsaw=\"http://www.w3.org/2006/05/addressing/wsdl\" "
								"xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\""];
	if ( arrNameSpace )
	{
		int i = 1;
		for ( NSString *strNameSpace in arrNameSpace)
		{
			[mstrXml appendFormat:@" xmlns:ns%d=\"%@\"",i++,strNameSpace];
		}
		
	}
	[mstrXml appendString:@">"];
	
	if ( dictSopaHeader )
	{
		[mstrXml appendString:@"<soap:Header>"];
		NSArray *llaves = [dictSopaHeader allKeys];
		for ( NSString *strllave in llaves )
		{
			[mstrXml appendFormat:@"<%@>%@</%@>",strllave,[dictSopaHeader objectForKey:strllave],strllave];
		}
		[mstrXml appendString:@"</soap:Header>"];
	}
	
	[mstrXml appendString:@"<soap:Body>"];
	[mstrXml appendFormat:@"<%@>%@</%@>",metodo,parametro,metodo];
	[mstrXml appendString:@"</soap:Body>"
					"</soap:Envelope>"];
	
	return [mstrXml autorelease];
}

#pragma mark -
#pragma mark Web Service's Comunication Methods
/**
 *	Regresa el xml de respuesta de un WebService; crea una conexion con el WS y envia la peticion dada y regresa su respuesta
 *	la url del WS debe ser dada anteriormente
 *	@param xmlPeticion: cadena de peticion para el web service
 *	@param url: url del WS a invocar
 *	@return la respuesta del WS o la descripcion del error
 *	@version 1.1
 *	@since 2011-04-11
 */
- (NSData *)getXmlRespuesta:(NSString *)xmlPeticion conURL:(NSString *)url
{
	self.strServiceUrl = url;
	return [self getXmlRespuesta:xmlPeticion];
}

/**
 *	Regresa el xml de respuesta de un WebService; crea una conexion con el WS y envia la peticion dada y regresa su respuesta
 *	la url del WS debe ser dada anteriormente
 *	@param xmlPeticion: cadena de peticion para el web service
 *	@return la respuesta del WS o la descripcion del error
 *	@version 1.1
 *	@since 2011-04-11
 */
- (NSData *)getXmlRespuesta:(NSString *)xmlPeticion
{
	NSData *dataPeticion = [xmlPeticion dataUsingEncoding:NSUTF8StringEncoding];
	
	NSURL *url = [[NSURL alloc] initWithString:strServiceUrl];
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[url release];
    [urlRequest setTimeoutInterval:30];
	
	[urlRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[urlRequest addValue:[NSString stringWithFormat:@"%d",[dataPeticion length]] forHTTPHeaderField:@"Content-Length"];
	[urlRequest setHTTPMethod:@"POST"];
    //Agrega los parametros de autenticacion
    if (autentica) {
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.usuarioAut, self.passwordAut];
        NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        NSString *authValue = [authData base64Encoding];
        [urlRequest setValue:[NSString stringWithFormat:@"Basic %@", authValue] forHTTPHeaderField:@"Authorization"];
    }
	[urlRequest setHTTPBody:dataPeticion];

	if( strSoapAction )
		[urlRequest addValue:strSoapAction forHTTPHeaderField:@"SOAPAction"];
	
	NSURLResponse *urlResponse;
	NSError *error = nil;
	NSData *dataResp = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
	[urlRequest release];

	if( error )
	{
#if DEBUG
        NSLog(@"El codigo de error en WS_Handler es: %ld y su descripcion es: %@", (long)error.code, error.localizedDescription);
        // Time out es -1001
#endif
        if(error.code == -1001) {
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"tiempoAgotado", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
        }
    
        if(error.code == -1005) {
            AlertView *alert = [AlertView initWithDelegate:Nil titulo:NSLocalizedString(@"sentimos", @" ") message:NSLocalizedString(@"noConexion", @" ") dominio:Nil andAlertViewType:AlertViewTypeInfo];
            [alert show];
            NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray* facebookCookies = [cookies cookiesForURL:[NSURL         URLWithString:@"https://facebook.com/"]];
            
            for (NSHTTPCookie* cookie in facebookCookies) {
                [cookies deleteCookie:cookie];
            }
        }
        
        if(error.code == -1003) {
            return [@"" dataUsingEncoding:NSUTF8StringEncoding];;
        }
       // return [[error localizedDescription] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *codigoError = [NSString stringWithFormat:@"%ld",(long)error.code ];
        NSData* cData = [codigoError dataUsingEncoding:NSUTF8StringEncoding];
        return cData;
	}
	
	return dataResp;
}

/**
 *	Obtiene respuesta del WS y extrea la cadena enbebida en la respuesta
 *	@param xmlPeticion: cadena de peticion para el web service
 *	@param url: url del WS a invocar
 *	@return la respuesta enbebida en el soap:Body, nil si no se existe tal
 */
- (NSString *)getRespuesta:(NSString *)xmlPeticion conURL:(NSString *)url
{
	self.strServiceUrl = url;
	return [self getRespuesta:xmlPeticion];
}

- (NSString *)getRespuesta:(NSString *)xmlPeticion conURL:(NSString *)url conAtenticacion:(BOOL)autenticacion
{
	self.strServiceUrl = url;
    autentica = autenticacion;
	return [self getRespuesta:xmlPeticion];
}

/**
 *	Obtiene respuesta del WS y extrea la cadena enbebida en la respuesta
 *	@param xmlPeticion: cadena de peticion para el web service
 *	@return la respuesta enbebida en el soap:Body, nil si no se existe tal
 */
- (NSString *)getRespuesta:(NSString *)xmlPeticion
{
	NSData *xmlRespuesta = [self getXmlRespuesta:xmlPeticion];
	[xmlRespuesta writeToFile:@"resp.xml" atomically:YES];

	// longitud minima esperada del xml de respuesta
	if ( [xmlRespuesta length] > 40 )
	{
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlRespuesta];
		[parser setDelegate:self];
		[parser setShouldProcessNamespaces:YES];
		[parser setShouldReportNamespacePrefixes:NO];
		
		[parser parse];
		[parser release];
	}
	
	return strRespuesta;
}

/**
 *	Regresa la de respuesta de un WebService; crea una conexion con el WS y envia la peticion dada y regresa su respuesta
 *	la url del WS debe ser dada anteriormente
 *	@param postData: cadena de peticion para el web service
 *	@return la respuesta del WS o la descripcion del error
 */
- (NSString *)getPostRespuesta:(NSString *)postData
{
	NSData *dataPeticion = [postData dataUsingEncoding:NSUTF8StringEncoding];
	NSURL *url = [[NSURL alloc] initWithString:strServiceUrl];
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[url release];
	
	[urlRequest addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[urlRequest addValue:[NSString stringWithFormat:@"%d",[dataPeticion length]] forHTTPHeaderField:@"Content-Length"];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setHTTPBody:dataPeticion];
	
	if( strSoapAction )
		[urlRequest addValue:strSoapAction forHTTPHeaderField:@"SOAPAction"];
	
	NSURLResponse *urlResponse;
	NSError *error;
	NSData *dataResp = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
	[urlRequest release];
	
	if( error )
	{
		return [error localizedDescription];
	}
	
	NSString *strRespServcio = [[[NSString alloc] initWithCString:[dataResp bytes]] autorelease];
	
	if( strRespServcio )
	{
		NSRange termino = [strRespServcio rangeOfString:@"</soap:Envelope>"];
		NSInteger longCalc = termino.length + termino.location;
		if( termino.location != NSNotFound && ( longCalc < [strRespServcio length] ) )
			return [strRespServcio substringToIndex:longCalc];
		else
			return strRespServcio;
	}else
		return @"";
}


#pragma mark -
#pragma mark Parser Delegate Methods
/**
 *	cuando encuentra el cierre del elemento "soap:Body" apaga la bandera bodyFlag
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//	if ( [qName compare:@":Body" options:NSCaseInsensitiveSearch] == NSOrderedSame )
	NSRange bodyRange = [qName rangeOfString:@":Body" options:NSCaseInsensitiveSearch];
	if ( bodyRange.location != NSNotFound )
		bodyFlag = NO;
}

/**
 *	Se obtiene el elemento actual, se revisa si este es el "soap:Body" y se prende la bandera bodyFlag para indicarle a los metodos
 *	que encuentran informacion que esta es parte del cuerpo de la respuesta del WS
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	self.strCurrElement = elementName;
	NSRange bodyRange = [qualifiedName rangeOfString:@":Body" options:NSCaseInsensitiveSearch];
	if ( bodyRange.location != NSNotFound )
		bodyFlag = YES;
}

/**
 *	Se obtien el data encontrado a traves de dataRespuesta, si esta está dentro del elemento "soap:Body", determinado
 *	con la bandera bodyFlag
 */
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
	if( bodyFlag )
	{
		if ( dataRespuesta )
			[dataRespuesta release];
		
		dataRespuesta = [CDATABlock retain];
	}
}

/**
 *	Extrae los caracteres encontrados entre tags, siempre y cuando esten dentro del elemento "soap:Body", determinado por la
 *	bandera bodyFlag
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( bodyFlag )
	{
		if ( !strRespuesta )
			strRespuesta = [[NSMutableString alloc] init];
		
		if ( strCurrElement == strLastElement )
			[strRespuesta appendString:string];
		else
			[strRespuesta setString:string];
		// se indica el nuevo ultimo elemento
		self.strLastElement = strCurrElement;
	}
}

/**
 *	Implemtancion del protocolo de NSParser para cuando se encuentra un error en el parseo del xml
 *	imprime los errores en el log y libera el parser
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Parsing Error" message:nil delegate:nil cancelButtonTitle:@"Continuar" otherButtonTitles:nil];
	NSString *erro = [parseError localizedDescription];
	
	alert.message = erro;
	[alert show];
	[alert release];
	
	bodyFlag = NO;
}

#pragma mark -
#pragma mark Complementos a consulta de WS 
+(NSData*)WSGetRequest:(NSString*)strURL
{
	NSURLResponse *response = nil;
	NSError *err = nil;
	NSMutableURLRequest *request = 
	[NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TIMEOUTREQUEST]; //Tiempo de espera de un minuto.
	
	[request setHTTPMethod:@"GET"];	
	
	NSData *dat = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];	
	
	if(dat == nil) //No data returned or reached timeout
	{
		
		NSString *pMsg = [NSString stringWithFormat:@"No se pudo conectar al servidor\no terminó el tiempo de espera para esta solicitud.\nCódigo de error: %d", [err code]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:pMsg delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		[alert show];
		[alert release];
		
		return FALSE;
	}	
	
	return dat;
}


+(NSData*)WSPostRequest:(NSString*)strURL param:(NSString*)strParam
{
	NSURLResponse *response = nil;
	NSError *err = nil;
	NSData *postData = [strParam dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TIMEOUTREQUEST]; //Tiempo de espera de un minuto.
	
	[request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:[NSString stringWithFormat:@"%d",[postData length]] forHTTPHeaderField:@"Content-Length"];
	
	[request setHTTPMethod:@"POST"];	
	
	//Post body
	[request setHTTPBody:postData];
	
	NSData *dat = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];	
	
	if(dat == nil) //No data returned or reached timeout
	{
		
		NSString *pMsg = [NSString stringWithFormat:@"No se pudo conectar al servidor\no terminó el tiempo de espera para esta solicitud.\nCódigo de error: %d", [err code]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:pMsg delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
		
		[alert show];
		[alert release];
	}
	
	return dat;
}

#pragma mark -
#pragma mark Url Connection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dataResp
{
	NSString *str = [[NSString alloc] initWithData:dataResp encoding:NSUTF8StringEncoding];
	[str release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
#if DEBUG
    NSLog(@"Ocurrio el timeout");
#endif
}

@end
