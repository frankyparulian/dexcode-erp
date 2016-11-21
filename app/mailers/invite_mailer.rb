class InviteMailer < ApplicationMailer
  @default_email = "contact@dexcode.com"
  default from: @default_email, cc:@default_email

  def invite(invite)
    @email = invite.email
    @code = invite.code
    subject = "Invite di Dexcode"
    mail(to: @email, subject: subject)
  end
end
