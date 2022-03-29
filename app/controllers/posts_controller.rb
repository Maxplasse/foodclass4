class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = policy_scope(Post).order(posted_at: :desc)
    @post = Post.new
    if current_user
      @courses = current_user.courses_as_participant.where("end_at < ?", Time.now)
    end
  end

  def new
    @post = Post.new
  end

  def create
    if params[:course_id].present?
      @course = Course.find(params[:course_id])
      @post = Post.new(post_params)
      @participation = current_user.participations.find_by(course: @course)
      @post.course = @course
      @post.participation = @participation
      authorize @post
      if @post.save
        redirect_to course_path(@course)
      else
        render 'courses/show'
      end
    else
      @course = Course.find(params[:post][:course_id])
      @post = Post.new(post_params)
      @participation = current_user.participations.find_by(course: @course)
      @post.course = @course
      @post.participation = @participation
      authorize @post
      if @post.save
        redirect_to posts_path
      else
        @posts = policy_scope(Post).order(posted_at: :desc)
        @courses = current_user.courses_as_participant.where("end_at < ?", Time.now)
        render 'posts/index'
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    authorize @post
    @post.destroy

    redirect_to posts_path
  end


  private

  def post_params
    params.require(:post).permit(:content, :photo)
  end
end
