#
#  Be sure to run `pod spec lint SwiftyURLSession.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "SwiftyURLSession"
  s.version      = "0.9.0"
  s.summary      = "A short description of SwiftyURLSession."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
                    TODO
                   DESC

  s.homepage     = "http://github.com/falcon283/SwiftyURLSession"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = "MIT"


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "Gabriele Trabucco" => "gabrynet83@gmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  #  When using multiple platforms
  s.ios.deployment_target = "8.0"
  s.watchos.deployment_target = "1.0"
  s.tvos.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "http://github.com/falcon283/SwiftyURLSession.git", :tag => "#{s.version}" }



  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.ios.source_files = "SwiftyURLSession/Classes/Core/*.{h,m,swift}"

  s.tvos.source_files = "SwiftyURLSession/Classes/Core/*.{h,m,swift}"

  s.watchos.source_files = "SwiftyURLSession/Classes/Core/*.{h,m,swift}"

  s.osx.source_files  = "SwiftyURLSession/Classes/Core/*.{h,m,swift}"
  s.osx.exclude_files = 'SwiftyURLSession/Classes/Core/BodyImage.swift'

  # ――― Subspec -----――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.subspec 'Rx' do |srxs|

    # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #

    srxs.ios.source_files = "SwiftyURLSession/Classes/RxSwift/*.{h,m,swift}"
    srxs.tvos.source_files = "SwiftyURLSession/Classes/RxSwift/URLSession+Body+Rx.swift"
    srxs.watchos.source_files = "SwiftyURLSession/Classes/RxSwift/URLSession+Body+Rx.swift"
    srxs.osx.source_files = "SwiftyURLSession/Classes/RxSwift/URLSession+Body+Rx.swift"

    # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
    #

    srxs.dependency "RxSwift", "~> 3.0"

  end


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

end
