class ToppagesController < ApplicationController
before_action :area

  def index
    @rests = @rests
    if logged_in?
      @micropost = current_user.microposts.build #form_with 用
      @microposts = current_user.feed_microposts.order(id: :desc).page(params[:page])
    end
  end
  
  def create
    @area = Area.find_or_initialize_by(area_code: params[:area_code])
    
    base_url = 'https://api.gnavi.co.jp/master/AreaSearchAPI/v3/'
    
    parameters = {
      'keyid' => '11ca4c37d610e4a7ed0880bcfa8ff006',
      'lang' =>'ja'
    }
    
    uri = URI(base_url + '?' + parameters.to_param)
    
    p response_json = Net::HTTP.get(uri)
    
    p response_data = JSON.parse(response_json)
    
    area = response_data['area']
  
    @area.area_code = area['area_code']
    @area.area_name = area['area_name']

    if @area.save
      redirect_to @area
    else
      redirect_back(fallback_location: root_url)
    end
  end
end
