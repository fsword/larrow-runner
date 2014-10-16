require_relative '../spec_helper.rb'
module Larrow
  module Runner
    module Vcs
      describe Github do
        subject{Github.new 'https://github.com/fsword/sample_ruby.git'}
        it 'split_org_and_name' do
          git_url = 'git@github.com:org1/proj_name1.git'
          https_url = 'https://github.com/org1/proj_name1.git'
          [git_url, https_url].each do |url|
            github = Github.new url
            expect(github.formatted_url).to eq(git_url)
          end
        end

        it 'get' do
          expect(subject.get '/.travis.yml').not_to be_empty
        end
        
        it 'update_source' do
          node = double('node')
          allow(node).to(receive :execute){|cmd| cmd}
          expect(subject.update_source(node,nil)).not_to be_empty 
        end
        
        after do
          `rm -rf sample_ruby`
          `rm -rf $HOME/source`
        end
      end
    end
  end
end
