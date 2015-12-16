setwd('~/downloads/data/qqt')
options(digits=10) # necessary for reading hiscam datafile
library(data.table)
library(texreg)


ca <- fread('canada1891.csv', data.table=F)
dim(ca)

ca$year <- ca$YEAR - ca$AGE

# left out: all clio-data preparing
clio <- read.csv('~/dropbox/cliodata/allcliodata_raw.csv')
clio <- clio[clio$ccode==124, c('ccode', 'year', 'gdp')]
ca <- merge(ca, clio, by='year')
dim(ca)

map1 <- read.csv('~/repos/converters/datasets/hisco/occhisco2hisco.csv')
ca <- merge(ca, map1, by.x='OCCHISCO', by.y='nappcode')
dim(ca)

map2 <- read.delim('http://www.camsis.stir.ac.uk/hiscam/v1_3_1/hiscam_ca.dat')
ca <- merge(ca, map2, by.x='hiscocodenum', by.y='hisco')
ca <- ca[sample(1:nrow(ca)), ]
dim(ca)
head(ca[!is.na(ca$gdp), c('year', 'AGE', 'OCCHISCO', 'hiscocode', 'hiscam', 'gdp')])

fit_age <- lm(log(hiscam) ~ log(gdp) + I(AGE^2) + AGE, data=ca)
fit_base <- lm(log(hiscam) ~ log(gdp), data=ca)
fit_aged <- lm(log(hiscam) ~ log(gdp) + as.factor(AGE), data=ca)
screenreg(list(fit_base, fit_age, fit_aged), omit.coef='factor',
    custom.model.names=rep('log(hiscam)', 3),
    stars=c(0.1, 0.05, 0.01), digits=3)
    # file='~/dropbox/files attached directly to project/presentations/reg.html')

d <- aggregate(hiscam ~ year + gdp + AGE, data=ca, mean)

# pdf('~/dropbox/files attached directly to project/presentations/vis.pdf', heigh=5)
# par(mfrow=c(1, 2))
# d <- d[order(d$year), ]
# plot(log(hiscam) ~ AGE, data=d, bty='l', type='b', col='red')
# d <- d[order(d$gdp), ]
# plot(log(hiscam) ~ log(gdp), data=d, bty='l', type='b', col='red')
# dev.off()

## using grlc API call
library(RCurl)
canada <- getURL("http://grlc.clariah-sdh.eculture.labs.vu.nl/clariah/wp4-queries/can91_statusbybirthyear_5", httpheader = c(Accept = "text/csv"))
canada <- read.csv(textConnection(canada))
sweden <- getURL("http://grlc.clariah-sdh.eculture.labs.vu.nl/clariah/wp4-queries/swe90_statusbybirthyear", httpheader = c(Accept = "text/csv"))
sweden <- read.csv(textConnection(sweden))

fit_canada_base <- lm(log(hiscam) ~ log(gdppc), data=canada)
fit_canada <- lm(log(hiscam) ~ log(gdppc) + I(age^2) + age, data=canada)
fit_sweden_base <- lm(log(hiscam) ~ log(gdppc), data=sweden)
fit_sweden <- lm(log(hiscam) ~ log(gdppc) + I(age^2) + age, data=sweden)

htmlreg(list(fit_canada_base, fit_canada),
    custom.model.names=c('log(hiscam)', 'log(hiscam'),
    stars=c(0.1, 0.05, 0.01), digits=3,
    file='~/dropbox/files attached directly to project/presentations/reg.html')
htmlreg(list(fit_canada, fit_sweden),
    custom.model.names=c('canada', 'sweden'),
    stars=c(0.1, 0.05, 0.01), digits=3,
    file='~/dropbox/files attached directly to project/presentations/reg.html')

pdf('~/dropbox/files attached directly to project/presentations/vis.pdf', height=5)
par(mfrow=c(1, 2))
d <- aggregate(hiscam ~ year + gdppc + age, data=canada, mean)
d <- d[order(d$year), ]
plot(log(hiscam) ~ age, data=d, bty='l', type='b', col='red', main='Canada')
d <- d[order(d$gdppc), ]
plot(log(hiscam) ~ log(gdppc), data=d, bty='l', type='b', col='red', main='Canada')
dev.off()

pdf('~/dropbox/files attached directly to project/presentations/compvis.pdf')
par(mfrow=c(2, 2))
d <- aggregate(hiscam ~ year + gdppc + age, data=canada, mean)
d <- d[order(d$year), ]
plot(log(hiscam) ~ age, data=d, bty='l', type='b', col='red', main='Canada')
d <- d[order(d$gdppc), ]
plot(log(hiscam) ~ log(gdppc), data=d, bty='l', type='b', col='red', main='Canada')

d <- aggregate(hiscam ~ year + gdppc + age, data=sweden, mean)
d <- d[order(d$year), ]
plot(log(hiscam) ~ age, data=d, bty='l', type='b', col='red', main='Sweden')
d <- d[order(d$gdppc), ]
plot(log(hiscam) ~ log(gdppc), data=d, bty='l', type='b', col='red', main='Sweden')
dev.off()

# cas <- read.table('../canada_occstat_sparql.dat', skip=2, 
#     colClasses=c('character', 'numeric', 'numeric'))