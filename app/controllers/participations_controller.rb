class ParticipationsController < ApplicationController
  def past_participations
    @past_participations = Participation.past.where(user: current_user).order(:id).map { |p| p.course }
    authorize(:participation, :past_participations?)

    if params[:query] && !params[:query].empty?
      PgSearch::Multisearch.rebuild(Course)
      PgSearch::Multisearch.rebuild(Chef)
      @results = PgSearch.multisearch(params[:query])

      @courses = []
      if @results.group_by(&:searchable_type)["User"]
        @results.group_by(&:searchable_type)["User"].each do |chef|
          chef.searchable.courses.each do |course|
            if @past_participations.include?(course)
              @courses << course
            end
          end
        end
      end

      if @results.group_by(&:searchable_type)["Course"]
        @results.group_by(&:searchable_type)["Course"].each do |course|
          if @past_participations.include?(course.searchable)
              @courses << course.searchable
          end
        end
      end
    else
      @courses = @past_participations
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.text { render partial: 'participations/list_participations', locals: { courses: @courses }, formats: [:html] }
    end
  end

  def upcoming_participations
    @upcoming_participations = Participation.upcoming
    authorize(:participation, :upcoming_participations?)
  end

  def favorites
    @favorites = Participation.favorites
    authorize(:participation, :favorites?)
  end

  def create
    @course = Course.find(params[:course_id])
    @participation = Participation.new(participation_params)
    @participation.course = @course
    @participation.user = current_user
    authorize @participation
    if @participation.save
      redirect_to course_path(@course), notice: "Demande de réservation envoyée !"
    else
      render :new
    end
  end


  def add_in_favorite
    @participation = Participation.find(params[:id])
    @participation.favorite == false ? @participation.update(favorite: true) : @participation.update(favorite: false)
    authorize @participation

    respond_to do |format|
      format.html { redirect_to past_participations_participations_path }
      format.text { render partial: "card_course", locals: { course: @participation.course }, formats: [:html] }
    end
  end

  private

  def participation_params
    params.require(:participation).permit(:favorite)
  end
end
