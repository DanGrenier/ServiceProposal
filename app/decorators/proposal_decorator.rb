class ProposalDecorator < Draper::Decorator
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::NumberHelper

  delegate_all	

  def proposal_status_icon
    case proposal_status
      when 0
        html = <<-HTML
          <i class="fa fa-hourglass-2 fa-2x icon-hourglass"  aria-hidden="true" data-html = "true" data-toggle="tooltip" title="This Proposal is Pending" data-placement="right" data-container="body"></i>
        HTML
        
      when 1
        html = h.content_tag(:i, "",  :class=>"fa fa-thumbs-o-up fa-2x icon-approved", :'aria-hidden'=>"true", :'data-html' => "true", :'data-toggle'=>"tooltip", :'title'=>"Accepted! ("+number_to_currency(actual_fee, precision: 2)+")", :'data-placement'=>"right", :'data-container'=>"body")
        
      when 2
        html = <<-HTML          
        <i class="fa fa-thumbs-o-down fa-2x icon-declined" aria-hidden="true" data-html = "true" data-toggle="tooltip" title="Declined!" data-placement="right" data-container="body"></i>
        HTML
    end  
    html.html_safe
  end

  def quote_list
    number_to_currency(fee_tier1) + " / "+ number_to_currency(fee_tier2) + " / " + number_to_currency(fee_tier3)
  end
 
end