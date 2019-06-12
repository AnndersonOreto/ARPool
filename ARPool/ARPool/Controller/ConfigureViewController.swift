
import UIKit

class ConfigureViewController: UIViewController {

    @IBOutlet weak var switchOutlet: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switchOutlet.isOn = UserDefaults.standard.bool(forKey: "switchState")
    }

    @IBAction func dismissActionButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func TypeOfColorSwitch(_ sender: UISwitch) {
        if sender.isOn == true{
            color = .colorBlindGame
            print("ativado")
        }else{
            color = .defaultGame
            print("desativado")
        }
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
    }
}
