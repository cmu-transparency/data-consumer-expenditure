LISTING_IND := https://www.bls.gov/cex/pumd_data.htm
LISTING_AGG := https://www.bls.gov/cex/tables.htm

scrape:
	perl scrape.pl $(LISTING_IND) \\.zip\$
	perl scrape.pl $(LISTING_AGG) \\.xlsx\$

install:
	cpan App::cpanminus
	cpanm URI::URL \
              Number::Bytes::Human \
              Term::ProgressBar \
	      Data::Dumper \
	      WWW::Mechanize \
	      Time::Stamp

download:
	wget https://www.bls.gov/cex/2017/combined/age.xlsx
	wget https://www.bls.gov/cex/2017/combined/cucomp.xlsx
	wget https://www.bls.gov/cex/2017/combined/decile.xlsx
	wget https://www.bls.gov/cex/2017/combined/gener.xlsx
	wget https://www.bls.gov/cex/2017/combined/educat.xlsx
	wget https://www.bls.gov/cex/2017/combined/hispanic.xlsx
	wget https://www.bls.gov/cex/2017/combined/tenure.xlsx
	wget https://www.bls.gov/cex/2017/combined/income.xlsx
	wget https://www.bls.gov/cex/2017/combined/earners.xlsx
	wget https://www.bls.gov/cex/2017/combined/occup.xlsx
	wget https://www.bls.gov/cex/2017/combined/population.xlsx
	wget https://www.bls.gov/cex/2017/combined/quintile.xlsx
	wget https://www.bls.gov/cex/2017/combined/race.xlsx
	wget https://www.bls.gov/cex/2017/combined/region.xlsx
	wget https://www.bls.gov/cex/2017/combined/cusize.xlsx
	wget https://www.bls.gov/cex/2017/combined/sage.xlsx

	wget https://www.bls.gov/cex/2017/aggregate/age.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/cucomp.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/decile.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/gener.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/educat.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/hispanic.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/tenure.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/income.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/earners.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/occup.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/population.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/quintile.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/race.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/region.xlsx
	wget https://www.bls.gov/cex/2017/aggregate/cusize.xlsx
