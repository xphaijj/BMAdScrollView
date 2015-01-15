#
#  Be sure to run `pod spec lint BMAdScrollView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.name         = "BMAdScrollView"
  s.version      = "1.1.0"
  s.summary      = "简单,易用,可自定义的广告栏，焦点图" 
  s.homepage     = "https://github.com/skyming/BMAdScrollView"
  s.license      = 'MIT'
  
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.author             = { "skyming" => "tskyming@163.com" }
  s.social_media_url   = "http://twitter.com/skyming3"

  
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.platform     = :ios, "6.0"
  s.ios.deployment_target = "6.0"


  
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
 
  s.source       = { :git => "https://github.com/skyming/BMAdScrollView.git", :tag => "1.0.1" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "BMAdScrollView", "BMADScrollViewDemo/BMAdScrollView/*.{h,m}"

  # s.public_header_files = "Classes/**/*.h"


  s.framework  = "UIKit"
  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
