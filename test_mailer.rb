require 'net/smtp'

message = <<~MESSAGE_END
  From: Do Not Reply <autismserviceslocator@gmail.com>
  To: Garrett Bowman <garrettbowman248@gmail.com>
  Subject: Test Email

  This is a test email.
MESSAGE_END

Net::SMTP.start('smtp.gmail.com', 587, 'autismserviceslocator.com', 'autismserviceslocator@gmail.com', 'zfrb ujax mntf qmmz', :plain) do |smtp|
  smtp.send_message message, 'autismserviceslocator@gmail.com', 'garrettbowman248@gmail.com'
end