//
//  UIControl+Publisher.swift
//  Soulmate
//
//  Created by Sangmin Lee on 2022/11/14.
//

import UIKit
import Combine

extension UIControl {
    
    class EventSubscription<S: Subscriber>: Subscription where S.Input == Void {
        
        var subscriber: S?
        weak var control: UIControl?
        let event: UIControl.Event
        
        init(subscriber: S, control: UIControl, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            
            self.control?.addTarget(self, action: #selector(handleEvent), for: event)
        }
        
        @objc func handleEvent(_ sender: UIControl) {
            _ = self.subscriber?.receive(())
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            control?.removeTarget(self, action: #selector(handleEvent), for: event)
            subscriber = nil
        }
    }
    
    struct ControlEvent: Publisher {
        typealias Output = Void
        typealias Failure = Never
        
        let control: UIControl
        let event: UIControl.Event
        
        init(control: UIControl,
             event: UIControl.Event) {
            self.control = control
            self.event = event
        }
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Output == S.Input {
            let subscription = EventSubscription(
                subscriber: subscriber,
                control: control,
                event: event
            )
            
            subscriber.receive(subscription: subscription)
        }
    }
}
