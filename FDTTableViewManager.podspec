Pod::Spec.new do |s|

  s.name         = "FDTTableViewManager"
  s.version      = "1.0.0"
  s.summary      = "FDTTableViewManager."
  s.description  = <<-DESC
                   DESC

  s.homepage     = "https://github.com/tomaszkorab/FDTTableViewManager"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Tomasz Korab" => "t.korab@fivedottwelve.com" }
  s.source       = { :git => "https://github.com/tomaszkorab/FDTTableViewManager.git", :tag => "#{s.version}" }

  s.source_files  = "FDTTableViewManager/**/*.{swift}"
  s.resources = "FDTTableViewManager/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
  s.framework = "UIKit"
  s.swift_version = "4.2"

end
