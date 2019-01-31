require 'rubygems'
require 'httparty'
require 'nokogiri'
require "addressable/uri"
require "awesome_print"
require "./crawl_base"

# Genres
# Action, Adventure, Animation, Biography, Comedy, Crime, Documentary, Drama, Family, Fantasy, Film-Noir, Game-Show, History, Horror, Music, Musical, Mystery, News, Reality-TV, Romance, Sci-Fi, Sport, Talk-Show, Thriller, War, Western

class Yts < CrawlBase
  def initialize(url, yts_options={})
    @movies = {}
    @options = {}
    @options[:from] = yts_options[:from] || 1
    @options[:to] = yts_options[:to] || 299
    @options[:imdb_rating_gt] = yts_options[:imdb_rating_gt]
    @options[:rt_critic_rating_gt] = yts_options[:rt_critic_rating_gt]
    @options[:year_gt] = yts_options[:year_gt]
    @options[:exclude_genres] = yts_options[:exclude_genres] || ['Documentary', 'Romance', 'Talk-Show', 'Reality-TV', 'News', 'Musical', 'Music', 'Animation']
    super(url)
  end

  def options
    @options
  end

  def parse!
    (options[:from]..options[:to]).to_a.each_with_index do |page_number|
      @url = [base_url, "page=#{page_number}"].join('?')
      puts @url
      page
      @page.css(".browse-movie-wrap").each do |row|
        skip_movie = false
        title = row.at_css('.browse-movie-bottom .browse-movie-title').text rescue nil
        movie = {}
        movie[:imdb_rating] = (row.at_css('.rating').text).split('/')[0].strip.to_f rescue 0
        movie[:year] = row.at_css('.browse-movie-bottom .browse-movie-year').text.to_i rescue 0
        movie[:title] = title
        movie[:link] = row.at_css('.browse-movie-link')['href'] rescue nil
        movie[:genres] = row.css('h4').drop(1).map{ |x| x.text } rescue nil
        # movie[:torrent_720] = row.css('.browse-movie-bottom .browse-movie-tags a')[0]['href'] rescue nil
        movie[:torrent_1080] = row.css('.browse-movie-bottom .browse-movie-tags a')[1]['href'] rescue nil

        if options[:imdb_rating_gt] && movie[:imdb_rating].to_f < options[:imdb_rating_gt].to_f
          skip_movie = true
        end

        if !skip_movie && options[:exclude_genres] && options[:exclude_genres].is_a?(Array)
          movie[:genres].each do |genre|
            if options[:exclude_genres].include?(genre)
              skip_movie = true
              break
            end
          end
        end

        if !skip_movie && options[:year_gt] &&  movie[:year].to_i < options[:year_gt].to_i
          skip_movie = true
        end

        if !skip_movie && !movie[:torrent_1080]
          skip_movie = true
        end

        if !skip_movie
         movie[:rt_cirtic_rating] = parse_page(movie[:link])
         skip_movie = true if (movie[:rt_cirtic_rating].to_f < options[:rt_cirtic_rating_gt].to_f)
       end

       puts movie
       puts skip_movie
       puts

        @movies[movie[:title]] = movie unless skip_movie
      end
      # sleep_random
    end
  end

  def parse_page(url)
    @url = url
    page
    @page.at_css('.rating-row:nth-child(2) .icon+ span').text.split('%')[0].to_f rescue 0.0
  end

  def movies
    @movies
  end
end

yts = Yts.new("https://yts.pm/browse-movies", {to: 3, imdb_rating_gt: 7, rt_cirtic_rating_gt: 70, year_gt: 1990})
yts.parse!
ap yts.movies