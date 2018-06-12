# Preview all emails at http://localhost:3000/rails/mailers/payment_mailer
class TransmissionMailerPreview < ActionMailer::Preview
	def transmission_notice_preview
		@translog = []
        @pmnts = BankPayment.where('approved = ?' , 0)
        @count = @pmnts.length
        if @pmnts.length  > 0
          @pmnts.each do |p|
            @translog << TransLog.new(p.fran,p.date_posted,p.amount,p.paid_with,p.description)
          end
        
         TransmissionMailer.transmission_notice(@count,@translog)

		
     	end
  end

  def error_not_found_preview
     receipt_array = []

     receipt_array << {:date_of_transaction => Date.today , :transaction_id => "4444" , :reference_id => "56" , :transaction_type => "ACH Debit" ,      :transaction_amount => "100.00",     :transaction_state => "Approved",     :state_reason => "Checking Withdrawl"}
     receipt_array.each do |d|
        TransmissionMailer.error_not_found(d)
      end


  end


  def reception_notice_preview
    @translog = []
    response = Gms.new.instant_transaction_response_by_date(ENV['GULF_API_ID'],ENV['GULF_API_KEY'],ENV['GULF_GMS_ID'], '2014-07-11')     
    if response.success?
      @data = response.to_array(:instant_transaction_response_by_date_response, :instant_transaction_response_by_date_result, :array_of_transactions, :one_time_transaction)
   
      #If we have transactions...
      if @data.length > 0 
        @number_of_items = @data.length
        #Loop through them
        @data.each do |d|
          processed = 0
          @translog << ReceiptLog.new(1,d[:date_of_transaction],d[:transaction_id], d[:reference_id], d[:transaction_type], d[:transaction_amount], "VISA",d[:transaction_state] , d[:state_reason], processed)
        end

      end
      TransmissionMailer.reception_notice(@translog)
    end

  end

       

end
