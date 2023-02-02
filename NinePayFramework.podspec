Pod::Spec.new do |spec|

  spec.name         = "NinePayFramework"
  spec.version      = "1.1.4"
  spec.summary      = "A Library for 9Pay's merchant: NinePayFramework."
  spec.homepage     = "https://github.com/vupham9pay/NinePayFramework"


  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "“vupham9pay" => "vupt@9pay.vn" }
  

  spec.ios.deployment_target = "11.0"
  spec.swift_version = "5.6"
  spec.vendored_libraries = "NPayFramework.xcframework"

  spec.source       = { :git => "https://github.com/vupham9pay/NinePayFramework.git", :tag => "#{spec.version}" }



  # spec.source_files  = "**/*.{h,swift}"
  # spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"




  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


end
