//
//  NLPLayer.swift
//  ResumeScreener
//
//  Created by Cyril Garcia on 2/28/21.
//

import UIKit
import CoreML
import NaturalLanguage

final class NLPLayer {
    
    var nlModel: NLModel?
    
    var parsedInfo = [String: String]()
    
    init() {
        do {
            let mlModel = try CustomTagger(configuration: MLModelConfiguration()).model
            nlModel = try NLModel(mlModel: mlModel)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func parse(_ text: String) {
        findPosition(text)
        findUserInfo(text)
    }
    
    func findPosition(_ text: String) {
        guard let nlModel = nlModel else { return }
        let customTagScheme = NLTagScheme("Custom")
        
        let tagger = NLTagger(tagSchemes: [.nameType, customTagScheme])
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]

        tagger.string = text
        tagger.setModels([nlModel], forTagScheme: customTagScheme)
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: customTagScheme, options: options) { (tag, range) -> Bool in
            
            guard let tag = tag else { return true }
            if tag.rawValue == "NONE" { return true }
            parsedInfo[tag.rawValue] = "\(text[range])"
            
            return true
        }
    }
    
    func findUserInfo(_ text: String) {
        let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
        tagger.string = text
        
        let range = NSMakeRange(0, text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .joinNames]
        
        let tags = [NSLinguisticTag.personalName, .placeName, .organizationName, .number]
        
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber, .allSystemTypes]
        let detector = try! NSDataDetector(types: types.rawValue)
        
        detector.enumerateMatches(in: text, options: [], range: range) { (res, _, _) in
            if let phoneNumber = res?.phoneNumber {
                parsedInfo["PhoneNumber"] = phoneNumber
            }
            
            if let url = res?.url {
                parsedInfo["Email"] = url.absoluteString.components(separatedBy: ":").last!
            }
        }
        
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, range, stop in
            guard let tag = tag else { return }
            
            if tags.contains(tag) {
                let token = (text as NSString).substring(with: range)
                parsedInfo[tag.rawValue] = token
            }

        }
    }
}
