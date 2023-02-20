**Import data**
import delimited "C:\Users\Manoj\OneDrive - Kansas State University\discrete choice method\Data\hw3_data.csv"

**Removing missing data**
drop if missing(adopt)
drop if missing(rentac)
drop if missing(farmsize)
drop if missing(crpacres)
drop if missing(riskavdr)
drop if missing(offfarm)
drop if missing(age)
drop if missing(college)

global ylist adopt
global xlist rentac farmsize crpacres riskavdr offfarm age college

describe $ylist $xlist
summarize $ylist $xlist
list $ylist $xlist in 1/10
tabulate $ylist


***Part (a): Estimating logistic regression model
logit $ylist $xlist
logistic $ylist $xlist

***Part (b): Estimating marginal effects
quietly logit $ylist $xlist
margins, dydx(*) atmeans
margins, dydx(*) 

***Part (c): LR test
quietly logistic $ylist $xlist
estimates store m1

quietly logistic $ylist $xlist
predict logodd1, xb
gen logoddsq = logodd^2

logistic adopt rentac farmsize crpacres riskavdr offfarm age college logoddsq
estimates store m2

lrtest m1 m2

***Part (d): Estimating probit model
probit $ylist $xlist

***Part (e): Estimating marginal effects in probit regression models****
quietly probit $ylist $xlist
margins, dydx(*) atmeans
margins, dydx(*) 

***Part (f): Bernoulli Regression Model specification models****
**********Identification of distribution*****

**Checking distribution
hist college, normal
hist age, normal
hist offfarm, normal
hist riskavdr, normal
hist crpacres, normal
hist farmsize, normal
hist rentac, normal

****Checking normality***************
swilk age crpacres farmsize rentac
jb age
jb crpacres
jb farmsize
jb rentac

***Log transformation****
gen logrentac = log(rentac) 
gen logfarmsize = log(farmsize) 
gen logcrpacres = log(crpacres) 
gen logage = log(age)

gen sqrtcrpacres =sqrt(crpacres)

***Checking log-normal distribution*****
swilk logage logcrpacres logfarmsize logrentac
jb logage
jb logcrpacres
jb logfarmsize
jb logrentac

***Model test adding log of farmsize
logit adopt rentac farmsize crpacres riskavdr offfarm age college
estimates store m1
logit adopt rentac farmsize crpacres riskavdr offfarm age college logfarmsize
estimates store m2
test logfarmsize
lrtest m1 m2


**Model test adding sqrtcrpacres
logit adopt rentac farmsize crpacres riskavdr offfarm age college sqrtcrpacres
estimates store m3
test sqrtcrpacres
lrtest m1 m3


**model test adding square of age
logit adopt rentac farmsize crpacres riskavdr offfarm age college sqage
estimates store m4
test sqage
lrtest m1 m4


**model test adding sqrtcrpacres and square of age
logit adopt rentac farmsize crpacres riskavdr offfarm age college sqrtcrpacres sqage
estimates store m5
test sqrtcrpacres
test sqage
test sqrtcrpacres sqage
lrtest m1 m5

**ladder test for possible transformation of data to get in normal
ladder college
ladder age


