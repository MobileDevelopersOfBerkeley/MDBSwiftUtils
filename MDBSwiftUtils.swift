//
//  MDBSwiftUtils.swift
//  DealOn
//
//  Created by Akkshay Khoslaa on 4/25/16.
//  Copyright © 2016 Akkshay Khoslaa. All rights reserved.
//


import Foundation
import UIKit
import CoreLocation
class MDBSwiftUtils {
    
    
    /**
     Returns the time since an NSDate as a properly formatted string.
     
     - returns:
     time passed since oldTime as properly formatted string
     
     - parameters:
        - oldTime: we want to find time elapsed since this time
     */
    class func timeSince(oldTime: NSDate) -> String {
        var timePassedString = ""
        let currDate = NSDate()
        let passedTime:NSTimeInterval = currDate.timeIntervalSinceDate(oldTime)
        if Double(passedTime) < 60.0 {
            timePassedString = String(Int(Double(passedTime)))
            if Int(Double(passedTime)) == 1 {
                timePassedString += " sec ago"
            } else {
                timePassedString += " secs ago"
            }
        } else if Double(passedTime) < 3600.0 {
            timePassedString = String(Int(Double(passedTime)/60))
            if Int(Double(passedTime)/60) == 1 {
                timePassedString += " min ago"
            } else {
                timePassedString += " mins ago"
            }
        } else if Double(passedTime) < 86400.0 {
            timePassedString = String(Int(Double(passedTime)/3600))
            if Int(Double(passedTime)/3600) == 1 {
                timePassedString += " hr ago"
            } else {
                timePassedString += " hrs ago"
            }
        } else {
            timePassedString = String(Int(Double(passedTime)/86400.0))
            if Int(Double(passedTime)/86400.0) == 1 {
                timePassedString += " day ago"
            } else {
                timePassedString += " days ago"
            }
        }
        
        return timePassedString
    }
    
    /**
     Returns a random number between 2 numbers.
     
     - returns:
     random number as CGFloat
     
     - parameters:
        - firstNum: the returned number must be greater than this
        - secondNum: the returned number must be less than this
     */
    class func randomNumBetween(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    
    /**
     Returns a currency formatted string.
     
     - returns:
     val formatted as a currency string
     
     - parameters:
        - val: value to be converted to currency string
     */
    class func doubleToCurrencyString(val: Double) -> String {
        if (val * 100) % 100 == 0 {
            return "$" + String(Int(val))
        } else {
            let currencyFormatter = NSNumberFormatter()
            currencyFormatter.numberStyle = .CurrencyStyle
            return currencyFormatter.stringFromNumber(val)!
        }
    }
    
    /**
     Formats a label to support dynamic content and expand to multiple lines if needed.
     
     - parameters:
        - label: the label to be formatted
     */
    class func formatMultiLineLabel(label: UILabel) {
        label.lineBreakMode = .ByWordWrapping
        label.numberOfLines = 0
    }
    
    /**
     Returns the expected height of the label based on the text. Assumes that label is formatted to support multiple lines and dynamic content.
     
     - returns:
     expected height of the label as CGFloat
     
     - parameters:
        - content: text that will be put in the label
        - maxWidth: the maxWidth the label can be
        - font: the font used by the label
     */
    class func getMultiLineLabelHeight(content: String, maxWidth: Int, font: UIFont) -> CGFloat {
        let contentString = content
        let maximumLabelSize: CGSize = CGSizeMake(CGFloat(maxWidth), 1000)
        let options: NSStringDrawingOptions = [.TruncatesLastVisibleLine, .UsesLineFragmentOrigin]
        let attr : [String: AnyObject] = [NSFontAttributeName:  font]
        let labelBounds: CGRect = contentString.boundingRectWithSize(maximumLabelSize, options: options, attributes: attr, context: nil)
        let labelHeight: CGFloat = labelBounds.size.height
        return labelHeight
        
    }
  
    
    /**
     Starts location services by requesting authorization if needed.
     
     - parameters:
        - locationManager: CLLocationManager instance being used in your VC
        - currVC: the VC you are calling this function in. Make sure it includes CLLocationManagerDelegate
     */
    func startLocationServices(locationManager: CLLocationManager, currVC: CLLocationManagerDelegate) {
        locationManager.delegate = currVC
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = currVC
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    /**
     Check if location services are authorized, and if they are get the current location. Make sure you call startLocationServices() first.
     
     - returns:
     the current location as CLLocation if location services are authorized; otherwise returns CLLocation(latitude: 0, longitude: 0)
     
     - parameters:
        - locationManager: CLLocationManager instance being used in your VC
     */
    func getCurrentLocation(locationManager: CLLocationManager) -> CLLocation {
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized){
                
                return locationManager.location!
                
        } else {
            return CLLocation(latitude: 0, longitude: 0)
        }
    }
    
    /**
     Shows a basic alert with an "OK" button to dismiss.
     
     - parameters:
        - title: title to display at the top of the alert
        - content: message to display in alert
        - currVC: the ViewController in which this function is being called
     */
    func showBasicAlert(title: String, content: String, currVC: UIViewController) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        currVC.presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
     Returns a UIImage rendered with a given alpha.
     
     - returns:
     a UIImage with an alpha applied to it
     
     - parameters:
        - alpha: the alpha that you want the new image to have
        - image: the image you are applying the alpha to
     
     */
    func imageWithAlpha(alpha: CGFloat, image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        let area: CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        CGContextScaleCTM(context, 1, -1)
        CGContextTranslateCTM(context, 0, -area.size.height)
        CGContextSetBlendMode(context, CGBlendMode.Multiply)
        CGContextSetAlpha(context, alpha)
        CGContextDrawImage(context, area, image.CGImage)
        let alphaImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return alphaImage
    }

    /**
     Adds an image to the end of a label.
     
     - parameters:
        - label: label we want to add the image to
        - labelText: the text that the label should have
        - image: the image that we want to add to the label
     */
    func addImageToLabel(label: UILabel, labelText: String, image: UIImage) {
        let attachment = NSTextAttachment()
        attachment.image = image
        let attachmentString = NSAttributedString(attachment: attachment)
        let textString = NSMutableAttributedString(string: labelText)
        textString.appendAttributedString(attachmentString)
        label.attributedText = textString
    }
    
    /**
     Set the image of a UIImageView from a url.
     
     - parameters:
        - urlString: url of the image as a String
        - imageView: imageView that we want to set the image of
     */
    func setImageViewImageFromUrl(urlString: String, imageView: UIImageView) {
        let url = NSURL(string: urlString)!
        let data = NSData(contentsOfURL: url)
        let image = UIImage(data: data!)!
        imageView.image = image
    }
    
    /**
     Get JSON object as an NSDictionary from a url using HTTP GET request.
     
     - parameters:
        - urlString: url for the request as a String
        - completion: block to be called once JSON object is retrieved
    */
    
    func httpJSONGETRequest(urlString: String, completion: (NSDictionary) -> Void) {
        let url: NSURL = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let opQueue = NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: opQueue, completionHandler:{ (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            do {
                
                if let result = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    completion(result)
                }
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        })
    }
    
    
}