module WelcomeHelper
  def root_path?
    path = request.fullpath.split('?')[0]
    path == root_path
  end
end
