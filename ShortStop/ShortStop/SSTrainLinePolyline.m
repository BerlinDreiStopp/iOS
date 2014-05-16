//
//  SSTrainLinePolyline.m
//  ShortStop
//
//  Created by joshua may on 16/05/2014.
//  Copyright (c) 2014 Berlin Drei Stopp. All rights reserved.
//

#import "SSTrainLinePolyline.h"

#import "SSStop.h"

@implementation SSTrainLinePolyline

+ (NSArray *)stopsForU1
{
    return @[
             @"Schlesisches Tor",
             @"Görlitzer Bahnhof",
             @"Kottbusser Tor",
             @"Prinzenstraße",
             @"Hallesches Tor",
             @"Möckernbrücke",
             @"Gleisdreieck",
             
             @"Kurfürstenstraße",
             @"Nollendorfplatz",
             @"Wittenbergplatz",
             @"Kurfürstendamm",
             @"Uhlandstraße",
             ];
}

+ (NSArray *)stopsForU2
{
    return @[
             @"Pankow", @"Vinetastraße", @"Schönhauser Allee", @"Eberswalder Straße", @"Senefelderplatz", @"Rosa-Luxemburg-Platz", @"Alexanderplatz", @"Klosterstraße", @"Märkisches Museum", @"Spittelmarkt", @"Hausvogteiplatz", @"Stadtmitte", @"Mohrenstraße", @"Potsdamer Platz", @"Mendelssohn-Bartholdy-Park", @"Gleisdreieck", @"Bülowstraße", @"Nollendorfplatz", @"Wittenbergplatz", @"Zoologischer Garten", @"Ernst-Reuter-Platz", @"Deutsche Oper", @"Bismarckstraße", @"Sophie-Charlotte-Platz", @"Kaiserdamm", @"Theodor-Heuss-Platz", @"Neu-Westend", @"Olympia-Stadion", @"Ruhleben"
             ];
}

+ (NSArray *)stopsForU3
{
    return @[
             @"Nollendorfplatz", @"Wittenbergplatz", @"Augsburger Straße", @"Spichernstraße", @"Hohenzollernplatz", @"Fehrbelliner Platz", @"Heidelberger Platz", @"Rüdesheimer Platz", @"Breitenbachplatz", @"Podbielskiallee", @"Dahlem-Dorf", @"Thielplatz", @"Oskar-Helene-Heim", @"Onkel Toms Hütte", @"Krumme Lanke"
             ];
}

+ (NSArray *)stopsForU4
{
    return @[
             @"Nollendorfplatz", @"Viktoria-Luise-Platz", @"Bayerischer Platz", @"Rathaus Schöneberg", @"Innsbrucker Platz"
             ];
}

+ (NSArray *)stopsForU5
{
    return @[
             @"Hönow", @"Louis-Lewin-Straße", @"Hellersdorf", @"Cottbusser Platz", @"Neue Grottkauer Straße", @"Kaulsdorf-Nord", @"Wuhletal", @"Elsterwerdaer Platz", @"Biesdorf-Süd", @"Tierpark", @"Friedrichsfelde", @"Lichtenberg", @"Magdalenenstraße", @"Frankfurter Allee", @"Samariterstraße", @"Frankfurter Tor", @"Weberwiese", @"Strausberger Platz", @"Schillingstraße", @"Alexanderplatz"
             ];
}

+ (NSArray *)stopsForU55
{
    return @[
             /*@"Berlin Hauptbahnhof",*/ /*@"Bundestag", */ @"Brandenburger Tor"
             ];
}

+ (NSArray *)stopsForU6
{
    return @[
             @"Alt-Tegel", @"Borsigwerke", @"Holzhauser Straße", @"Otisstraße", @"Scharnweberstraße", @"Kurt-Schumacher-Platz", @"Afrikanische Straße", @"Rehberge", @"Seestraße", @"Leopoldplatz", @"Wedding", @"Reinickendorfer Straße", @"Schwartzkopffstraße", @"Naturkundemuseum", @"Oranienburger Tor", @"Friedrichstraße", @"Französische Straße", @"Stadtmitte", @"Kochstraße", @"Hallesches Tor", @"Mehringdamm", @"Platz der Luftbrücke", @"Paradestraße", @"Tempelhof", @"Alt-Tempelhof", @"Kaiserin-Augusta-Straße", @"Ullsteinstraße", @"Westphalweg", @"Alt-Mariendorf"
             ];
}

+ (NSArray *)stopsForU7
{
    return @[
             @"Rathaus Spandau", @"Altstadt Spandau", @"Zitadelle", @"Haselhorst", @"Paulsternstraße", @"Rohrdamm", @"Siemensdamm", @"Halemweg", @"Jakob-Kaiser-Platz", @"Jungfernheide", @"Mierendorffplatz", @"Richard-Wagner-Platz", @"Bismarckstraße", @"Wilmersdorfer Straße", @"Adenauerplatz", @"Konstanzer Straße", @"Fehrbelliner Platz", @"Blissestraße", @"Berliner Straße", @"Bayerischer Platz", @"Eisenacher Straße", @"Kleistpark", @"Yorckstraße", @"Möckernbrücke", @"Mehringdamm", @"Gneisenaustraße", @"Südstern", @"Hermannplatz", @"Rathaus Neukölln", @"Karl-Marx-Straße", @"Neukölln", @"Grenzallee", @"Blaschkoallee", @"Parchimer Allee", @"Britz-Süd", @"Johannisthaler Chaussee", @"Lipschitzallee", @"Wutzkyallee", @"Zwickauer Damm", @"Rudow"
             ];
}

+ (NSArray *)stopsForU9
{
    return @[
             @"Osloer Straße", @"Nauener Platz", @"Leopoldplatz", @"Amrumer Straße", @"Westhafen", @"Birkenstraße", @"Turmstraße", @"Hansaplatz", @"Zoologischer Garten", @"Kurfürstendamm", @"Spichernstraße", @"Güntzelstraße", @"Berliner Straße", @"Bundesplatz", @"Friedrich-Wilhelm-Platz", @"Walther-Schreiber-Platz", @"Schloßstraße", @"Rathaus Steglitz"
             ];
}

+ (NSArray *)stopsForU8
{
    return @[
             @"Wittenau",
             @"Rathaus Reinickendorf",
             @"Karl-Bonhoeffer-Nervenklinik",
             @"Lindauer Allee",
             @"Paracelsus-Bad",
             @"Residenzstraße",
             @"Franz-Neumann-Platz",
             @"Osloer Straße",
             @"Pankstraße",
             @"Gesundbrunnen",
             @"Voltastraße",
             @"Bernauer Straße",
             @"Rosenthaler Platz",
             @"Weinmeisterstraße",
             @"Alexanderplatz",
             @"Jannowitzbrücke",
             @"Heinrich-Heine-Straße",
             @"Moritzplatz",
             @"Kottbusser Tor",
             @"Schönleinstraße",
             @"Hermannplatz",
             @"Boddinstraße",
             @"Leinestraße",
             @"Hermannstraße",
             ];
}

+ (UIColor *)colorForU1 { return [UIColor colorWithRed:0x7d/255.f green:0xad/255.f blue:0x4c/255.f alpha:1.f]; }
+ (UIColor *)colorForU2 { return [UIColor colorWithRed:0xda/255.f green:0x42/255.f blue:0x1e/255.f alpha:1.f]; }
+ (UIColor *)colorForU3 { return [UIColor colorWithRed:0x00/255.f green:0x7a/255.f blue:0x5b/255.f alpha:1.f]; }
+ (UIColor *)colorForU4 { return [UIColor colorWithRed:0xf0/255.f green:0xd7/255.f blue:0x22/255.f alpha:1.f]; }
+ (UIColor *)colorForU5 { return [UIColor colorWithRed:0x73/255.f green:0x33/255.f blue:0x30/255.f alpha:1.f]; }
+ (UIColor *)colorForU55 { return [UIColor colorWithRed:0x73/255.f green:0x33/255.f blue:0x30/255.f alpha:1.f]; }
+ (UIColor *)colorForU6 { return [UIColor colorWithRed:0x8c/255.f green:0x6d/255.f blue:0xab/255.f alpha:1.f]; }
+ (UIColor *)colorForU7 { return [UIColor colorWithRed:0x52/255.f green:0x8d/255.f blue:0xba/255.f alpha:1.f]; }
+ (UIColor *)colorForU8 { return [UIColor colorWithRed:0x22/255.f green:0x4f/255.f blue:0x86/255.f alpha:1.f]; }
+ (UIColor *)colorForU9 { return [UIColor colorWithRed:0xf3/255.f green:0x79/255.f blue:0x1d/255.f alpha:1.f]; }

+ (instancetype)polylineForStops:(NSArray *)stops color:(UIColor *)color
{
    CLLocationCoordinate2D *coordinateArray = malloc(sizeof(CLLocationCoordinate2D) * stops.count);

    NSInteger idx = 0;
    for (SSStop *stop in stops) {
        coordinateArray[idx++] = stop.coordinate;
    }

//    CLLocationCoordinate2D coordinateArray[3];
//    coordinateArray[0] = CLLocationCoordinate2DMake(52.4992490, 13.4181670); // kottbusser tor
//    coordinateArray[1] = CLLocationCoordinate2DMake(52.5037390, 13.4109470); // moritzplatz
//    coordinateArray[2] = CLLocationCoordinate2DMake(52.5108580, 13.4161690); // U Heinrich-Heine-Str

    SSTrainLinePolyline *p = [self polylineWithCoordinates:coordinateArray count:stops.count];
    p.color = color;
    return p;
}

@end
