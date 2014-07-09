
Pod::Spec.new do |s|

  s.name         = "S2AppKit"
  s.version      = "2.0.2"
  s.summary      = "S2AppKit is a SDK extension. wrapping library."
  s.description  = <<-DESC
                  S2AppKit is a application framework. if use then very very happpy!
                DESC

  s.homepage     = "http://github.com/straightspirits/S2AppKit-ios"
  s.source       = { :git => "https://github.com/straightspirits/S2AppKit-ios.git", :tag => "v" + s.version.to_s() }
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Fumio Furukawa" => "fumio@straight-spirits.com" }
  s.platform     = :ios, "6.0"

  s.ios.deployment_target = "6.0"

  s.source_files  = "{Application,Foundation,Networking,Services,Text,UICase,UIKit,ZipArchive}/*.{h,m,c}"
  # s.frameworks = "SomeFramework", "AnotherFramework"
  s.library   = "z"
  s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

#  s.dependency 'AFNetworking', '~> 2.0'
  s.dependency 'MBProgressHUD', '~> 0.8'

  s.subspec 'iAd' do |a|
    a.source_files = 'iAd/*.{h,m}'
    a.framework = 'iAd'
  end

end
