//
//  BookCell.swift
//  ios-stations
//

import UIKit

class BookCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        detailLabel.text = book.detail
    }
    
    var element: Book!
}
