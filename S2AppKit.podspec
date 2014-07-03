
Pod::Spec.new do |s|

  s.name         = "S2AppKit"
  s.version      = "3.0.0-BETA1"
  s.summary      = "A short description of S2AppKit."
  s.description  = <<-DESC
                  S2AppKit is a application framework.
                DESC

  s.homepage     = "http://github.com/straightspirits/S2AppKit-ios"
  s.source       = { :git => "http://github.com/straightspirits/S2AppKit-ios.git"} # , :tag => "0.0.1"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Fumio Furukawa" => "fumio@straight-spirits.com" }
  s.platform     = :ios, "7.0"

  s.ios.deployment_target = "7.0"

  s.source_files  = "**/*.{h,m,c}"
  # s.frameworks = "SomeFramework", "AnotherFramework"
  s.library   = "z"
  s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  # s.dependency "JSONKit", "~> 1.4"
  s.dependency 'AFNetworking', '~> 2.0'
  s.dependency 'MBProgressHUD', '~> 0.8'

end
