* DEISING VS HANSON
* 106.45 - 127.5
* Deising: Maclin, Ertz

* BUCHTA VS ALT
* 129.6 - 158.05
* Buchta: Jordan Matthews, Alt: Gano

* BRUSDA VS NATE
* 118.9 - 85.9
* Nate: Sanchez, Bru: Benjamin

* MIKEY VS RYNE
* 111.65 - 102.35
* Mikey: Greg Olsen, Ryne: McCoy, Eagles D

clear
set obs 1000000

* Deising
gen jm = rgamma(3.31,5.69)
gen ze = rgamma(2.8,3.47)

gen deising_win = jm + ze + 106.45 > 127.5

* Buchta
gen jom = rgamma(3.31,3.2)
gen gg = 68/9

gen buchta_win = jom + 129.6 > 158.05 + gg
gen buchta2_win = jom >= 32.8

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
