class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line; basic_action end

  private
 def basic_action
   @omniauth = request.env['omniauth.auth']
   puts @omniauth
   if @omniauth.present?
     @profile = User.where(provider: @omniauth['provider'], uid: @omniauth['uid']).first
     if @profile
       @profile.set_values(@omniauth)
       sign_in(:user, @profile)
     else
       @profile = User.new(provider: @omniauth['provider'], uid: @omniauth['uid'], image: @omniauth['info']['image'], description: @omniauth['info']['description'])
       email = @omniauth['info']['email'] ? @omniauth['info']['email'] : "#{@omniauth['uid']}-#{@omniauth['provider']}@example.com"
       @profile = current_user || User.create!(provider: @omniauth['provider'], uid: @omniauth['uid'], email: email, name: @omniauth['info']['name'], image: @omniauth['info']['image'], description: @omniauth['info']['description'], password: Devise.friendly_token[0, 20])
       @profile.set_values(@omniauth)

       friend=Friend.new
       friend.name="名無し"
       friend.created_by=@profile.id
       friend.save()

       sign_in(:user, @profile)
       # redirect_to edit_user_path(@profile.user.id) and return

     end
   end

   redirect_to back_to || contract_list_path(status_filter_selected: 1)
 end

 private
  def back_to
    if request.env['omniauth.origin'].presence && back_to = CGI.unescape(request.env['omniauth.origin'].to_s)
      uri = URI.parse(back_to)
      return back_to if uri.relative? || uri.host == request.host
    end
    nil
  rescue
    nil
  end


 def fake_email(uid,provider)
    return "#{auth.uid}-#{auth.provider}@example.com"
 end
end
