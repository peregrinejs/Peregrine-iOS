Pod::Spec.new do |spec|
  spec.name             = "Peregrine"
  spec.version          = "0.10.0"
  spec.summary          = "The Swift library that serves Peregrine Web Frames as SwiftUI views"
  spec.description      = "Peregrine is a set of native and web libraries for building hybrid apps using web technologies. For both iOS and Android, Peregrine provides an elegant way to add feature-rich web views, called Web Frames, to new and existing native apps."
  spec.homepage         = "https://peregrinejs.com/en/docs/ios"
  spec.license          = "GPL-3.0"
  spec.author           = "Dan Imhoff"
  spec.social_media_url = "https://twitter.com/Peregrine_JS"
  spec.platform         = :ios, "14.0"
  spec.swift_versions   = "5"
  spec.source           = { :git => "https://github.com/peregrinejs/Peregrine-iOS.git", :tag => "#{spec.version}" }
  spec.source_files     = "Sources/Peregrine/**/*.swift"
end
