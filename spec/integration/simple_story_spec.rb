require 'spec_helper.rb'
module Larrow
  module Runner 
    describe "integration" do
      [
        'git@github.com:fsword/larrow-qingcloud.git'
      ].each do |url|
        it 'simple story' do
          expect(Manager.new(url).go).not_to be_nil
        end
      end
    end
  end
end
