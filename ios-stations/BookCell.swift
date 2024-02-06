//
//  BookCell.swift
//  ios-stations
//

import UIKit

class BookCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var reviewerLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        detailLabel.text = book.detail
        reviewerLabel.text = book.reviewer
        reviewLabel.text = book.review
    }
    
    var element: Book!
}
