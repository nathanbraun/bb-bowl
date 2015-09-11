* nate

set more off
clear

set obs 1000000

scalar qb = 4.08
scalar rb = 3.3
scalar wr = 3.31
scalar te = 2.8

capture program drop predict_team
program define predict_team
    syntax anything, [qb(numlist) rb(numlist) wr(numlist) te(numlist) k(string) d(string) cons(numlist)]

    if !mi("`k'") {
        local k = `k'
    }
    if !mi("`d'") {
        local d = `d'
    }

    foreach pos in qb te {
        if mi("``pos''") {
            continue
        }
        gen `anything'_`pos' = rgamma(`pos',``pos'')
    }
    foreach pos in k d {
        if mi("``pos''") {
            continue
        }
        gen `anything'_`pos' = ``pos''
    }
    foreach pos in rb wr {
        if mi("``pos''") {
            continue
        }
        local i = 0
        foreach x of numlist ``pos'' {
            local i = `i' + 1
            gen `anything'_`pos'`i' = rgamma(`pos',`x')
        }
    }
    if !mi("`cons'") {
        gen `anything'_cons = 0
        foreach x of numlist `cons' {
            replace `anything'_cons = `anything'_cons + `x'
        }
    }

    egen `anything' = rowtotal(`anything'*)
end

predict_team nate, cons(159.8)
predict_team pdizz, cons(55.25)
predict_team buchta, wr(5.82) cons(152.45)
predict_team hanson, cons(137.65)
predict_team ryne, cons(75.15)
predict_team alt, qb(6.13) rb(5.39) cons(64.5)
predict_team bru, cons(97.75)
predict_team mikey, qb(4.77) wr(5.92) cons(117.6)
predict_team oreilly, rb(3.31) cons(130.45)
predict_team becker, cons(94.15)
predict_team deising, wr(5.74) k(99/12) cons(98.5)
predict_team steve, cons(138.65)

gen ryne_over_pdizz = ryne > pdizz
gen buchta_over_hanson = buchta > hanson

gen playoff_pdizz = !ryne_over_pdizz
gen playoff_ryne = ryne_over_pdizz & !buchta_over_hanson & (ryne + 109.25 > hanson)
replace playoff_ryne = 1 if ryne_over_pdizz & buchta_over_hanson & !(buchta + 73.75 > ryne)
gen playoff_hanson = ryne_over_pdizz & !buchta_over_hanson & (hanson > ryne + 109.25)
gen playoff_buchta = buchta_over_hanson & ryne_over_pdizz & (buchta + 73.75 > ryne)

gen steve_over_nate = steve > nate
gen becker_over_bru = becker > bru
gen oreilly_over_mikey = oreilly > mikey
gen alt_over_deising = alt > deising

gen playoff_mikey1 = mikey > oreilly
gen playoff_mikey2 = alt > deising & bru > becker & oreilly > mikey & ///
    (mikey + 1556.85 > bru + 1536.75) & (mikey + 1556.85 > alt + 1629.9) 
gen playoff_mikey3 = alt > deising & becker > bru
gen playoff_mikey4 = !becker_over_bru & !alt_over_deising & mikey + 20.1 > bru
gen playoff_mikey5 = becker_over_bru & !alt_over_deising & oreilly_over_mikey

egen playoff_mikey = rowtotal(playoff_mikey?)
replace playoff_mikey = playoff_mikey > 0

gen playoff_alt = alt > deising & bru > becker & oreilly > mikey & ///
    (alt + 1629.9 > bru + 1536.75) & (alt + 1629.9 > mikey + 1556.85) 

gen playoff_bru1 = alt > deising & bru > becker & oreilly > mikey & ///
    (bru + 1536.75 > alt + 1629.9) & (bru + 1536.75 > mikey + 1556.85) 
gen playoff_bru2 = !becker_over_bru & !alt_over_deising & mikey + 20.1 < bru

/*
gen playoff_mikey = !oreilly_over_mikey | (alt_over_deising & becker_over_bru) ///
    (becker_over_bru & !alt_over_deising & oreilly_over_mikey) | (oreilly_over_mikey & alt_over_deising & !becker_over_bru)
*/

local name_list nate alt bru oreilly ryne buchta mikey becker deising steve hanson pdizz

egen low = rowmin(`name_list')
egen hi = rowmax(`name_list')

foreach name of local name_list {
    gen `name'_low = `name' == low
    gen `name'_hi = `name' == hi
}
collapse (mean) *over* nate alt bru oreilly ryne buchta mikey becker deising steve hanson pdizz *low *hi playoff*

xpose, clear v
