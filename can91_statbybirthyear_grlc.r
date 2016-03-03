rm(list=ls())
library(RCurl)
library(texreg)


canada <- getURL("http://grlc.clariah-sdh.eculture.labs.vu.nl/CLARIAH/wp4-queries/can91_statusbybirthyear_5", httpheader = c(Accept = "text/csv"))
canada <- read.csv(textConnection(canada))
sweden <- getURL("http://grlc.clariah-sdh.eculture.labs.vu.nl/clariah/wp4-queries/swe90_statusbybirthyear", httpheader = c(Accept = "text/csv"))
sweden <- read.csv(textConnection(sweden))

fit_canada_base <- lm(log(hiscam) ~ log(gdppc), data=canada)
fit_canada <- lm(log(hiscam) ~ log(gdppc) + I(age^2) + age, data=canada)
fit_sweden_base <- lm(log(hiscam) ~ log(gdppc), data=sweden)
fit_sweden <- lm(log(hiscam) ~ log(gdppc) + I(age^2) + age, data=sweden)

texreg::texreg(list(fit_canada, fit_sweden))

pdf('~/dropbox/files attached directly to project/presentations/usecaseplots.pdf', height=3, width=10)
par(mfrow=c(1, 4), mar=c(4, 4, 3, 0))
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