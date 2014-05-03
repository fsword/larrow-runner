module Larrow
  module Core
    module Config
      def self.generate_config filepath
        puts "The larrow config will be generated at #{filepath}."
        content = <<-CONTENT
qy_access_key_id: 
qy_secret_access_key: 
        CONTENT
        File.open(filepath, 'w+'){|f| f.write content}
      end
    end
  end
end
