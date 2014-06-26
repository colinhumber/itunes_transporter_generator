require 'itunes/transporter/generator'

command :package do |c|
  c.syntax = 'itmsp package [options]'
  c.summary = ''
  c.description = 'Generates iTunes Metadata Store Package (.itmsp) from provided achievement, leaderboard, and/or in-app purchases provided'
  c.example 'description', 'command example'
  c.option '-i FILENAME', '--input FILENAME', String, 'YAML file containing app/team values, achievement, leaderboard, and/or in-app purchase descriptions'
  c.option '--[no-]prefix-images', 'Specifies if images should be prefixed with locale, display target, and type (achievement, IAP, leaderboard) as appropriate'

  c.action do |args, options|
    output = Itunes::Transporter::Generator.new(options).generate_metadata

    say_ok output[:messages].join("\n") if output[:messages].length > 0
    say_error "Errors:\n #{output[:errors].join("\n")}" if output[:errors].length > 0
  end
end
