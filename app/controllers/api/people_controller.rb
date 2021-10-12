module API
  class PeopleController < ApplicationController
    before_action :set_person, only: %i[show update destroy]

    # GET /api/people
    def index
      @people = Person.all

      render json: @people
    end

    # GET /api/people/:id
    def show
      render json: @person
    end

    # POST /api/people
    def create
      @person = Person.new(person_params)

      if @person.save
        render json: @person, status: :created, location: @person
      else
        render json: @person.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/people/:id
    def update
      if @person.update(person_params)
        render json: @person
      else
        render json: @person.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/people/:id
    def destroy
      @person.destroy
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:first_name, :last_name, :username, :email)
    end
  end
end
