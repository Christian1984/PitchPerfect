//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Christian Hoffmann on 01.01.15.
//  Copyright (c) 2015 be-amazed. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    private let filePathUrl: NSURL!
    private let title: String?
//    var test: String {
//        get {
//            return self.test
//        }
//    }
    
    init(filePathUrl: NSURL, title: String?)
    {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
    func getFilePathUrl() -> NSURL
    {
        return filePathUrl
    }
    
    func getTitle() -> String
    {
        if title != nil
        {
            return title!
        }
        else
        {
            return "none"
        }
    }
}