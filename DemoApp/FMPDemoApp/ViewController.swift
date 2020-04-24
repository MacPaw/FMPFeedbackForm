//
//  ViewController.swift
//  FMPDemoApp
//
//  Created by Anton Barkov on 03.04.2020.
//  Copyright © 2020 MacPaw. All rights reserved.
//

import Cocoa
import FMPFeedbackForm

class ViewController: NSViewController {
    
    // MARK: - Zendesk outlets
    
    @IBOutlet weak var subdomainField: NSTextField!
    @IBOutlet weak var tokenField: NSTextField!
    @IBOutlet weak var productNameField: NSTextField!
    
    // MARK: - Settings outlets
    
    @IBOutlet weak var namePlaceholderField: NSTextField!
    @IBOutlet weak var emailPlaceholderField: NSTextField!
    @IBOutlet weak var detailsPlaceholderField: NSTextField!
    @IBOutlet weak var defaultNameField: NSTextField!
    @IBOutlet weak var defaultEmailField: NSTextField!
    @IBOutlet weak var subjectOptionsField: NSTextField!
    @IBOutlet weak var formTitleField: NSTextField!
    @IBOutlet weak var formSubtitleField: NSTextField!
    @IBOutlet weak var iconFileLabel: NSTextField!
    @IBOutlet weak var logFileLabel: NSTextField!
    @IBOutlet weak var showsSuccessCheckbox: NSButton!
    @IBOutlet weak var showsErrorCheckbox: NSButton!
    
    // MARK: - Actions
    
    private var iconSize = NSSize(width: 64, height: 64)
    @IBAction func iconSizeRadioClick(_ sender: Any) {
        guard let button = sender as? NSButton else {
            return
        }
        
        switch button.tag {
        case 101:
            iconSize = NSSize(width: 32, height: 32)
        case 102:
            iconSize = NSSize(width: 64, height: 64)
        case 103:
            iconSize = NSSize(width: 128, height: 128)
        default:
            iconSize = NSSize(width: 64, height: 64)
        }
    }
    
    private var iconURL: URL?
    @IBAction func iconButtonClick(_ sender: Any) {
        selectFile(allowedTypes: ["jpg", "png", "jpeg", "gif", "pdf"]) { [weak self] url in
            if let url = url {
                self?.iconURL = url
                self?.iconFileLabel.stringValue = url.lastPathComponent
            }
        }
    }
    
    private var logURL: URL?
    @IBAction func logButtonClick(_ sender: Any) {
        selectFile { [weak self] url in
            if let url = url {
                self?.logURL = url
                self?.logFileLabel.stringValue = url.lastPathComponent
            }
        }
    }
    
    private var feedbackController: FMPFeedbackController?
    @IBAction func provideFeedbackButtonClick(_ sender: Any) {
        if !validateZendeskCreds() {
            return
        }
        
        if feedbackController != nil {
            feedbackController?.close()
            feedbackController = nil
        }
        
        let settings = FMPInterfaceSettings.default
        settings.namePlaceholder = namePlaceholderField.trimmedNonEmptyString ?? settings.namePlaceholder
        settings.emailPlaceholder = emailPlaceholderField.trimmedNonEmptyString ?? settings.emailPlaceholder
        settings.detailsPlaceholder = detailsPlaceholderField.trimmedNonEmptyString ?? settings.detailsPlaceholder
        settings.defaultName = defaultNameField.trimmedNonEmptyString ?? settings.defaultName
        settings.defaultEmail = defaultEmailField.trimmedNonEmptyString ?? settings.defaultEmail
        settings.title = formTitleField.trimmedNonEmptyString ?? settings.title
        settings.subtitle = formSubtitleField.trimmedNonEmptyString ?? settings.subtitle
        if let iconURL = iconURL, let iconResource = NSImage(contentsOf: iconURL) {
            settings.icon = iconResource
            settings.iconSize = iconSize
        }
        let customSubjects = subjectOptionsField.trimmedString.split(separator: ",").map {
            String($0).trimmingCharacters(in: .whitespaces)
        }
        settings.subjectOptions = !customSubjects.isEmpty ? customSubjects : settings.subjectOptions
        
        let zendeskSender = FMPZendeskFeedbackSender(zendeskSubdomain: subdomainField.trimmedString,
                                                     authToken: tokenField.trimmedString,
                                                     productName: productNameField.trimmedString)
        
        feedbackController = FMPFeedbackController(feedbackSender: zendeskSender, settings: settings)
        feedbackController?.showsGenericSuccessAlert = showsSuccessCheckbox.state == .on
        feedbackController?.showsGenericErrorSheet = showsErrorCheckbox.state == .on
        if let logURL = logURL {
            feedbackController?.logURLs = [logURL]
        }
        
        feedbackController?.showWindow(self)
    }
    
    // MARK: - Helpers
    
    lazy private var openPanel: NSOpenPanel = {
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        return openPanel
    }()
    
    private func selectFile(allowedTypes: [String]? = nil, completion: @escaping (URL?) -> Void) {
        guard let window = self.view.window else {
            completion(nil)
            return
        }
        openPanel.allowedFileTypes = allowedTypes
        openPanel.beginSheetModal(for: window) { [weak self] response in
            completion(response == .OK ? self?.openPanel.url : nil)
        }
    }

    private func validateZendeskCreds() -> Bool {
        let isSubdomainValid = subdomainField.trimmedNonEmptyString != nil
        let isTokenValid = tokenField.trimmedNonEmptyString != nil
        let isProductNameValid = productNameField.trimmedNonEmptyString != nil
        return isSubdomainValid && isTokenValid && isProductNameValid
    }
}

extension NSTextField {
    var trimmedString: String {
        return self.stringValue.trimmingCharacters(in: .whitespaces)
    }
    
    var trimmedNonEmptyString: String? {
        let trimmedValue = self.trimmedString
        return trimmedValue != "" ? trimmedValue : nil
    }
}
