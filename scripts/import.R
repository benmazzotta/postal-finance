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

df <- read.delim("../data/UPU-2008-2012.txt", header=T, stringsAsFactors=F, dec=",", encoding="UTF-8")
names(df)
str(df)

lapply(df, function(xx) table(is.na(xx)))

head(unique(df$Administrations), 20)

# install.packages("countrycode")
require(countrycode)

df$abbr <- countrycode(df$Administrations, "country.name", "wb", warn=T)
names(df)
df <- with(df, data.frame(Administrations, abbr, Years, Value, Items, Remark, Info, Ref., X))
df$Region <- countrycode(df$abbr, "wb", "region", warn=T)

## Did country abbreviations work? Appears yes.

table(df$abbr)
table(df$Administrations)

# unique(grep("Congo", df$Administrations, value=T))

#  #  Problem countries check out: Hong Kong, Macao, Ned Antilles, Congo-K, Congo-B
# df[df$Administrations %in% c("Hongkong, China","Macao, China","Netherlands Antilles", "Congo (Rep.)","Democratic Republic of the Congo"),1:3]


# ###
# 2. Data structures: integers, factors, strings and numbers

# Status quo ante
str(df)


## There is no data in variable X
summary(df$X)
df$X <- NULL

str(df)

## Explain: df$Info refers to UPU codes for missing values in df$Value.
with(df, table(is.na(Value), Info))

levels(df$Info)
levels(df$Info) <- c("","Not reported","Negligible","VR [sic]")

names(df)[names(df)=="Info"] <- "Missing data"
names(df)

attr(df$Value, "units") <- "Special Drawing Rights (SDR)"

varnames <- c("gross","expense","result","net","finsvc")
df$varname <- factor(df$Item, labels=varnames)

names(df[names(df)=="Administrations"]) <- "Country"

#   Recap:
#   193 countries, 181 with known abbr codes
lapply(df, levels)
summary(df)

# ### 
# Summary
# 1. Administrations and abbr are plausible.
# 2. Not all countries reported all years. Many country-years report missing data.
# 3. Values of revenue are reported in SDR except Share of income linked to postal services.
# 

save(df, file="../data/UPU.Rda")

save.image("../data/UPU import 2014.Rdata")
save.image("../data/current.Rdata")

# END
# #####