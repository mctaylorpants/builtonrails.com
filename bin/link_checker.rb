require 'sendgrid-ruby'
require 'httparty'
include SendGrid

TIMEOUT = 5

apps = YAML.load(File.open('/app/_data/apps.yml'))

errors = []

apps.each do |app|
  app_name = app.fetch("name")
  url = app.fetch("url")
  logo_url = app.fetch("logo_url")

  [url, logo_url].each do |link|
    begin
      print "Checking #{link}..."
      response = HTTParty.get(link, timeout: TIMEOUT)
      print " #{response.code}\n"

      errors << { name: app_name, url: link, code: response.code } if response.code >= 400
    rescue Net::OpenTimeout
      print " timeout \n"
    end
  end
end

if !errors.empty?
  body = "Uh oh, we found some broken links on builtonrails.com:\n\n"
  errors.each do |error|
    body << "#{error[:name]}: [#{error[:code]}] #{error[:url]}\n\n"
  end

  from = Email.new(name: 'Builtonrails Bot', email: ENV['DESTINATION_EMAIL'])
  subject = 'Broken link detected on builtonrails.com'
  to = Email.new(email: ENV['DESTINATION_EMAIL'])
  content = Content.new(type: 'text/plain', value: body)
  mail = Mail.new(from, subject, to, content)
  sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
  sg.client.mail._('send').post(request_body: mail.to_json)
end

