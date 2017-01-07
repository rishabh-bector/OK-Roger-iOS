//
//  CardIOViewController.swift
//  HelloWorld
//
//  Created by Rishabh Bector on 1/2/17.
//  Copyright © 2017 Rishabh Bector. All rights reserved.
//

import UIKit

class ScanningViewController: UIViewController, CardIOPaymentViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CardIOUtilities.preload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanCard(sender: AnyObject) {
        //open cardIO controller to scan the card
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
        
    }
    
    //MARK: - CardIO Methods
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        print("user canceled")
        paymentViewController?.dismiss(animated: true, completion: nil)
    }
    
    //Callback when card is scanned correctly
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            let str = NSString(format: "Received card info.\n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
            print(str)
            
            //dismiss scanning controller
            paymentViewController?.dismiss(animated: true, completion: nil)
            
            //create Stripe card
            //let card: STPCardParams = STPCardParams()
            //card.number = info.cardNumber
            //card.expMonth = info.expiryMonth
            //card.expYear = info.expiryYear
            //card.cvc = info.cvv
            
            //Send to Stripe
            //getStripeToken(card)
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
