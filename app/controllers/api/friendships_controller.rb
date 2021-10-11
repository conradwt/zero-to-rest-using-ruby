module API
  class FriendshipsController < ApplicationController
    before_action :set_person
    before_action :set_friendship, only: %i[show update destroy]

    # GET /api/people/:person_id/friendships
    def index
      @friendships = @person.friendships.all

      render json: @friendships
    end

    # GET /api/people/:person_id/friendships/:id
    def show
      render json: @friendship
    end

    # POST /api/people/:person_id/friendships
    def create
      @friendship = Friendship.new(friendship_params)

      if @friendship&.save
        render json: @friendship, status: :created, location: @friendship
      else
        render json: @friendship.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/people/:person_id/friendships/:id
    def update
      if @friendship&.update(friendship_params)
        render json: @friendship
      else
        render json: @friendship.errors, status: :unprocessable_entity
      end
    end

    # DELETE /api/people/:person_id/friendships/:id
    def destroy
      @friendship&.destroy
    end

    private

    def set_person
      @person = Person.find_by(id: params[:person_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      @friendship = @person.friendships.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friendship_params
      params.require(:friendship).permit(:person_id, :friend_id)
    end
  end
end
