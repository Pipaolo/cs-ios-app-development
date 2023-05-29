


struct AtmAccount {
    var name: String
    var pin: String
    var balance: Float
}

struct Bill {
    var name: String
}


struct MainMenuState {
    var choice: Int
    var shouldRelogin: Bool

    mutating func reset() {
        self.choice = 0
        self.shouldRelogin = false
    }
}

var bills = [Bill(name: "Meralco"), Bill(name: "Maynilad")]
var account = AtmAccount(name: "Reginald Trey Tolentino", pin: "1234", balance: 30000.00)
var mainMenu = MainMenuState(choice: 0, shouldRelogin: false)



func login() -> Bool {

    var incorrectPinCount = 0
    let incorrectMaxCount = 4

    while incorrectPinCount < incorrectMaxCount - 1 {
        print("Enter PIN: ")

        let pin = readLine()!

        if(pin == "q") {
            return false
        } else if (pin != account.pin){
            print("Incorrect PIN. Please try again.")
            incorrectPinCount += 1
        } else {
            mainMenu.reset()
            return true
        }
    }

    print("Maximum number of incorrect PIN attempts reached. Please try again later.")
    return false
}

func transferMoney()   {
    print("Enter bank name: ")
    let bankName = readLine()!
    print("Enter account number: ")
    let accountNumber = readLine()!
    print("Enter account name: ")
    let accountName = readLine()!

    print("Enter amount to transfer: ")
    let amount = Float(readLine()!)!
    
    if(amount > account.balance) {
        print("Insufficient balance.")
    } else {
        account.balance -= amount
        print("You have transferred \(amount) to \(bankName) with account number \(accountNumber) and account name \(accountName). Your new balance is \(account.balance)")
    }
}

func payBill()  {
    print("Choose bill to pay: ")
    for (index, bill) in bills.enumerated() {
        print("\(index + 1). \(bill.name)")
    }

    let choice = Int(readLine()!)!

    if(choice > bills.count) {
        print("Invalid choice.")
        return
    }

    print("Enter account number: ")
    let accountNumber = readLine()!

    print("Enter amount to pay: ")
    let amount = Float(readLine()!)!

    if(amount > account.balance) {
        print("Insufficient balance.")
    } else {
        account.balance -= amount
        print ("You have paid \(bills[choice - 1].name) with account number \(accountNumber). Your new balance is \(account.balance)")
    }
}


func startMainMenu()  {
    func printMenu() {
        print("\n")
        print("Welcome [\(account.name)] to your account.")
        print("1. Balance Inquiry")
        print("2. Withdraw Cash")
        print("3. Transfer Money")
        print("4. Change Pin")
        print("5. Pay Bills")
        print("7. Deposit Money")
        print("8. Exit")
    }

    while mainMenu.choice != 8 && mainMenu.choice != 4 {
        printMenu()
        print("\n")
        print("Enter choice: ")
        mainMenu.choice = Int(readLine()!)!

        switch mainMenu.choice {
            case 1:
                print("Your balance is \(account.balance)")
            case 2:
                print("Enter amount to withdraw: ")
                let amount = Float(readLine()!)!
                if(amount > account.balance) {
                    print("Insufficient balance.")
                } else {
                    account.balance -= amount
                    print("You have withdrawn \(amount). Your new balance is \(account.balance)")
                }
            case 3:
                transferMoney()
            case 4:
                print("Enter new pin: ")
                let newPin = readLine()!
                account.pin = newPin
                print("You have changed your pin to \(newPin)")
                print("Please login again.")
                mainMenu.shouldRelogin = true
            case 5:
                // Pay Bill
                payBill()
            case 7:
                print("Enter amount to deposit: ")
                let amount = Float(readLine()!)!
                account.balance += amount
                print("You have deposited \(amount). Your new balance is \(account.balance)")
            case 8:
                break
            default:
                print("Invalid choice.")
        }
    }
}

// Function that returns a string
func start() {
    print("\n\n [Idakimasu~ Bank Inc.]")

    let isLoggedIn = login()

    if(isLoggedIn) {
        startMainMenu()
    }

    if(!mainMenu.shouldRelogin) {
        print("Thank you for using our service.")
        return
    }
    start()
}

start()