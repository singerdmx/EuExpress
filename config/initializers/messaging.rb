Messaging.setup do |config|

  config.user_class = User

  #config.attachment_storage = :fog
  config.attachment_storage = :file
  
  # comment to disable file type validation on attachments
  config.allowed_attachment_filetypes = %w[jpg jpeg png gif]

end
