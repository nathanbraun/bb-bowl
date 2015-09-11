clear
set obs 1000000

gen jg = rgamma(2.8,7.13)
gen db = rgamma(4.08,5.57)

gen pwin = 86 + jg + db > 107.3
stop
* Alt
gen sg = 72/10

* Steve
gen jf = rgamma(3.30,4.55)
gen bills = 204/10

gen steve_win = bills + jf + 88.3 > 108.65


* Nate
gen ms = rgamma(4.08,4.50)

* Bru
gen kb = rgamma(3.31,4.26)

gen nate_win = 85.9 + ms > 118.9 + kb

* Mikey
gen go = rgamma(2.8,4.83)

* Ryne
gen lm = rgamma(3.3,4.55)
gen ed = 177/8

gen ryne_win = lm + ed + 102.35 > 111.65 + go

