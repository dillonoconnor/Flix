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

  def main_image(movie)
    if movie.main_image.attached?
      image_tag movie.main_image.variant(resize_to_limit: [150, nil])
    else
      image_tag "placeholder.png"
    end
  end

end
