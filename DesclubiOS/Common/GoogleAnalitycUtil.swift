//
//  CrashlitycsUtil.swift
//  SegurosRecompensa
//
//  Created by Sergio Maturano on 9/8/16.
//  Copyright © 2016 Grupo Medios. All rights reserved.
//

import Foundation

class GoogleAnalitycUtil: AnyObject {
    
    class func setupGoogleAnalityc() {
        // Configure tracker from GoogleService-Info.plist.
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        // Optional: configure GAI options.
        let gai = GAI.sharedInstance()
        gai.trackUncaughtExceptions = true  // report uncaught exceptions
        gai.logger.logLevel = GAILogLevel.Verbose  // remove before app release
    }
    
    class func trackScreenName(name: String){
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
}