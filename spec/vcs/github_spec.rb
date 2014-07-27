require_relative '../spec_helper.rb'
module Larrow
  module Runner
    module Vcs
      describe Github do
        subject{Github.new 'https://github.com/fsword/essh.git'}
        it 'split_org_and_name' do
          git_url = 'git@github.com:org1/proj_name1.git'
          https_url = 'https://github.com/org1/proj_name1.git'
          [git_url, https_url].each do |url|
            github = Github.new url
            expect(github.formatted_url).to eq(git_url)
          end
        end

        it { expect(subject.get '/.travis').not_to be_empty }
        it { expect(system subject.source_sync_script).to be true }
        
        after do
          `rm -rf essh`
        end
      end
    end
  end
end
