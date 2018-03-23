# frozen_string_literal: true

require 'yaml'
require 'spec_helper'

describe 'apps.yml' do
  let(:apps_yml) { File.expand_path('../../_data/apps.yml', __dir__) }
  let(:apps) { YAML.safe_load(File.open(apps_yml)) }

  it 'includes only HTTPS links' do
    urls = apps.flat_map { |a| [a.fetch('url'), a.fetch('logo_url')] }

    expect(urls).to all(match(/^https\:/))
  end
end
