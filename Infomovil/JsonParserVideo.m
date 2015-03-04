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
        urlBusqueda = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos?q=%@&max-results=20&alt=json", [StringUtils eliminarAcentos:criterioBusqueda]];
    }
    else {// video con el id
        urlBusqueda = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/videos/%@?alt=json", criterioBusqueda];
    }
    NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlBusqueda]];
    [self iniciarParseo:urlData];
}

-(void) iniciarParseo:(NSData *)dataWeb {
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:dataWeb options:kNilOptions error:&error];
    self.arregloVideos = [[NSMutableArray alloc] init];
    if (error != nil) {
        //        
    }
    else {
        NSArray *arreglo;
        if (self.tipoBusqueda == 1) {
            NSDictionary *dictFeed = [jsonDict objectForKey:@"feed"];
            arreglo = [dictFeed objectForKey:@"entry"];
            for (int i = 0; i < [arreglo count]; i++) {
                NSDictionary *dictAux = [arreglo objectAtIndex:i];
                [self recuperaVideo:dictAux];
            }
        }
        else {
            NSDictionary *dictAux = [jsonDict objectForKey:@"entry"];
            [self recuperaVideo:dictAux];
        }
    }
    [self.delegate resultadoVideo:self.arregloVideos];
}

-(void) recuperaVideo:(NSDictionary *) dictAux {
    VideoModel *video = [[VideoModel alloc] init];
    video.link = [dictAux objectForKey:@"link"];
    video.linkSolo = [[[dictAux objectForKey:@"link"] objectAtIndex:0] objectForKey:@"href"];
    video.autor = [[[[dictAux objectForKey:@"author"] objectAtIndex:0] objectForKey:@"name"] objectForKey:@"$t"];
    video.titulo = [[dictAux objectForKey:@"title"] objectForKey:@"$t"];
    video.descripcionVideo = [[dictAux objectForKey:@"content"] objectForKey:@"$t"];
    video.thumbnail = [[dictAux objectForKey:@"media$group"] objectForKey:@"media$thumbnail"];
    video.categoria = [[[dictAux objectForKey:@"category"] objectAtIndex:1] objectForKey:@"label"];
    NSData *img = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[video.thumbnail objectAtIndex:3] objectForKey:@"url"]]];
    video.imagenPrevia = [UIImage imageWithData:img];
    NSArray *arrayVideoAux = [video.linkSolo componentsSeparatedByString:@"watch?v="];
    arrayVideoAux = [[arrayVideoAux objectAtIndex:1] componentsSeparatedByString:@"&"];
    video.idVideo = [arrayVideoAux objectAtIndex:0];
    video.linkSolo = [NSString stringWithFormat:@"http://www.youtube.com/embed/%@", video.idVideo];
    [self.arregloVideos addObject:video];
}

@end
