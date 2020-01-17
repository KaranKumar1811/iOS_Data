//
//  ViewController.swift
//  iOS_Data
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 Karan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var books : [Book]?
    
    @IBOutlet var textFields: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            loadData()
         NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willResignActiveNotification, object: nil)
    }

    func getFilePath()-> String{
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if documentPath.count > 0 {
            let documentDirectory = documentPath[0]
            let filePath  = documentDirectory.appending("/data.txt")
        return filePath
        }
        return ""
    }
    
    
    func loadData()
    {
        let filePath = getFilePath()
        books = [Book]()
        if FileManager.default.fileExists(atPath: filePath)
        {
            do {
                // extract data
                let fileContents = try String(contentsOfFile: filePath)
                let contentArray = fileContents.components(separatedBy: "\n")
                for content in contentArray{
                    let bookContent = content.components(separatedBy: ",")
                    if bookContent.count  == 4
                    {
                        let book = Book(title: bookContent[0], author: bookContent[1], page: Int(bookContent[2])!, year: Int(bookContent[3])!)
                        books?.append(book)
                       
                    }
                }
            }
            catch{
                print(error)
            }
        }
        
        
    }
    
    @IBAction func addBook(_ sender: UIBarButtonItem) {
        let title = textFields[0].text ?? ""
        let author = textFields[1].text ?? ""
        let pages = Int( textFields[2].text ?? "0") ?? 0
        let year = Int(textFields[3].text ?? "2020") ?? 2020
        
        let book = Book(title: title, author: author, page: pages, year: year)
        books?.append(book)
        
        for textField in textFields{
            textField.text = ""
            textField.resignFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let BookTable = segue.destination as? BookTableVC{
            BookTable.books = self.books
        }
    }
    
    @objc func saveData(){
        let filePath = getFilePath()
        var saveString = ""
        for book in books!{
            saveString = "\(saveString)\(book.title),\(book.author),\(book.page),\(book.year)\n"
        }
        //write to path
        do {
            try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
        }
        catch{
            print(error)
        }
        
        func saveCoreData(){
            // create an instance of app delegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            // second step is context
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            for  book in books!
            {
                let bookEntity = NSEntityDescription.insertNewObject(forEntityName: "Book", into: managedContext)
                bookEntity.setValue(book.title, forKey: "title")
                bookEntity.setValue(book.author, forKey: "author")
                 bookEntity.setValue(book.page, forKey: "pages")
                 bookEntity.setValue(book.year, forKey: "year")
                
                // save context
                do{
                    try managedContext.save()
                }catch{
                    print(error)
                }
            }
        }
        
        func loadCoreData(){
            
        }
        
        func clearCoreData(){
            
        }
    }
    
 
}

