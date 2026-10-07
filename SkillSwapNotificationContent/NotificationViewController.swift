import UIKit
import UserNotifications
import UserNotificationsUI

final class NotificationViewController: UIViewController, UNNotificationContentExtension {
    private let titleLabel = UILabel()
    private let partnerLabel = UILabel()
    private let exchangeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.secondarySystemBackground

        let icon = UIImageView(image: UIImage(systemName: "arrow.left.arrow.right.circle.fill"))
        icon.tintColor = UIColor.systemTeal
        icon.contentMode = .scaleAspectFit
        icon.widthAnchor.constraint(equalToConstant: 42).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 42).isActive = true

        titleLabel.text = "SkillSwap session"
        titleLabel.font = .preferredFont(forTextStyle: .headline)

        partnerLabel.font = .preferredFont(forTextStyle: .subheadline)
        partnerLabel.textColor = .secondaryLabel

        exchangeLabel.font = .preferredFont(forTextStyle: .body)
        exchangeLabel.numberOfLines = 0

        let labels = UIStackView(arrangedSubviews: [titleLabel, partnerLabel, exchangeLabel])
        labels.axis = .vertical
        labels.spacing = 5

        let row = UIStackView(arrangedSubviews: [icon, labels])
        row.axis = .horizontal
        row.alignment = .top
        row.spacing = 12
        row.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(row)

        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            row.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            row.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            row.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16)
        ])
    }

    func didReceive(_ notification: UNNotification) {
        let info = notification.request.content.userInfo
        let partner = info["partnerName"] as? String ?? "your swap partner"
        let need = info["needSkill"] as? String ?? "the skill you need"
        let offered = info["offeredSkill"] as? String ?? "the skill you offered"

        partnerLabel.text = "Exchange with \(partner)"
        exchangeLabel.text = "You need: \(need)\nYou offer: \(offered)\n\nConfirm the time and meeting details before you go."
    }
}
