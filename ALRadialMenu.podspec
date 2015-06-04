Pod::Spec.new do |spec|
  spec.name               = "ALRadialMenu"
  spec.version            = "1.0.1"
  spec.summary            = "A radial/circular menu featuring spring animations"
  spec.source             = { :git => "https://github.com/AlexLittlejohn/ALRadialMenu.git", :tag => '1.0.1' }
  spec.requires_arc       = true
  spec.platform           = :ios, "8.0"
  spec.license            = "MIT"
  spec.source_files       = "ALRadialMenu/*.{swift}"
  spec.homepage           = "https://github.com/AlexLittlejohn/ALRadialMenu"
  spec.author             = { "Alex Littlejohn" => "alexlittlejohn@me.com" }
end