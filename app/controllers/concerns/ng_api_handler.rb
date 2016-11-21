module NgApiHandler
  extend ActiveSupport::Concern

  included do
    after_filter :set_csrf_cookie_for_ng
  end

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token
  end

  protected

    def verified_request?
      super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
    end

end