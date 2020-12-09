module MoviesHelper
  def total_gross(movie)
    movie.flop? ? "Flop!" : number_to_currency(movie.total_gross, strip_insignificant_zeros: true)
  end

  def year_of(movie)
    movie.released_on.year
  end
end
