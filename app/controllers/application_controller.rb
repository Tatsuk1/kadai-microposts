class ApplicationController < ActionController::Base
require 'net/http'
require 'json'
require 'uri'  
  
  include SessionsHelper
  
  private
  
  def area
    base_url = 'https://api.gnavi.co.jp/master/AreaSearchAPI/v3/'
    
    parameters = {
      'keyid' => '11ca4c37d610e4a7ed0880bcfa8ff006',
      'lang' =>'ja'
    }
    
    uri = URI(base_url + '?' + parameters.to_param)
    
    p response_json = Net::HTTP.get(uri)
    
    p response_data = JSON.parse(response_json)
    
    @areas = []
    areas = response_data['area']
    
    areas.each do |area|
      point = Area.find_or_create_by(area_name: area['area_name'])
        point.area_code = area['area_code']
        point.area_name = area['area_name']
      @areas << point
    end

  end
  
  def shop_list
    if params[:search].present?
    
      base_url='https://api.gnavi.co.jp/RestSearchAPI/v3'
      p freeword = params[:search]
      p wifi = params[:wifi]
       p outret = params[:outret]
      p  private_room = params[:private_room]
      
      parameters = {
      'freeword' => freeword,
      'category_l' => 'RSFST18000',
      'wifi' => wifi,
      'outret' => outret,
      'private_room' => private_room,
      'format' => 'json',
      'hit_per_page' => 50,
      'keyid' => '11ca4c37d610e4a7ed0880bcfa8ff006'
      }
      
      p uri = URI(base_url + '?' + parameters.to_param)
      
      p response_json = Net::HTTP.get(uri)
      
      p response_data = JSON.parse(response_json)
      
      @rests = []
      rests = response_data['rest']
      
      if rests
        rests.each do |rest|
          shop = Shop.find_or_initialize_by(shop_code: rest['id'])
          if !shop.id.present?
            shop.shop_code = rest['id'] 
            shop.shop_name = rest['name']
            shop.address = rest['address']
          end
          @rests << shop
        end
      else
        flash.now[:danger]='条件を満たす店舗が見つかりませんでした'
        render :index
      end
    end
  end
  
  
  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def counts(user)
    @count_microposts = user.microposts.count
    @count_followings = user.followings.count
    @count_followers = user.followers.count
    @count_favo_contents = user.favorites.count
  end
end
