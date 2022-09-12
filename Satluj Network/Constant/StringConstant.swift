//
//  StringConstant.swift
//  Satluj Network
//
//  Created by Brahma Naidu on 02/04/22.
//

import Foundation
struct UniversalText {
    static let deviceType = "ios"
    static let deviceToken = "abc"
    static let lat = "0.0"
    static let long = "0.0"
    static let VerifyPhone = "A verification code has been sent to\nyour phone number."
    static let VerifyEmail = "A verification code has been sent to\nyour email."
}
enum SocialType:String {
    case facebook = "facebook"
    case gmail = "google"
    case apple = "apple"
}

struct Alert {
    struct CreateProfile {
        static let first_name_field_empty = "Please enter first name"
        static let profile_image_empty = "Please choose a profile image"
        static let image_empty = "Please choose/replace a image"
        static let nameBlankMsg = "Please fill your name."
        static let surnameBlankMsg = "Please fill your surname name."
        static let surnameValidMsg = "Surname should't be less than 4 character"
        static let emailBlankMsg = "Please fill your email."
        static let phoneBlankMsg = "Please fill your phone number."
        static let phoneValidBlankMsg = "Please fill valid phone number."
        static let optAError = "Please enter OTP."
        static let TermsError = "Please agree to Terms and Conditions and Privacy Policy."
        static let email_field_empty = "Please enter valid email"
        static let avatarErrorMsg = "Please choose the avatar for your profile."
        static let pwdBlankMsg = "Please fill your password."
        static let pwdoldBlankMsg = "Please fill your old password."
        static let pwdnewBlankMsg = "Please fill your new password."
        static let pwdconfirmBlankMsg = "New and confirm password does not match."
        static let pwdErrorMsg = "Please choose a valid password. It needs to be alphanumeric with minimum of 6 characters"
        static let dobBlankMsg = "Please choose your birthday."
        static let notAllowed = "You didn't allow to change password of social login."
        
        static let validAge = "Make sure this is your correct age as you can't change this later"
    }
    struct Button {
        static let Okay = "OK"
        static let Cancel = "Cancel"
        static let Setting = "Settings"
        static let gallery = "Photo Library"
        static let camera = "Take a Photo"
        static let file = "Add a file"
        static let ContinueButton = "Continue"

    }
    
    
    struct Error {
        static let userNotFound = "User Not Found"
        static let fbUserNotFound = "facebook user not found."
        static let invalid = "Please enter valid mobile number. It can't be less than 9 numbers."
        static let appleId = "Apple user not found."
        static let no_internet_connection = "You are not connected to the internet. Please check your connection and try again"
        static let invalidQrCode = "Invalid Qr code"
        static let range = "Please select valid range"
        static let wrong = "SomeThing went wrong"
        static let Email = "There is no email app in your phone.\nDo you want to copy this link?"
    }
    
}

struct SegmentText{
    static let episode = "Episodes"
    static let moredetail = "More Details"
}

struct MoreDetailText{
    static let title = "Title"
    static let genre = "Genre"
    static let director = "Director"
    static let producer = "Executive Producer"
    static let music = "Music"
    static let makeUp = "Make Up"
    static let photography = "Director of photography"
    static let castandcrew = "Cast & Crew"
}



struct Steps {
    static let zero = "0"
    static let one = "1"
    static let two = "2"
    static let three = "3"
    static let four = "4"
    static let five = "5"
}
