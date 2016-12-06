#
# Be sure to run `pod lib lint DBDebugToolkit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DBDebugToolkit'
  s.version          = '0.1.0'
  s.summary          = 'Set of easy to use debugging tools for developers & QA.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
Set of easy to use debugging tools for developers & QA
                       DESC

  s.homepage         = 'https://github.com/dbukowski/DBDebugToolkit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dariusz Bukowski' => 'dariusz.m.bukowski@gmail.com' }
  s.source           = { :git => 'https://github.com/dbukowski/DBDebugToolkit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/darekbukowski'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DBDebugToolkit/Classes/**/*'
  
  s.resource_bundles = {
    'DBDebugToolkit' => ['DBDebugToolkit/Resources/*.{storyboard,xib}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
