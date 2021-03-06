//
//  ViewController.swift
//  100DaysOfSwift-Project1
//
//  Created by João Gabriel Dourado Cervo on 24/01/21.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true // titulos grandes
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recommendApp))

        title = "Storm Viewer"
        
        // Carrega as imagens na background thread
        performSelector(inBackground: #selector(fetchImages), with: nil)
    }
    
    @objc func fetchImages() {
        let fm = FileManager.default // Trabalhar com filesystem
        let path = Bundle.main.resourcePath! // diretorio do bundle do app
        let items = try! fm.contentsOfDirectory(atPath: path) // conteudo do diretorio

        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        pictures.sort() // Organiza o nome das imagens em ordem alfabetica
        
        // Recarrega UI de volta na main
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // Quantas linhas na tableview
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // Conteudo de cada linha
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) // Cria uma cell reusavel
        cell.textLabel?.text = pictures[indexPath.row]
        
        return cell
    }
    
    // Quando clicar em um item na lista
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Tenta carregar o "Detail" view controller e faz typecasting para o tipo DetailViewController
        // O typecasting é necessário visto que o swift retorna sempre como UIViewController
        if let selectedVC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // Seta a variavel nome com o nome da imagem
            selectedVC.selectedImageName = pictures[indexPath.row]
            selectedVC.selectedImageIndex = indexPath.row
            selectedVC.numberOfImages = pictures.count
            
            // Empurra a tela pro navigation controller
            navigationController?.pushViewController(selectedVC, animated: true)
        }
    }
    
    @objc func recommendApp() {
        let activityViewController = UIActivityViewController(activityItems: ["Hey! I'm using this app!", "Download it now at: https://github.com/Gabriel-Cervo/100DaysOfSwift-Project1"], applicationActivities: [])
        
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityViewController, animated: true)
    }
}

