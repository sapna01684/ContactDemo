//
//  ViewController.swift
//  ContactsApp
//
//  Created by Tuba Nur  on 24.07.2023.
//

import UIKit
import UIKit
import Contacts

class ViewController: UIViewController {

    @IBOutlet weak var contactsTableView: UITableView!
    var contacts = [CNContact]()
  //  let sectionIndexTitles = ["A", "B", "C","Z"]
    let sectionIndexTitles = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map(String.init)
  //  var sectionIndexTitleToSectionIndex = [String: Int]()
    var sectionIndexTitleToIndexPath = [String: IndexPath]()
    var indexLetters: [String] = []
    

    private var selectedContactType: ContactType? {
        didSet {
            contactsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        contactsTableView.sectionIndexColor = UIColor.red // Change to your desired color
        contactsTableView.sectionIndexBackgroundColor = UIColor.blue
        
        contactsTableView.sectionIndexTrackingBackgroundColor = UIColor.white
        
//        // Populate the mapping dictionary
//        for (index, section) in sectionIndexTitles.enumerated() {
//            sectionIndexTitleToSectionIndex[section] = index
//        }
        
        // Extract unique first letters from contact names and sort them
        let uniqueFirstLetters = Set(contacts.map { String($0.givenName.prefix(1)) })
        indexLetters = uniqueFirstLetters.sorted()
        requestContactsAccess()
        
       // let filterButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), style: .done, target: self, action: #selector(filterButtonAct))
       // navigationItem.rightBarButtonItem = filterButton
    }
    
//    @objc private func filterButtonAct() {
//        let storyboard = UIStoryboard(name: "PickerViewController", bundle: nil)
//
//        if let vc = storyboard.instantiateViewController(identifier: "PickerViewController") as? PickerViewController {
//            vc.delegate = self
//            vc.modalPresentationStyle = .overCurrentContext
//            self.present(vc, animated: true)
//        }
//    }
    
    func requestContactsAccess() {
           let contactStore = CNContactStore()
           contactStore.requestAccess(for: .contacts) { (granted, error) in
               if granted {
                   self.fetchContacts()
               } else {
                   // Handle denied access
                   print("Contacts access denied.")
               }
           }
       }
    
    func fetchContacts() {
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactEmailAddressesKey,
            CNContactPhoneNumbersKey,
            CNContactImageDataKey
        ] as [Any]

        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])

      //  var contacts = [CNContact]()

        do {
            try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) in
                contacts.append(contact)

            }

            DispatchQueue.main.async {
                // Use the 'contacts' array to update your UI or perform any other action
                print("Fetched \(self.contacts.count) contacts.")
            }
        } catch {
            // Handle error
            print("Error fetching contacts: \(error)")
        }
    }
    
//    func fetchContacts() {
//
//        let keysToFetch = [
//                  CNContactIdentifierKey,
//                 // CNContactFormatter.CNKeyDescriptor(for: .fullName),
//                  CNContactEmailAddressesKey,
//                  CNContactPhoneNumbersKey,
//                  CNContactThumbnailImageDataKey,
//                  CNContactImageDataKey
//              ] as [CNKeyDescriptor]
//
//              let contactStore = CNContactStore()
//
//              // Fetch All Contacts
//              let allContactsFetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
//              do {
//                  try contactStore.enumerateContacts(with: allContactsFetchRequest) { contact, _ in
//                      self.contacts.append(contact)
//                  }
//              } catch {
//                  // Handle error
//              }
//
//              // Fetch iCloud Contacts
//          let icloudContainers = try? contactStore.containers(matching: CNContainer.predicateForContainers(withIdentifiers: [CNLabelEmailiCloud]))
//              for container in icloudContainers ?? [] {
//                  var icloudFetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
//                //  icloudFetchRequest. = container.identifier
//                  do {
//                      try contactStore.enumerateContacts(with: icloudFetchRequest) { contact, _ in
//                          self.contacts.append(contact)
//                      }
//                  } catch {
//                      // Handle error
//                  }
//              }
//
//    }
    
}

//MARK: - PickerViewController Delegate Methods
extension ViewController: PickerViewControllerDelegate {
    func didSelectContactType(_ type: ContactType) {
        selectedContactType = type
    }
}


//MARK: - TableView Delegate Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check if the section is within the bounds of the contacts array
       
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        
       // cell.cellImageView.image = UIImage(named: getPersonsByContactType(indexPath.section)[indexPath.row].gender.type.lowercased())
        cell.cellTitleLabel.text = "\(contacts[indexPath.row].givenName)"
        if let imageData = contacts[indexPath.row].imageData,
           let image = UIImage(data: imageData) {
            // Use the image and contact data
            cell.cellImageView.image = image

        }
        return cell
    }
    
    // Custom method to scroll to the first contact starting with a specific letter
       func scrollToLetter(_ letter: String) {
           if let index = contacts.firstIndex(where: { contact in
               return contact.givenName.prefix(1) == letter
           }) {
               let indexPath = IndexPath(row: index, section: 0)
               contactsTableView.scrollToRow(at: indexPath, at: .top, animated: true)
           }
       }
       
       // Custom index title for section index
       func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
           scrollToLetter(title) // Scroll to the selected letter
           return -1 // Return an invalid section index to prevent the table view from trying to scroll to a section
       }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexLetters.first
       }
       
      //  Add an index for the side alphabet sections
       func sectionIndexTitles(for tableView: UITableView) -> [String]? {
           return sectionIndexTitles
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let vc = DetailViewController.instantiateFromStoryboard(String(describing: DetailViewController.self))
//        let person = getPersonsByContactType(indexPath.section)[indexPath.row]
//        vc.imageName = person.gender.type
//        vc.labelName = person.name
//        vc.cT = person.contactType
//        self.navigationController?.show(vc, sender: nil)
    }
    
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        guard let sectionIndex = sectionIndexTitleToSectionIndex[title] else {
//            return 0 // Default value if title is not found
//        }
//
//        let indexPath = IndexPath(row: contacts[index].count, section: sectionIndex)
//        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
//
//        return sectionIndex
//    }
    
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//
//            guard let indexPath = sectionIndexTitleToIndexPath[title] else {
//                return 0 // Default value if title is not found
//            }
//
//            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
//
//            // Deselect any previous selections
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                tableView.deselectRow(at: selectedIndexPath, animated: true)
//            }
//
//            // Highlight the selected row
//            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
//
//            return indexPath.section
//        }
//
    private func setSections() -> [ContactType] {
        
        if let selectedContactType {
            return [selectedContactType]
        } else {
            return ContactType.allCases
        }
    }
    
    private func getPersonsByContactType(_ sectionIndex: Int) -> [Person] {
        return filterPersonsByContactType(sectionIndex, selectedContactType : selectedContactType, isCurrentPersonIncluded:true, currentPersonName: nil)
    }
    
}


extension UIViewController {
    static func instantiateFromStoryboard(_ name: String = "Main") -> Self {
        return instantiateFromStoryboardHelper(name)
    }
    
    private static func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! T
        return controller
    }
}
