/*
 * QRCodeReaderViewController
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
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
 *
 */

#import "ViewController.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)scanAction:(id)sender
{
  if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
    static QRCodeReaderViewController *vc = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
      QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
      
      UIColor *bordersColor = [[UIColor alloc] initWithRed:216.0f/255.0f green:216.0f/255.0f blue:216.0f/255.0f alpha:1.0];
        vc = [[QRCodeReaderViewController alloc] initWithCancelButtonTitle:nil codeReader:reader startScanningAtLoad:true showSwitchCameraButton:false showTorchButton:true showMyQRCodeButton: NO chooseFromPhotoLibraryButtonTitle:@"Browse" bordersColor:bordersColor messageText: @"Point your camera on QR code" torchTitle:@"Light" torchImage:nil chooseFromPhotoLibraryButtonImage:nil myQRCodeText:@"My QRCode" myQRCodeImage:nil];
      vc.modalPresentationStyle = UIModalPresentationFormSheet;
    });
    vc.delegate = self;

    [vc setCompletionWithBlock:^(NSString *resultAsString) {
      NSLog(@"Completion with result: %@", resultAsString);
    }];

    [self presentViewController:vc animated:YES completion:NULL];
  }
  else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];

    [alert show];
  }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
  [reader stopScanning];

  [self dismissViewControllerAnimated:YES completion:^{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
  }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
  [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
