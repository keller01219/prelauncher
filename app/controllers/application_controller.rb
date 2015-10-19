class ApplicationController < ActionController::Base
    protect_from_forgery

    before_filter :ref_to_cookie

    def mobile_device?
        if session[:mobile_param]
            session[:mobile_param] == "1"
        else
            request.user_agent =~ /Mobile|webOS/
        end
    end

    protected

    def ref_to_cookie
        if params[:ref] && !Rails.application.config.ended
            if !User.find_by_referral_code(params[:ref]).nil?
                cookies[:h_ref] = { :value => params[:ref], :expires => 1.week.from_now }
            end

            if request.env["HTTP_USER_AGENT"] and !request.env["HTTP_USER_AGENT"].include?("facebookexternalhit/1.1")
                redirect_to proc { url_for(params.except(:ref)) }  
            end
        end
    end

    private
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end   
    helper_method :current_user

end
    
