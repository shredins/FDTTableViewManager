Pod::Spec.new do |s|

# 1
s.platform = :ios, '12.0'
s.ios.deployment_target = '12.0'
s.name = "FDTTableViewManager"
s.summary = "FDTTableViewManager is simple UITableView manager to handle everything in more elegant way"
s.requires_arc = true

# 2
s.version = "1.0.1"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Tomasz Korab" => "t.korab@fivedottwelve.com" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/tomaszkorab/FDTTableViewManager"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/tomaszkorab/FDTTableViewManager.git",
             :branch => "master",
             :tag => "#{s.version}" }

# 7
s.framework = "UIKit"

# 8
s.source_files = "FDTTableViewManager/**/*.{swift}"

# 10
s.swift_version = "5.0"

end
