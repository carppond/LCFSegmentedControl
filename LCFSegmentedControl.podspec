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
  s.summary      = "A drop-in replacement for UISegmentedControl mimicking the style of the one in Google Currents and various other Google products."
  s.homepage     = "https://github.com/lixianshen/LCFSegmentedControl"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "WLee" => "810646506@qq.com" }
  s.source       = { :git => "https://github.com/lixianshen/LCFSegmentedControl.git", :tag => "v0.0.1" }
  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.source_files = 'LCFSegmentedControl/*.{h,m}'
  s.framework  = 'QuartzCore'
end
