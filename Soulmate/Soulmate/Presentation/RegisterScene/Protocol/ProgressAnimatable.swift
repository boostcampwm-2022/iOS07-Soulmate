//
//  ProgressAnimatable.swift
//  Soulmate
//
//  Created by Hoen on 2022/11/17.
//

import UIKit

protocol ProgressAnimatable: UIViewController {
    
    func preset()
    func setPushInitStateAsTo()
    func setPushFinalStateAsTo()
    func setPushInitStateAsFrom()
    func setPushFinalStateAsFrom()
    func setPopInitStateAsTo()
    func setPopFinalStateAsTo()
    func setPopInitStateAsFrom()
    func setPopFinalStateAsFrom()
    func reset()
    
    
}
