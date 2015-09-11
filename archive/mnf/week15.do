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

predict_team nate, wr(6.69) cons(125)
predict_team buchta, qb(4.10) rb(4.05) wr(4.78) te(3.78) k(8.5) d(13.9) cons(10.5)
predict_team mikey, qb(4.90) rb(3.76 3.13) wr(6.46 6.18) te(5.09) k(7.8) d(15.9) 
predict_team oreilly, qb(5.18) rb(7.27 3.08) wr(7.60 4.97) te(3.87) k(9.9) d(15.7) 

local name_list nate oreilly buchta mikey 

foreach name1 in `name_list' {
    foreach name2 in `name_list' {
        if "`name1'" == "`name2'" {
            continue
        }
        gen `name1'_over_`name2' = `name1' > `name2'
    }
}

capture program drop boat
program define boat 
    args player opp1 opp2 opp3

    gen boat_`player' = `player'_over_`opp1' & `player'_over_`opp2' if `opp2'_over_`opp3'
    replace boat_`player' = `player'_over_`opp1' & `player'_over_`opp3' if `opp3'_over_`opp2'
end

boat nate buchta oreilly mikey
boat buchta nate oreilly mikey
boat oreilly mikey buchta nate 
boat mikey oreilly buchta nate 

egen low = rowmin(`name_list')
egen hi = rowmax(`name_list')

foreach name of local name_list {
    gen `name'_low = `name' == low
    gen `name'_hi = `name' == hi
}
collapse (mean) *over* `name_list' *low *hi boat*

xpose, clear v
