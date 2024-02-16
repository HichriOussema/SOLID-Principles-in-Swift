import UIKit

//Before applying the Dependency Inversion Principle, the high-level module directly depends on the low-level module.
//This means that any changes or updates in the low-level module will affect the high-level module, leading to a tightly coupled system.
// Let's take an example of a payment system:
/*
class PaymentProcessor {
    private let paymentGateway: PaymentGateway
    private let paypalGateway: PayPalGateway?

    init(usePayPal: Bool = false) {
        if usePayPal {
            paypalGateway = PayPalGateway()
            paymentGateway = PaymentGateway() // Still need this for cases when PayPal is not used
        } else {
            paypalGateway = nil
            paymentGateway = PaymentGateway()
        }
    }

    func processPayment(amount: Double) {
        if let paypal = paypalGateway {
          paypal.processPayment(amount: amount)
        } else {
          paymentGateway.processPayment(amount: amount)
        }
    }
}

class PayPalGateway {
    func processPayment(amount: Double) {
        print("Processing payment through PayPal: Amount \(amount)")
    }
}

class PaymentGateway {
    func processPayment(amount: Double) {
        print("Processing payment through Basic Payment Gateway: Amount \(amount)")
    }
}
*/

/*Tight Coupling: The PaymentProcessor is tightly coupled with specific payment gateway implementations (PaymentGateway and PayPalGateway). Any change in the payment gateway logic or the addition of new gateways requires changes to the PaymentProcessor.
 
 Scalability Issues: As you add more payment gateways (like Stripe, Apple Pay, etc.), the PaymentProcessor class becomes more complex and harder to manage.

 Testing Difficulties: Testing the PaymentProcessor becomes more challenging as it directly depends on concrete gateway implementations.

 Violation of Single Responsibility Principle: The PaymentProcessor is handling not only the processing of payments but also the decision logic of which payment gateway to use.

*/


///SOLUTION: DEPENDENCY INVERSION PRINCIPLE

//Step 1: Define an Abstraction for Payment Gateway
//First, define a protocol (an abstraction) that all payment gateways will implement:

protocol PaymentGatewayProtocol {
    func processPayment(amount: Double)
}

//Step 2: Implement the Protocol with Different Payment Gateways
//Create concrete classes for each payment gateway, implementing the PaymentGatewayProtocol:

class BasicPaymentGateway: PaymentGatewayProtocol {
    func processPayment(amount: Double) {
        print("Processing payment through Basic Payment Gateway: Amount \(amount)")
    }
}

class PayPalGateway: PaymentGatewayProtocol {
    func processPayment(amount: Double) {
        print("Processing payment through PayPal: Amount \(amount)")
    }
}

// You can easily add more gateways following the same pattern.

//Step 3: Refactor PaymentProcessor to Depend on the Abstraction
//Modify PaymentProcessor to depend on the PaymentGatewayProtocol rather than a concrete class:

class PaymentProcessor {
    private let paymentGateway: PaymentGatewayProtocol
  
  // Dependency is injected through the constructor 
    init(paymentGateway: PaymentGatewayProtocol) {
        self.paymentGateway = paymentGateway
    }

    func processPayment(amount: Double) {
      paymentGateway.processPayment(amount: amount)
    }
}

/*Benefits of This Approach
Decoupling: PaymentProcessor is now decoupled from the specific types of payment gateways. It depends solely on the PaymentGatewayProtocol.

Flexibility: You can easily introduce new payment gateways without changing the PaymentProcessor class.

Ease of Testing: You can mock different payment gateways in your tests since PaymentProcessor depends on an abstraction.

 Scalability: Adding a new payment gateway is as simple as creating a new class that implements PaymentGatewayProtocol.*/
let basicGateway = BasicPaymentGateway()
let paymentProcessorWithBasic = PaymentProcessor(paymentGateway: basicGateway)
paymentProcessorWithBasic.processPayment(amount: 100.0)

let paypalGateway = PayPalGateway()
let paymentProcessorWithPayPal = PaymentProcessor(paymentGateway: paypalGateway)
paymentProcessorWithPayPal.processPayment(amount: 200.0)

