f = File.join(Rails.root, "config/secrets/settings.yml")

unless File.exists?(f)
  puts
  puts "-----------------------------------------------------------------------"
  puts "File config/secrects/settings.yml is missing."
  puts "-----------------------------------------------------------------------"
  puts
  abort
end

cfg = YAML.load(File.read(f))

# SMTP settings for gmail
ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :user_name            => 'huami.forum@gmail.com',
    :password             => cfg['forum_gmail_account_password'],
    :authentication       => "plain",
    :enable_starttls_auto => true
}
