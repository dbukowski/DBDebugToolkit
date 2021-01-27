#
# Be sure to run `pod lib lint DBDebugToolkit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DBDebugToolkit'
  s.version          = '0.6.1'
  s.summary          = 'Set of easy to use debugging tools for iOS developers & QA engineers.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
DBDebugToolkit is a library written with two goals in mind: providing as many easily accessible debugging tools as possible and keeping the integration process seamless in all your projects. It all started with the lack of possibility to check the version and build number of the build you have installed on your phone. Then, after experiencing many inconveniences during developing and testing iOS software, it evolved into a powerful tool providing such important features like measuring your application performance, showing view frames, slowing down animations, showing touches, presenting requests sent by your application, browsing files, keychain, user defaults, Core Data and cookies, displaying console output, simulating location and many, many more.
                       DESC

  s.homepage         = 'https://github.com/fvonk/DBDebugToolkit'
  s.screenshots     = 'http://i.imgur.com/9IENbX4.png', 'http://i.imgur.com/jylD3PI.png', 'http://i.imgur.com/EOCIlgB.png', 'http://i.imgur.com/Ip1rPbJ.png', 'http://i.imgur.com/Cm8XpsQ.png', 'http://i.imgur.com/bfLB1uM.png', 'http://i.imgur.com/dQIwSce.png'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dariusz Bukowski' => 'dariusz.m.bukowski@gmail.com' }
  s.source           = { :git => 'https://github.com/fvonk/DBDebugToolkit.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/darekbukowski'

  s.ios.deployment_target = '11.0'

  s.source_files = 'DBDebugToolkit/Classes/**/*'
  
  s.resource_bundles = {
    'DBDebugToolkit' => ['DBDebugToolkit/Resources/*.{storyboard,xib,bundle}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
