class NameframesController < ApplicationController
  def index
    @nameframes = current_user.nameframes.order('created_at DESC')
  end

  def checkout
    @nameframe = current_user.nameframes.find(params[:id]) rescue nil
    if @nameframe
      session[:uuid] = @nameframe.uuid
      redirect_to checkout_path
    else
      redirect_to :action => :index
    end
  end

  def edit
    @nameframe = current_user.nameframes.find(params[:id]) rescue nil
    if @nameframe
      session[:uuid] = @nameframe.uuid
      session[:photo_customizations] = []
      session[:photo_customizations] = @nameframe.get_images_customizations
      redirect_to select_font_assets_path
    else
      redirect_to :action => :index
    end
  end

  def destroy
    @nameframe = current_user.nameframes.find(params[:id]) rescue nil
    if @nameframe
      @nameframe.destroy
    end
    redirect_to my_account_nameframes_path
  end

  def get_session_cost
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      @cost = @nameframe.calculate_cost
    else
      @cost = 0
    end
    render :json => @cost
  end

  def get_background_image
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
     render :partial => "/shared/frame_preview", :locales => {:nameframe => @nameframe}
    else
      render :text => "Your session has expired."
    end
  end

  def get_session_uploaded_images
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
     render :json => { :uploaded_images => @nameframe.uploaded_images.count }
    else
      render :text => "Your session has expired."
    end
  end

  def get_session_enabled_to_upload
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      enabled = (@nameframe.uploaded_images.count < @nameframe.get_max_uploaded_images)? true : false
      render :json => { :enabled => enabled }
    else
      render :text => "Your session has expired."
    end
  end
end

