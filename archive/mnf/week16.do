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

predict_team nate, qb(6.03) rb(6.98 3.82) wr(6.48 6.26) te(7.16) k(117/14) //d(173/14) 
predict_team oreilly, qb(5.18) rb(6.36 3.50) wr(7.31 4.92) te(4.13) k(140/14) //d(203/14) 

local name_list nate oreilly 

foreach name1 in `name_list' {
    foreach name2 in `name_list' {
        if "`name1'" == "`name2'" {
            continue
        }
        gen `name1'_over_`name2' = `name1' > `name2'
    }
}

egen low = rowmin(`name_list')
egen hi = rowmax(`name_list')

foreach name of local name_list {
    gen `name'_low = `name' == low
    gen `name'_hi = `name' == hi
}
collapse (mean) *over* `name_list' *low *hi 

xpose, clear v
