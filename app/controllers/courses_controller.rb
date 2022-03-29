class CoursesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show], :raise => false

  def index
    if params[:query] && !params[:query].empty?
      @courses = policy_scope(Course).order(created_at: :desc)
      PgSearch::Multisearch.rebuild(Course)
      PgSearch::Multisearch.rebuild(Chef)
      PgSearch::Multisearch.rebuild(User)
      @results = PgSearch.multisearch(params[:query])

      @courses = []
      if @results.group_by(&:searchable_type)["User"]
        @results.group_by(&:searchable_type)["User"].each do |user|
          user.searchable.courses.each do |course|
            @courses << course
          end
        end
      end

      if @results.group_by(&:searchable_type)["Chef"]
        @results.group_by(&:searchable_type)["Chef"].each do |chef|
          chef.searchable.courses.each do |course|
            @courses << course
          end
        end
      end

      if @results.group_by(&:searchable_type)["Course"]
        @results.group_by(&:searchable_type)["Course"].each do |course|
          @courses << course.searchable
        end
      end
    else
      @courses = policy_scope(Course).order(created_at: :desc)
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'courses/list', locals: { courses: @courses }, formats: [:html] }
    end
  end

  def show
    @course = Course.find(params[:id])
    authorize @course
    @post = Post.new
  end

end
