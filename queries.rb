require "sqlite3"
db = SQLite3::Database.new("chinook.sqlite")

# List all customers (name + email), ordered alphabetically (no extra information)
def list_customers(db)
  query = <<-SQL
    SELECT first_name, last_name, email FROM customers
    ORDER BY first_name ASC;
  SQL
  rows = db.execute(query)
end

# List tracks (Name + Composer) of the Classical playlist
def list_tracks(db)
  query = <<-SQL
    SELECT tracks.name, tracks.composer FROM playlist_tracks
    JOIN tracks ON tracks.id = playlist_tracks.track_id
    JOIN playlists ON playlists.id = playlist_tracks.playlist_id
    WHERE playlists.name = 'Classical';
  SQL
  rows = db.execute(query)
end

# List the 10 artists mostly listed in all playlists
def top_artists(db)
  query = <<-SQL
    SELECT artists.name, COUNT(*) AS occurences FROM artists
    JOIN albums ON artists.id = albums.artist_id
    JOIN tracks On tracks.album_id = albums.id
    JOIN playlist_tracks ON playlist_tracks.track_id = tracks.id
    GROUP BY artists.name
    ORDER BY occurences DESC
    LIMIT 10;
  SQL
  rows = db.execute(query)
end

# List the tracks which have been purchased at least twice, ordered by number of purchases
def purchased_twice
  query = <<-SQL
    SELECT tracks.name, COUNT(*) AS purchases FROM tracks
    JOIN invoice_lines ON invoice_lines.track_id = tracks.id
    GROUP BY tracks.name
    HAVING purchases > 1
    ORDER BY purchases DESC;
  SQL
  rows = db.execute(query)
end
