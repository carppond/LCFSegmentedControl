#
#  Be sure to run `pod spec lint LCFSegmentedControl.podspec.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "LCFSegmentedControl"
  s.version      = "0.0.1"
  s.summary      = "LCFSegmentedControl."
  s.description  = <<-DESC
  简单的SegmentedControl,小型轻巧.
                   DESC
  s.homepage     = "https://github.com/lixianshen/LCFSegmentedControl"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author                 =   { "WLee" => "810646506@qq.com" }
  s.social_media_url       = "www.lichengfublog.com"
  s.source                 = { :git => "https://github.com/lixianshen/LCFSegmentedControl", :tag => s.version }
  s.source_files           = "LCFSegmentedControl/*"
  s.public_header_files    = "LCFSegmentedControl/**/*.h"
  s.requires_arc           = true

end
