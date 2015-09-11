local week 05

insheet using C:\BFF\output\model_out05.csv, comma clear

keep type playerid fantasypos name team opp alpha tot_beta proj

preserve
	insheet using C:\BFF\data\downloads\week`week'\Player.2013.csv, comma clear

	keep if inlist(fantasyposition,"QB","RB","WR","TE","K")

	keep playerid shortname

	sort playerid
	tempfile shortname
	save `shortname', replace
restore

sort playerid
merge m:1 playerid using `shortname', assert(match using) keep(match) nogen

drop name
rename shortname name

keep if type == "6 pt" | type == "ppr"

sort name fantasypos team
tempfile proj
save `proj', replace

insheet using C:\BBBowl\confidence\week01\rosters01.csv, comma clear names

drop if status == "Benched"
replace team = "JAX" if team == "JAC"
replace team = "CLE" if name == "T.Richardson"

sort name fantasypos team
merge 1:1 name fantasypos team using `proj'

destring proj alpha tot_beta, force replace
replace proj = 11 if name == "J.Blackmon"

bysort owner: egen team_proj = total(proj)

duplicates drop owner, force 

drop if owner == ""
