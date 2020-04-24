Pod::Spec.new do |spec|

  spec.name         = "FMPFeedbackForm"
  spec.version      = "1.0.1"
  spec.summary      = "A convenient feedback form for macOS products."
  spec.description  = <<-DESC
  FMPFeedbackForm is an Objective-C framework that lets you add a simple yet effective feedback form to your macOS project. Localized into 12 languages, ready to work with Zendesk right out of the box.
                   DESC

  spec.homepage     = "https://github.com/MacPaw/FMPFeedbackForm"
  spec.screenshots  = "https://github.com/MacPaw/FMPFeedbackForm/blob/master/Screenshots/1.png?raw=true"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = "MacPaw Inc."
  spec.platform     = :osx, "10.12"
  spec.source       = { :git => "https://github.com/MacPaw/FMPFeedbackForm.git", :tag => "v#{spec.version}" }

  spec.source_files  = "FMPFeedbackForm/**/*.{h,m}"
  spec.resources = "FMPFeedbackForm/Resources/*"
  spec.requires_arc = true

end
