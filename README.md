# YTS Crawler
Crawl and filter movies based on your search criteria from YTS YIFY Movies Torrents website * in seconds. Save your time in doing manual research in browser.

## How to Run
Install Ruby and RVM and do `bundle install` from the root. Then, run the following
```sh
$ ruby yts.rb
```
If you want to edit params then you'll need to edit the `yts.rb` file:
```ruby
# example
Yts.new("https://yts.pm/browse-movies", {to: 3, imdb_rating_gt: 7, rt_cirtic_rating_gt: 70, year_gt: 1990})
```

## The params that new method take are:
### Mandatory Param in String
* url(string) : YTS url

### Optional Params in Hash
* from(integer) : page number
* to(integer) : page number
* imdb_rating_gt(float) : IMDB rating greater than
* rt_critic_rating_gt(float) : Rotten Tomatos critic rating greater than
* year_gt(integer) : Year greater than
* exclude_genres(array) : Genres to be excluded


#### Genres
* Action
* Adventure
* Animation
* Biography 
* Comedy 
* Crime 
* Documentary 
* Drama 
* Family 
* Fantasy 
* Film-Noir 
* Game-Show 
* History 
* Horror 
* Music 
* Musical 
* Mystery 
* News 
* Reality-TV 
* Romance 
* Sci-Fi 
* Sport 
* Talk-Show 
* Thriller 
* War 
* Western