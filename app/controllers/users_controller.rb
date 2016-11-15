class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_data
  
 
  def index

 
      if current_user.is_admin?
        @tasks = Task.all
        @users = User.where.not("id = ?",current_user.id).order("created_at DESC")
      else
        @tasks = current_user.tasks
	      @users = User.where.not("id = ?",current_user.id).where("admin = ?",true).order("created_at DESC")
      end

    unless params[:q].blank?
      @users = @users.where('name LIKE ? ',"%#{params[:q]}%")
    end

      @conversations = Conversation.involving(current_user).order("created_at DESC")
  end

  def accueil
   redirect_to :action => :index 
  end

  def search 
   index
   render :search
  end


 def edit 
  user = User.find(params[:id])
  render :edit , :locals => { :user => user }
 end

 def update 
   user = User.find(params[:id])
   user.update_attributes(user_params)
   list
 end


  def create 
    #TODO VERIFICATION### 
    
    user = User.new(user_params)
     if params[:admin] 
      user.admin = true
     end
    


    if !user.save 
      render :errors , :locals => { :user => user}
    else 
      list
    end
  end
  
  def list

    if params[:destroy_user]
      destroy_user(User.find(params[:destroy_user]))    
    end 

    @resellers  = User.where.not("id = ?",current_user.id).where("reseller = ? AND admin = ?",true,false).order("created_at DESC")
    @admins = User.where.not("id = ?",current_user.id).where("admin = ?",true).order("created_at DESC")

    unless params[:search_admin].blank?
      @admins = @admins.where('name LIKE ?',"%#{params[:search_admin]}%")
    end
    
    unless params[:search_reseller].blank?
     @resellers = @resellers.where('name LIKE ?',"%#{params[:search_reseller]}%")
    end

    render :update

  end


  def update_observation 
    @conversations = Conversation.involving(current_user).order("created_at DESC")
    render :partial => 'pending_conversation' 
  end

  private

def destroy_user(user)

 conversations = Conversation.involving(user).order("created_at DESC")
  conversations.each do |c|
   c.destroy 
  end 
  user.destroy
 end

  def user_params
    params.require(:user).permit(:name, :email, :password, :salt, :encrypted_password)
  end
end
