class AvailableServiceDecorator < Draper::Decorator
  include Rails.application.routes.url_helpers
  delegate_all	

  def link_to_edit_or_review
    if custom_service == 1
      rtn = h.link_to(edit_available_service_path(id)) do 
  	    h.content_tag(:i, "", { :style=> "padding: 0px 10px 0px 10px;", :class => "fa fa-edit fa-2x",:'aria-hidden'=>"true", :'data-html' => "true", 
        :'data-toggle'=>"tooltip" ,:title=>"Edit this service" ,:'data-placement' =>"right" ,:'data-container'=>"body" })
      end
      rtn +=  h.link_to available_service_path(id), method: :delete, data:{confirm: "Are you sure you want to delete this service?"} do 
        h.content_tag(:i,"",{:style=> "padding: 0px 10px 0px 10px;", :class => "fa fa-trash fa-2x",:'aria-hidden'=>"true", :'data-html' => "true", 
        :'data-toggle'=>"tooltip" ,:title=>"Delete this service" ,:'data-placement' =>"right" ,:'data-container'=>"body" }) 
      end
    else
      html = <<-HTML
      <i class="fa fa-lock fa-2x" aria-hidden="true" data-html = "true" data-toggle="tooltip" 
  	    title="This is a standard service code. It can't be edited or deleted" 
  	    data-placement ="right" data-container="body">  	  	
      </i>
   	  HTML
      html.html_safe
  	end
  end
end