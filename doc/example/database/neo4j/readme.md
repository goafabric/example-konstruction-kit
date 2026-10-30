# customers
CREATE TABLE customers AS SELECT * FROM read_csv('/Downloads/customers-100.csv');
https://www.datablist.com/learn/csv/download-sample-csv-files
  
# create db
.open testdb 
=> creates a database file, import will be slower

# imdb
https://www.kaggle.com/datasets

CREATE TABLE imdb AS SELECT * FROM read_csv('/Downloads/imdb.csv');

from imdb where vote_average > 8 and spoken_languages = 'English';

select count (*) from imdb where vote_average > 8 and spoken_languages = 'English';

