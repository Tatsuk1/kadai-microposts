class ShopsController < ApplicationController
before_action :shop_list
before_action :area

  def index
    if @rests
      @shops = Kaminari.paginate_array(@rests).page(params[:page]).per(10)
    else
      flash.now[:danger]='条件を満たす店舗が見つかりませんでした'
      render :index
    end
  end

  def show
  end
  
  def create
    @shop = Shop.find_or_initialize_by(shop_code: params[:shop_code])
    return redirect_to @shop if !@shop.new_record?
    
    base_url='https://api.gnavi.co.jp/RestSearchAPI/v3'
      
    parameters = {
    'id' => @shop.shop_code,
    'wifi' => @shop.wifi,
    'outret' => @shop.outret,
    'private_room' => @shop.private_room,
    'format' => 'json',
    'hit_per_page' => 50,
    'keyid' => ENV['GURUNAVI_API_KEY']
    }

    uri = URI(base_url + '?' + parameters.to_param)

    response_json = Net::HTTP.get(uri)

    p rest = JSON.parse(response_json)['rest']
        
    @shop.shop_code = rest['id'] 
    @shop.shop_name = rest['name']
    
    if @shop.save
      redirect_to @shop
    else
      redirect_back(fallback_location: root_url)
    end
  end
end
