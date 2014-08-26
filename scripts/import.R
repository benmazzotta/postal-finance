# #####
# Import script
# #####


# ###
# Goals
# 
# 1. Read the data from delimited files
# 2. Structure appropriately: numbers, factors
# 3. Summarize data availability


# ### 
# 1. Read the data

df <- read.delim("../data/UPU-2008-2012.txt", header=T, stringsAsFactors=F, dec=",")
names(df)
str(df)

lapply(df, function(xx) table(is.na(xx)))


# install.packages("countrycodes")
require(countrycodes)
