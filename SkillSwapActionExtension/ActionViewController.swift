import UIKit
import UniformTypeIdentifiers

final class ActionViewController: UIViewController {
    private let sourceLabel = UILabel()
    private let needField = UITextField()
    private let offerField = UITextField()
    private let previewLabel = UILabel()
    private let insertButton = UIButton(type: .system)
    private var sharedText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadSharedContent()
    }

    private func configureUI() {
        view.backgroundColor = .systemGroupedBackground

        let titleLabel = UILabel()
        titleLabel.text = "SkillSwap Draft"
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel.adjustsFontForContentSizeCategory = true

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Turn selected text into a clear two-sided skill exchange request."
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0

        sourceLabel.font = .preferredFont(forTextStyle: .footnote)
        sourceLabel.textColor = .secondaryLabel
        sourceLabel.numberOfLines = 3

        needField.placeholder = "Skill or help you need"
        needField.borderStyle = .roundedRect
        needField.addTarget(self, action: #selector(updatePreview), for: .editingChanged)

        offerField.placeholder = "Skill you can offer in return"
        offerField.borderStyle = .roundedRect
        offerField.addTarget(self, action: #selector(updatePreview), for: .editingChanged)

        previewLabel.font = .preferredFont(forTextStyle: .body)
        previewLabel.numberOfLines = 0
        previewLabel.backgroundColor = .secondarySystemGroupedBackground
        previewLabel.layer.cornerRadius = 14
        previewLabel.layer.masksToBounds = true

        insertButton.setTitle("Return formatted request", for: .normal)
        insertButton.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        insertButton.configuration = .filled()
        insertButton.addTarget(self, action: #selector(completeAction), for: .touchUpInside)

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, sourceLabel, needField, offerField, previewLabel, insertButton, cancelButton])
        stack.axis = .vertical
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            previewLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 92),
            insertButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        updatePreview()
    }

    private func loadSharedContent() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem,
              let provider = item.attachments?.first else {
            return
        }

        if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { [weak self] item, _ in
                DispatchQueue.main.async {
                    self?.sharedText = (item as? String) ?? ""
                    self?.refreshSourceLabel()
                }
            }
        } else if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { [weak self] item, _ in
                DispatchQueue.main.async {
                    self?.sharedText = (item as? URL)?.absoluteString ?? ""
                    self?.refreshSourceLabel()
                }
            }
        }
    }

    private func refreshSourceLabel() {
        sourceLabel.text = sharedText.isEmpty ? "No source text was provided." : "Source: \(sharedText)"
    }

    @objc private func updatePreview() {
        let need = needField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let offer = offerField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let needText = need.isEmpty ? "[what I need help with]" : need
        let offerText = offer.isEmpty ? "[what I can offer]" : offer
        previewLabel.text = "  I need: \(needText)\n\n  I can offer: \(offerText)"
    }

    @objc private func completeAction() {
        let need = needField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let offer = offerField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !need.isEmpty, !offer.isEmpty else {
            let alert = UIAlertController(title: "Complete both sides", message: "Add what you need and what you can offer before returning the draft.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        var formatted = "SkillSwap request\nI need: \(need)\nI can offer: \(offer)"
        if !sharedText.isEmpty {
            formatted += "\nContext: \(sharedText)"
        }

        let provider = NSItemProvider(item: formatted as NSString, typeIdentifier: UTType.plainText.identifier)
        let output = NSExtensionItem()
        output.attachments = [provider]
        extensionContext?.completeRequest(returningItems: [output], completionHandler: nil)
    }

    @objc private func cancelAction() {
        extensionContext?.cancelRequest(withError: NSError(domain: "SkillSwapAction", code: 1))
    }
}
