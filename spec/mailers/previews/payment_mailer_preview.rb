# Preview all emails at http://localhost:3000/rails/mailers/payment_mailer
class PaymentMailerPreview < ActionMailer::Preview
	def credit_card_email_preview
		PaymentMailer.credit_card_email(CardPayment.last)
	end

        def bank_account_email_preview
		  PaymentMailer.bank_account_email(BankPayment.last)
        end

end