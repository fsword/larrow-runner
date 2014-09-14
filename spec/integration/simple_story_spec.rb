require 'spec_helper.rb'
module Larrow
  module Runner 
    describe "integration test" do
      [
        'git@github.com:fsword/essh.git'
      ].each do |url|
        describe url do
          subject{ Manager.new url }
          it{ expect(subject.go).not_to be_nil }
        end
      end
    end

    describe "build server" do
      ['git@github.com:fsword/sample_ruby.git'].each do |url|
        describe url do
          subject{ Manager.new url }
          it{ 
            node = subject.build_server
            expect(node).to be_a ::Larrow::Runner::Model::Node
          }
          it{ 
            image = subject.build_image
            expect(image).to be_a ::Larrow::Qingcloud::Image
            image.destroy.force
          }
        end
      end
    end
  end
end
