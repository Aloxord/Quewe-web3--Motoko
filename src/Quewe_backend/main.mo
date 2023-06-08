import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Bool "mo:base/Bool";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import RbTree "mo:base/RBTree";

actor {

  type Customer = {
    name: Text;
    ticketNumber: Nat;
  };

  let queue = Buffer.Buffer<Customer>(0);
  let alreadyAttended = Buffer.Buffer<Customer>(0);
  stable var currentTicket: Nat = 0;
  stable var availableSlot: Nat = 1;

  public func addCustomer(customerName: Text) : async Text {

    let newCustomer: Customer = {
      name = customerName;
      ticketNumber = availableSlot;
    };

    queue.add(newCustomer);

    availableSlot += 1;

    return "Please wait for your turn " # customerName #" you have the number: " # Nat.toText(newCustomer.ticketNumber);
  };

  public func attendCustomer(): async Text {
    if((currentTicket + 1) == availableSlot){
      return "There is not customers to attend";
    };
    currentTicket += 1;
    var nextUser: Customer = queue.remove(0);
    alreadyAttended.add(nextUser);

    return "The user with the number: "# Nat.toText(nextUser.ticketNumber) #" has been attended, "# nextUser.name;
  };

  public query func getAttended() : async [Customer] {
    return Buffer.toArray<Customer>(alreadyAttended);
  };

  public query func getQueue() : async [Customer] {
    return Buffer.toArray<Customer>(queue);
  };

  public func clearCustomers() : async Text {
    currentTicket -= currentTicket;
    availableSlot -= (availableSlot - 1);
    queue.clear();
    alreadyAttended.clear();
    return "The day's customer information has been cleaned up";
  };
};