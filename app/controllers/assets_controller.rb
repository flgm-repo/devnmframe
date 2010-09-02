class AssetsController < ApplicationController
  protect_from_forgery :except => [:swfupload, :save_flex_image, :save_added_image_properties, :update_html_frame]

  before_filter :store_location, :current_action, :only => [:select_font, :select_frame, :select_matting, :select_ornament, :upload_image]

  def index
  end

  def select_name_ajax
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      @nameframe.selected_text = params[:name_selection]
      if @nameframe.save
        @nameframe.builder
        @image_name = @nameframe.get_image_path
        @cost = @nameframe.calculate_cost
        return(render :update do |page|
          page["cost"].replace_html @cost
          page["preview_image"].replace_html :partial=>"/shared/preview_image"
        end)
      else
        return(render :update do |page|
          page.insert_html :after, "name_selection", :partial=>"/shared/show_errors", :locals =>{ :errors => @nameframe.errors}
        end)
      end
    end
  end

  def select_font_ajax
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      @nameframe.font = FontType.find_by_name(params[:font])
      @nameframe.uploaded_images.each{ |image| image.photo_customizations.each{ |customization| customization.destroy } }
      session[:photo_customizations] = nil
      @nameframe.flex_address = nil
      if @nameframe.save
        @nameframe.builder
        @image_name = @nameframe.get_image_path
        @cost = @nameframe.calculate_cost
        return(render :update do |page|
          page["cost"].replace_html @cost
          page["preview_image"].replace_html :partial=>"/shared/preview_image"
        end)
      else
        return(render :update do |page|
          page["errors"].replace_html :partial=>"/shared/show_errors", :locals =>{ :errors => @nameframe.errors}
        end)
      end
    end
  end

  def select_frame_ajax
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      @nameframe.frame = Frame.find_by_name(params[:frame])
      if @nameframe.save
        @nameframe.builder
        @image_name = @nameframe.get_image_path
        @cost = @nameframe.calculate_cost
        return(render :update do |page|
          page["cost"].replace_html @cost
          page["preview_image"].replace_html :partial=>"/shared/preview_image"
        end)
      else
        return(render :update do |page|
          page["errors"].replace_html :partial=>"/shared/show_errors", :locals =>{ :errors => @nameframe.errors}
        end)
      end
    end
  end

  def select_top_matt_ajax
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      @nameframe.top_matt = Matt.find_by_code(params[:top_matt])
      if @nameframe.save
        @nameframe.builder
        @image_name = @nameframe.get_image_path
        @cost = @nameframe.calculate_cost
        if @nameframe.frame
          @allowed_matts = @nameframe.top_matt.permissions.allowed.distinct_bottom_matt.by_frame(@nameframe.frame.id)
        else
          @allowed_matts = @nameframe.top_matt.permissions.allowed.distinct_bottom_matt
        end
        @bottom_matts = []
        @allowed_matts.each do |allowed|
          @bottom_matts << allowed.bottom_matt unless allowed.bottom_matt.nil?
        end
        return(
          render :update do |page|
            page["bottom_matt"].replace_html :partial=>"/shared/matt_selection"
            page["cost"].replace_html @cost
            page["preview_image"].replace_html :partial=>"/shared/preview_image"
          end
        )
      else
        return(render :update do |page|
          page["errors"].replace_html :partial=>"/shared/show_errors", :locals =>{ :errors => @nameframe.errors}
        end)
      end
    end
  end

  def select_bottom_matt_ajax
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      @nameframe.bottom_matt = Matt.find_by_code(params[:bottom_matt])
      if @nameframe.save
        @nameframe.builder
        @image_name = @nameframe.get_image_path
        @cost = @nameframe.calculate_cost
        return(render :update do |page|
          page["cost"].replace_html @cost
          page["preview_image"].replace_html :partial=>"/shared/preview_image"
        end)
      else
        return(render :update do |page|
          page["errors"].replace_html :partial=>"/shared/show_errors", :locals =>{ :errors => @nameframe.errors}
        end)
      end
    end
  end

  def select_ornament_ajax
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      unless params[:ornament].nil? || params[:ornament_type].nil?
        case params[:ornament_type]
          when "top_left"
            @nameframe.top_left_ornament = (params[:ornament] == "none")? nil : Ornament.find_by_name(params[:ornament])
          when "top_right"
            @nameframe.top_right_ornament = (params[:ornament] == "none")? nil : Ornament.find_by_name(params[:ornament])
          when "bottom_left"
            @nameframe.bottom_left_ornament = (params[:ornament] == "none")? nil : Ornament.find_by_name(params[:ornament])
          when "bottom_right"
            @nameframe.bottom_right_ornament = (params[:ornament] == "none")? nil : Ornament.find_by_name(params[:ornament])
        end
      end
      if @nameframe.save
        @nameframe.builder
        @image_name = @nameframe.get_image_path
        @cost = @nameframe.calculate_cost
        return(render :update do |page|
          page["cost"].replace_html @cost
          page["preview_image"].replace_html :partial=>"/shared/preview_image"
        end)
      else
        return(render :update do |page|
          page["errors"].replace_html :partial=>"/shared/show_errors", :locals =>{ :errors => @nameframe.errors}
        end)
      end
    end
  end

  def checkout_ajax
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      if (!@nameframe.flex_address.nil? || @nameframe.without_images == true)
        render :json => {:action => "redirect", :url => checkout_path}
      else
        render :json => {:action => "show_error", :selector => "uploaded_images_error"}
      end
    end
  end

  # This is the first method called, is the only step that has params
  def select_font
    if session[:uuid].nil?
      if params[:name_selection].blank?
        session[:display_error] = true
        redirect_to root_path
        return
      else
        session[:uuid] = UUIDTools::UUID.random_create.to_s
        @nameframe = Nameframe.new_with_default_values(:uuid => session[:uuid], :selected_text => params[:name_selection])
      end
    else
      if !params[:name_selection].blank?
        @nameframe = Nameframe.new_with_default_values(:uuid => session[:uuid], :selected_text => params[:name_selection])
       else
         @nameframe = Nameframe.find_by_uuid(session[:uuid])
      end

    end
    if @nameframe.nil? || !@nameframe.save
      session[:display_error] = true
      redirect_to root_path
      return
    else
      @header_image = "frame_grace_03.gif"
      @header_image_text = "Choose this font (Serpentine) or any of the other fonts you see listed below."
      @nameframe.builder
      @image_name = @nameframe.get_image_path
      @cost = @nameframe.calculate_cost
      @fonts = FontType.all
    end
  end

  def select_frame
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      @image_name = @nameframe.get_image_path
      @cost = @nameframe.calculate_cost
      @header_image = "frame_carlos_03.gif"
      @header_image_text = "Some people choose blue for boys and pink for girls.  You should choose the frame color you like best."
      @frames = Frame.all
    else
      flash[:notice] = "Your session has expired, please enter your name again"
      redirect_to root_path
    end
  end

  def select_matting
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      @header_image = "frame_joshua_03.gif"
      @header_image_text = "Whether you choose a single mat or a double mat (as shown here), the color selections have been limited so your name frame will always look great."
      @image_name = @nameframe.get_image_path
      @cost = @nameframe.calculate_cost
      @allowed_matts = (@nameframe.frame.nil?)? FrameMattPermissions.distinct_top_matt : @nameframe.frame.permissions.distinct_top_matt
      @top_matts = []
      @allowed_matts.each do |allowed_matt|
        @top_matts << allowed_matt.top_matt unless allowed_matt.top_matt.nil?
      end

      if @nameframe.frame
        @allowed_matts = @nameframe.top_matt.permissions.allowed.distinct_bottom_matt.by_frame(@nameframe.frame.id)
      else
        @allowed_matts = @nameframe.top_matt.permissions.allowed.distinct_bottom_matt
      end
      @bottom_matts = []

      @allowed_matts.each do |allowed|
        @bottom_matts << allowed.bottom_matt unless allowed.bottom_matt.nil?
      end
    else
      flash[:notice] = "Your session has expired, please enter your name again"
      redirect_to root_path
    end
  end

  def select_ornament
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    if @nameframe
      @header_image = "frame_ethan_03.gif"
      @header_image_text = "For added flair, ornaments may be added to any corner."
      @image_name = @nameframe.get_image_path
      @cost = @nameframe.calculate_cost
      if @nameframe.top_matt.name == "White" && @nameframe.bottom_matt.nil?
        @ornaments = []
      else
        @ornaments = Ornament.all
      end
    else
      flash[:notice] = "Your session has expired, please enter your name again"
      redirect_to root_path
    end
  end

  def upload_image
    @nameframe = Nameframe.find_by_uuid(session[:uuid])

    if @nameframe
      @image_name = @nameframe.get_image_path
      @cost = @nameframe.calculate_cost
      @max_photo_uploads = @nameframe.get_max_uploaded_images
      @uploaded_images = @nameframe.uploaded_images
    else
      flash[:notice] = "Your session has expired, please enter your name again"
      redirect_to root_path
    end
  end

  #this method is for upload every  photo and is assigned to nameframe id
  def swfupload
    @nameframe = Nameframe.find_by_uuid(params[:name_frame])
    if @nameframe.uploaded_images.count < @nameframe.get_max_uploaded_images
      begin
        @nameframe.without_images = false if @nameframe.without_images == true
        @photo = Photo.new(:uploaded_data => params[:Filedata])
        @nameframe.uploaded_images << @photo
        @nameframe.save
        render :json => {:success => true, :id => @photo.id, :path => @photo.public_filename(:thumb)}
      rescue Exception => e
        render :json => {:success => false, :mesage => "There were some errors. Please try again."}
      end
    else
      render :text => "You can't upload more photos"
    end
  end

  def destroy_image
    @nameframe = Nameframe.find_by_uuid(session[:uuid])

    if @nameframe
      @image = @nameframe.uploaded_images.find(params[:image_id])
      @image.destroy if @image
      @images_count = @nameframe.uploaded_images.count
      if @image_count == 0
        @nameframe.without_images = true
        @nameframe.flex_address = nil
      else
        @nameframe.without_images = false
      end
      @nameframe.save
      @nameframe.builder
      @image_name = @nameframe.get_image_path
      @cost = @nameframe.calculate_cost
      @nameframe = Nameframe.find_by_uuid(session[:uuid])
      render :update do |page|
        page["uploaded_images"].replace_html(:partial=>"/shared/uploaded_images", :locals => {:uploaded_images => @nameframe.uploaded_images })
        page["cost"].replace_html @cost
        page["preview_image"].replace_html :partial=>"/shared/preview_image"
      end
    else
      flash[:notice] = "Your session has expired, please enter your name again"
      redirect_to root_path
    end
  end

  def saving_data
    if current_user
      @nameframe = Nameframe.find_by_uuid(session[:uuid])
      if @nameframe
        @nameframe.user = current_user
        unless session[:photo_customizations].blank?
          # First, we delete all the customizations previously saved
          @nameframe.uploaded_images.each{|photo| photo.photo_customizations.delete_all }
          # Then loop over the saved customizations and saved them
          @nameframe.set_images_customizations(session[:photo_customizations])
        end
        @nameframe.save
      else
        flash[:notice] = "Your session has expired, please enter your name again"
        redirect_to root_path
      end
    end
    redirect_to request.referer
  end

  def get_preview
    uuid = session[:uuid]
    @nameframe = Nameframe.find_by_uuid(uuid)
    if @nameframe
      send_data @nameframe.builder("flex").to_blob, :filename => "#{uuid}.png", :disposition => "inline", :type => "image/png"
    else
      render :text => "Sorry, your session has expired."
    end
  end

  def get_flash_vars
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    flash_vars = {:nameframe_uuid => @nameframe.uuid, :font => @nameframe.font.name, :name => @nameframe.selected_text} rescue []
    render :json => flash_vars
  end

  def get_text_dimensions
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    dimensions = @nameframe.get_text_information rescue []
    render :xml => dimensions
  end

  def get_uploaded_images
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    objs = []
    @uploaded_images = @nameframe.uploaded_images rescue []
    @uploaded_images.each { |e|
      obj = {:id => e.id.to_s, :thumb_filename => e.public_filename(:thumb),
        :large_filename => e.public_filename}
      objs << obj
    }
    render :xml => objs
  end

  def save_flex_image
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    @nameframe.save_flex_image(request.body)
    render :text => "success"
  end

# This method saves the images' customized properties in session vars. Those values are later saved in the DB if the work is saved
  def save_added_image_properties
#   params[:encodedAddedImageObjects] must be gotten JSON formatted like this:
#     '[
#       {"id":39,"x":459,"width":45,"y":306,"largeFilename":null,"rotation":0,"height":88, "letterPosition":3, "isMaskStretchable":true, stretchedImageWidth: 3.36, stretchedImageHeight: 2.89 },
#       {"id":38,"x":459,"width":45,"y":306,"largeFilename":null,"rotation":0,"height":88, "letterPosition":3, "isMaskStretchable":true, stretchedImageWidth: 3.36, stretchedImageHeight: 2.89 },
#       {"id":37,"x":459,"width":45,"y":306,"largeFilename":null,"rotation":0,"height":88, "letterPosition":3, "isMaskStretchable":true, stretchedImageWidth: 3.36, stretchedImageHeight: 2.89 },
#       {"id":36,"x":459,"width":45,"y":306,"largeFilename":null,"rotation":0,"height":88, "letterPosition":3, "isMaskStretchable":true, stretchedImageWidth: 3.36, stretchedImageHeight: 2.89 }
#     ]'
    imagesCustomizations = ActiveSupport::JSON.decode(params[:encodedAddedImageObjects])
    session[:photo_customizations] = []
    customizations = []
    imagesCustomizations.each do |image|
      customizations << {:id => image["id"] , :x => image["x"], :y => image["y"], :rotation => image["rotation"], :width => image["width"], :height => image["height"], :large_filename => image["largeFilename"], :letter_position => image["letterPosition"], :is_mask_stretchable => image["isMaskStretchable"], :stretched_image_width => image["stretchedImageWidth"], :stretched_image_height => image["stretchedImageHeight"] }
    end
    session[:photo_customizations] = customizations
    render :text => "success"
  end

  def session_image_properties
    session[:photo_customizations] ||= []
    render :json => session[:photo_customizations]
  end

  def update_html_frame
    @nameframe = Nameframe.find_by_uuid(session[:uuid])
    @nameframe.flex_address = "#{@nameframe.uuid}.jpg"
    @nameframe.save
    @nameframe.builder
    return(render :update do |page|
      page["image_preview"].replace_html :partial=>"/shared/frame_preview", :action=> "upload_image"
    end)
  end

  def current_action
    session[:current_action] = session[:return_to].sub("/assets/", "")
  end

end

