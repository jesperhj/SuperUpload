class Uploader < Sinatra::Application
    
  configure do
    set :upload_folder => 'uploaded_files',
        :unique_name => false,
        :error_messages => {
          :no_file            => 'Error. You need to choose a file!',
          :error_saving       => 'Error. Saving failed!',
          :generic_error      => 'Error! Something went wrong',
          :filename_not_found => 'Error. Filename not found!',
          :upload_complete_filename_missing => 'Error. Upload complete but filename is missing!'
        }
  end
  
  #############################################################################
  # Display upload form
  #############################################################################
  get '/' do
    @transfer_id = Guid.new.to_s
    erb :index
  end
  
  #############################################################################
  # Logic when receiving description
  # Return filename and path if upload is finished otherwise return a default
  # message
  #############################################################################
  post '/description' do
    content_type :json
    
    transfer_id = params[:transfer_id]
    
    if transfer_status(transfer_id) == 100
      filename  = filename_in_transfer transfer_id
      path      = Dir.getwd+'/ '+settings.upload_folder
    else
      filename  = "Upload not complete yet"
      path      = "Upload not complete yet"
    end
    
    if filename.nil?
      exit_with_error :upload_complete_filename_missing
    else
      {
        "result" => {
          "filename"    => filename,
          "path"        => path,
        },
        "error" => nil
      }.to_json
    end
  end
  
  #############################################################################
  # Status of an ongoing upload
  #############################################################################
  get '/transfer_status/:transfer_id' do
    content_type :json
    
    transfer_id = params[:transfer_id]
    
    {
      "result" => {
        "status"    => transfer_status(transfer_id)
      },
      "error" => nil
    }.to_json
  end
  
  #############################################################################
  # Save the uploaded file.
  # As we upload in an iframe and check status through AJAX, we dont
  # resond with anything useful here.
  #############################################################################
  post '/upload' do
    upload_file = params['upload_file']
    
    params.each do |p|
       upload_file = p[1] if p[0].match(/file-/) && !p[0][1].nil?
    end
    
    if [nil, 'undefined'].include? upload_file
      return exit_with_error :no_file
    end
    
    filename = upload_file[:filename]
    
    if save_file upload_file, filename
      #exit_with_success filename
    else
      #exit_with_error :error_saving
    end
    
    '' # we dont return anything here more, after switching from html5 to iframe
  end
  
  #############################################################################
  # After an upload is finished this recource delievers the name and path
  # of the uploaded file
  #############################################################################
  get '/post_upload_info/:transfer_id' do
    content_type :json
    
    transfer_id = params[:transfer_id]
    
    if transfer_status(transfer_id) == 100
      filename = filename_in_transfer(transfer_id)
    else
      filename = nil
    end
    
    if filename.nil?
      exit_with_error :filename_not_found
    else
      {
        "result" => {
          "filename"    => filename,
          "path"        => Dir.getwd+'/ '+settings.upload_folder,
        },
        "error" => nil
      }.to_json
    end
    
  end
  
  #############################################################################
  # Get the name of the uploaded file
  # Return filename of transfer, nil if filename could not be found
  #############################################################################
  def filename_in_transfer(transfer_id)
    begin
      f = File.open("/tmp/uploader_file-#{transfer_id}", 'r')
      info = JSON.parse f.readline
      f.close
      
      res = info['filename'].match /(.*\\){0,1}(.*)$/
      if !res.nil?
        res[2]
      else
        info['filename']
      end
    rescue Exception => e
      nil
    end
  end
  
  #############################################################################
  # Logic for checking upload progess
  #############################################################################
  def transfer_status(transfer_id)
    begin
      f = File.open("/tmp/uploader_file-#{transfer_id}", 'r')
      info = JSON.parse f.readline
      f.close
      
      if File.exist?(info['path'])
        current_size = File.size(info['path'])
        percent = (current_size.to_f/info['size'].to_f)*100
      elsif File.exist?(settings.upload_folder + '/' + filename_in_transfer(transfer_id))
        percent = 100
      else
        percent = 0
      end
    rescue Exception => e
      percent = 0
    end
    percent.to_i
  end
  
  #############################################################################
  # Generic function for returing error messages
  #############################################################################
  def exit_with_error(error_code)
    unless settings.error_messages.keys.include? error_code
      error_code = :generic_error
    end
    
    {
      "result"  => nil,
      "error"   => {
        "message" => settings.error_messages[error_code]
      }
    }.to_json
  end
  
  #############################################################################
  # Save the actual file to the correct place
  #############################################################################
  def save_file(upload_file, filename)
    full_path_to_file = settings.upload_folder + '/' + filename
    File.open(full_path_to_file, "w") do |f|
      f.write(upload_file[:tempfile].read)
    end
    
    File.file?(full_path_to_file) ? true : false
  end
end