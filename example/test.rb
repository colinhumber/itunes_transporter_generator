require './itunes_transporter_generator'

generator = ItunesTransporterGenerator::Generator.new
generator.generate_metadata
generator.generate_itmsp