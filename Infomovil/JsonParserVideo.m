//
//  JsonParserVideo.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 04/09/14.
//  Copyright (c) 2014 Sergio Sánchez Flores. All rights reserved.
//

#import "JsonParserVideo.h"

@implementation JsonParserVideo

-(void)buscarVideo:(NSString *)criterioBusqueda conTipo:(NSInteger) tipoBusqueda; {
    NSString *urlBusqueda;
    self.tipoBusqueda = tipoBusqueda;
    if (tipoBusqueda == 1) { //Videos en base a una frase
        criterioBusqueda = [criterioBusqueda stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        urlBusqueda = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&q=%@&maxResults=20&key=AIzaSyBfyUsYuAxuiHu1IeOW-L6dbfkNfEIEIEU",criterioBusqueda];
    }
    else {// video con el id
        urlBusqueda = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos/%@?alt=json", criterioBusqueda];
        NSLog(@"ENTRO A VIDEO CON EL ID");
    }
    NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlBusqueda]];
    if(urlData != nil){
        [self iniciarParseo:urlData];
    }else{
        [self.delegate errorBusqueda];
    }
}

-(void) iniciarParseo:(NSData *)dataWeb {
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:dataWeb options:kNilOptions error:&error];
    NSLog(@"EL DICCIONARIO QUE ME REGRESA ES: %@", jsonDict);
    self.arregloVideos = [[NSMutableArray alloc] init];
    if (error != nil) {
        //        
    }
    else {
        if (self.tipoBusqueda == 1) {
            NSDictionary *dictFeed = [jsonDict objectForKey:@"items"];
            for (int i = 0; i < [dictFeed count]; i++) {
                NSDictionary *dictFeed = [[jsonDict objectForKey:@"items"] objectAtIndex:i];
                NSDictionary *dictAux = [dictFeed objectForKey:@"id"];
                NSDictionary *dictAux2 = [dictFeed objectForKey:@"snippet"];
                NSDictionary *dictAux3 = [[dictAux2 objectForKey:@"thumbnails"]objectForKey:@"default"];
                [self recuperaVideo:dictAux dict2:dictAux2 dict3:dictAux3 ];
            }
        }
        
    }
    [self.delegate resultadoVideo:self.arregloVideos];
}

-(void) recuperaVideo:(NSDictionary *) dictAux dict2:(NSDictionary *) dictAux2 dict3:(NSDictionary *) dictAux3 {
    VideoModel *video = [[VideoModel alloc] init];
    video.titulo = [dictAux2 objectForKey:@"title"];
    NSLog(@"TITULO: %@", video.titulo);
    video.descripcionVideo = [dictAux2 objectForKey:@"description"];
    NSLog(@"DESCRIPTION: %@", video.description);
    video.thumbnail = [dictAux3 objectForKey:@"url"];
    NSLog(@"THUMBNAIL: %@", video.thumbnail);
    NSData *img = [NSData dataWithContentsOfURL:[NSURL URLWithString:video.thumbnail]];
    video.imagenPrevia = [UIImage imageWithData:img];
    video.idVideo = [dictAux objectForKey:@"videoId"];
    NSLog(@"VIDEOID: %@", video.idVideo);
    video.linkSolo = [NSString stringWithFormat:@"http://www.youtube.com/embed/%@", video.idVideo];
    [self.arregloVideos addObject:video];
}

@end
