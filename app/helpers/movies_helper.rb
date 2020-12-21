module MoviesHelper

  def total_gross(movie)
    movie.flop? ? "Flop!" : number_to_currency(movie.total_gross, strip_insignificant_zeros: true)
  end

  def year_of(movie)
    movie.released_on.year
  end

  def nav_link_to(title, url)
    if current_page?(url)
      link_to title, url, class: "active"
    else
      link_to title, url
    end
  end

end
