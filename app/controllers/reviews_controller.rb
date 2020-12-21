class ReviewsController < ApplicationController

    before_action :require_signin
    before_action :set_movie

    def index
        @reviews = @movie.reviews
    end

    def new
        @review = @movie.reviews.new
    end

    def create
        @review = @movie.reviews.new(movie_params)
        @review.user = current_user
        if @review.save
            redirect_to movie_reviews_url(@movie), notice: "Thanks for your review!"
        else
            render 'new'
        end
    end

    def edit
        @review = @movie.reviews.find(params[:id])
    end

    def update
        @review = @movie.reviews.find(params[:id])
        if @review.update(movie_params)
            redirect_to movie_reviews_url(@movie), notice: "Review updated!"
        else
            render 'edit'
        end
    end

    def destroy
        @review = Review.find(params[:id])
        @review.destroy
        redirect_to movie_reviews_url(@movie), alert: "Review deleted"
    end

    private

        def set_movie
            @movie = Movie.find_by!(slug: params[:movie_id])
        end

        def movie_params
            params.require(:review).permit(:stars, :comment)
        end
end
