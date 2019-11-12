#
# Be sure to run `pod lib lint ASBottomSheet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ASBottomSheet'
  s.version          = '1.1'
  s.summary          = 'ASBottomSheet is a UIActionSheet like menu controller.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ASBottomSheet is a UIActionSheet like menu controller that can be used to show custom menu from bottom of the presenting view controller. It uses UICollectionView to show menu options provided by the developer. It is greatly inspired by the FCVerticalMenu
                       DESC

  s.homepage         = 'https://github.com/AdilSoomro/ASBottomSheet'
  s.screenshots     = 'https://raw.githubusercontent.com/AdilSoomro/ASBottomSheet/master/screenshot.jpg'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AdilSoomro' => 'adilsoomro.s@gmail.com' }
  s.source           = { :git => 'https://github.com/AdilSoomro/ASBottomSheet.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '4.0'
  s.source_files = 'ASBottomSheet/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ASBottomSheet' => ['ASBottomSheet/Assets/*.png']
  # }
  s.resources = ["ASBottomSheet/Resources/*.storyboard"]

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
