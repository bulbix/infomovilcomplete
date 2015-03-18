//
//  FondoPaso1ViewController.m
//  Infomovil
//
//  Created by Sergio Sánchez Flores on 30/12/13.
//  Copyright (c) 2013 Sergio Sánchez Flores. All rights reserved.
//

#import "FondoPaso1ViewController.h"
#import "ColorPickerViewController.h"
#import "UIImage+Color.h"

@interface FondoPaso1ViewController () {
//    BOOL self.modifico;
}

@property (nonatomic, strong) UIImage *imagenSeleccionada;

@end

@implementation FondoPaso1ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.vistaCircular setImage:[UIImage imageNamed:@"plecaazul.png"]];
    
    self.navigationItem.hidesBackButton = YES;
    UIImage *image = [UIImage imageNamed:@"btnregresar.png"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(regresar:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonBack;
    
    self.imagenFondo.layer.borderWidth = 0.5f;
    self.imagenFondo.layer.cornerRadius = 5;
    self.imagenFondo.layer.masksToBounds = YES;
    self.imagenFondo.layer.borderColor = [colorBackground CGColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.datosUsuario = [DatosUsuario sharedInstance];
    [self.tituloVista setHidden:NO];
    [self.tituloVista setText:NSLocalizedString(@"tituloFondo", @" ")];
    [self.tituloVista setTextColor:[UIColor whiteColor]];
    if (self.datosUsuario.eligioTemplate) {
        [self.imagenFondo setImage:[UIImage imageWithColor:self.datosUsuario.colorSeleccionado]];
    }
    else {
        NSString *filePath = [[StringUtils pathForDocumentsDirectory] stringByAppendingPathComponent:@"imagenFondo.png"];
        NSData *pngData = [NSData dataWithContentsOfFile:filePath];
        UIImage *image = [UIImage imageWithData:pngData];
        if (image != nil) {
            [self.imagenFondo setImage:image];
        }
    }
}

- (IBAction)tomarFoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setSourceType:(UIImagePickerControllerSourceTypeCamera)];
    [self presentViewController:picker animated:YES completion:Nil];
}

- (IBAction)usarFoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate:self];
    [picker setSourceType:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)];//UIImagePickerControllerSourceTypePhotoLibrary
    [self presentViewController:picker animated:YES completion:Nil];
}

- (IBAction)seleccionarColor:(UIButton *)sender {
    ColorPickerViewController *colorPicker = [[ColorPickerViewController alloc] initWithNibName:@"ColorPickerViewController" bundle:Nil];
    [self.navigationController pushViewController:colorPicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.modifico = YES;
    self.datosUsuario.eligioTemplate = NO;
    self.imagenSeleccionada = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self openEditor:Nil];
    }];
}

- (IBAction)openEditor:(id)sender {
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = self.imagenSeleccionada;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    NSLog(@"Aqui se deberia de mostar");
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [controller dismissViewControllerAnimated:YES completion:NULL];
    self.imagenSeleccionada = croppedImage;
    [self.imagenFondo setImage:self.imagenSeleccionada];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

-(IBAction)regresar:(id)sender {
    [[self view] endEditing:YES];
    AlertView *alertView;
    if (self.modifico && [CommonUtils hayConexion]) {
        alertView = [AlertView initWithDelegate:self message:NSLocalizedString(@"preguntaGuardar", @" ") andAlertViewType:AlertViewTypeQuestion];
        [alertView show];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - AlertViewDelegate

-(void) accionSi {
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void) accionNo {
    NSData *pngData = UIImagePNGRepresentation(self.imagenSeleccionada);
    NSString *filePath = [[StringUtils pathForDocumentsDirectory] stringByAppendingPathComponent:@"imagenFondo.png"];
    [pngData writeToFile:filePath atomically:YES];
    self.datosUsuario.pathFondo = filePath;
    self.modifico = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)guardarInformacion:(id)sender {
    NSData *pngData = UIImagePNGRepresentation(self.imagenSeleccionada);
    NSString *filePath = [[StringUtils pathForDocumentsDirectory] stringByAppendingPathComponent:@"imagenFondo.png"];
    [pngData writeToFile:filePath atomically:YES];
    self.datosUsuario.pathFondo = filePath;
    self.modifico = NO;
}

@end