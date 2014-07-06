
Pod::Spec.new do |s|

  s.name         = "S2AppKit"
  s.version      = "2.0.0"
  s.summary      = "S2AppKit is a SDK extension. wrapping library."
  s.description  = <<-DESC
                  S2AppKit is a application framework. if use then very very happpy!
                DESC

  s.homepage     = "http://github.com/straightspirits/S2AppKit-ios"
  s.source       = { :git => "https://github.com/straightspirits/S2AppKit-ios.git"} # , :tag => "2.0.0"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Fumio Furukawa" => "fumio@straight-spirits.com" }
  s.platform     = :ios, "7.0"

  s.ios.deployment_target = "7.0"

  s.source_files  = "**/*.{h,m,c}"
  # s.frameworks = "SomeFramework", "AnotherFramework"
  s.library   = "z"
  s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency 'AFNetworking', '~> 2.0'
  s.dependency 'MBProgressHUD', '~> 0.8'

end
