cd "C:/Users/savas/Documents/Ashoka/Courses/Social Policy in India/Social Policy Course Research/Data"
use nfhs4_relevant_vars, clear

forvalues i = 1/6{
	if `i' == 1 local gen_var zhfa_fb
	if `i' == 1 local use_var hw70_
	
	if `i' == 2 local gen_var zwfa_fb
	if `i' == 2 local use_var hw71_
	
	if `i' == 3 local gen_var hemoglobin_fb 
	if `i' == 3 local use_var hw53_
	
	if `i' == 4 local gen_var birth_year_fb
	if `i' == 4 local use_var b2_0
	
	if `i' == 5 local gen_var sex_fb
	if `i' == 5 local use_var b4_0
	
	if `i' == 6 local gen_var current_age_fb
	if `i' == 6 local use_var b8_0
	
	gen `gen_var' = .
	forvalues j = 1/6{
		
		replace `gen_var' = `use_var'`j' if bord_01 == `j' //when j = 1, and bord_01 == 1 is true, that means set value of (say) zhfa_fb = hw70_1. If j = 2 and bord_0 1== 2 is true, then set value of zhfa_fb = hw70_2, which captures the zhfa that child. You can check the validity of this code by running: br bord_01 bord_02 bord_03 b8_01 b8_02 b8_03 current_age_fb
	}
}

rename v021 psu
rename v130 religion
rename v024 state
rename v009 birth_month_respondent
rename v010 birth_year_respondent
rename v190 wealth_index
rename s723b asthama_respondent
rename v453 hemoglobin_respondent
replace hemoglobin_respondent = hemoglobin_respondent/10 //unit: g/dl 
rename v149 education_respondent
rename v440 zhfa_respondent
replace zhfa_respondent = zhfa_respondent / 100 

rename v025 residence
rename v201 tot_children_ever_born 
rename v012 respondent_current_age
rename v136 num_hh_mem
rename s116 caste	
decode state, gen (statename)
rename v438 height_respondent 
replace height_respondent = height_respondent/10 //unit: cm 

rename v439 height_age_percentile_respondent
rename v444 weight_height_percent_stddev_who
rename s723a diabetes_respondent 
rename s723c thyroid_respondent 
rename s723d heart_disease_respondent
rename v437 weight_respondent
replace weight_respondent = weight_respondent/10 //unit: kg
rename sdistri district

//first job: correct this - get exact ages with birth months and year/month of survey. Then create the i) expsoure variable and ii) duratoin of exposure. 

//used for plotting pre-trend of children x years old in late and early implementing states
forvalues year = 1965/2005{
	gen age_`year' = `year' - birth_year_respondent
}

//use current age of respondent_current_age to get age in years. 
//suppose july 1 is cutoff for school. 

local birth_month_cutoff 12 //currently: December. Mostly is it july. 
forvalues year = 2000/2006{
	gen schage_`year'_jn1 = .
	replace schage_`year'_jn1 = `year' - birth_year_respondent if birth_month_respondent <= `birth_month_cutoff'
	replace schage_`year'_jn1 = `year' - birth_year_respondent - 1 if birth_month_respondent > `birth_month_cutoff' 
}
//take year = 1996. Then, generate school age in 1996 with birth month cutoff for school entry at birth_month_cutoff. Now take two people, one born in 1994 and the other born in 1998 (both born before the bith month cutoff). Then, school age in 1996 for person 1 is 1996  1994 = 2, and for person 2 it is -2. 

//Then, suppose both were in Andhra. In 2003, for person 1, school age was 2003 - 1994 = 7. For person 2, school age in 2003 was 5.  
//exposure for person 1 was 4 years, for person 2 it was 5 years (full expsoure, because she got MDMS in 2004 when she was 6). 

//now person 3 born in 1999 (before month cutoff) in Andhra (thus school age in 2003 was 4), also recieved the program for 5 years. 

//suppose mother born in january 1997 in bihar (MDMS started in 2005). Then, in jan 2003, she is 6 years old. In Jan 2005, she is 8 years old. But what grade is she in? Her school year, say, starts in July. Then, in july 2003, she is 6, and thus she starts primary school (grade 1). But her primary school did not have MDMS, until 2005 (suppose it started in Jan 2005). In Jan 2005, she turns 8, and she is still in class 2. She gets the MDMS for class 2, 3, 4, 5 = 4 years. 
  
//now take a mother born in october 1997 in bihar. Suppose in Bihar primary school starts in July. When it is july 2003, she is still 5 years old. Thus, she cannot start primary school yet. Thus, she joins 1st grade in july 2004, when she is 6 years old (she will turn 7 in october 2004). The MDMS in her school also starts in 2005. She is 7 on Jan 2005 (when supposedly the MDMS starts), and is in grade 1.  

/***
global num_expose 7
forvalues i = 1/$num_expose{
	if `i' == 1 local minage_exposed_1 10
	if `i' == 1 local maxage_exposed_1 14
	if `i' == 1 local minage_exposed_0 15
	if `i' == 1 local maxage_exposed_0 16
	
	if `i' == 2 local minage_exposed_1 10 
	if `i' == 2 local maxage_exposed_1 12
	if `i' == 2 local minage_exposed_0 13
	if `i' == 2 local maxage_exposed_0 14 
	
	if `i' == 3 local minage_exposed_1 10
	if `i' == 3 local maxage_exposed_1 12
	if `i' == 3 local minage_exposed_0 15
	if `i' == 3 local maxage_exposed_0 16
	
	if `i' == 4 local minage_exposed_1 6
	if `i' == 4 local maxage_exposed_1 10
	if `i' == 4 local minage_exposed_0 11
	if `i' == 4 local maxage_exposed_0 12
	
	if `i' == 5 local minage_exposed_1 6 
	if `i' == 5 local maxage_exposed_1 10
	if `i' == 5 local minage_exposed_0 14
	if `i' == 5 local maxage_exposed_0 15
	
	if `i' == 6 local minage_exposed_1 8 
	if `i' == 6 local maxage_exposed_1 10
	if `i' == 6 local minage_exposed_0 11
	if `i' == 6 local maxage_exposed_0 12
	
	if `i' == 7 local minage_exposed_1 6
	if `i' == 7 local maxage_exposed_1 7
	if `i' == 7 local minage_exposed_0 8
	if `i' == 7 local maxage_exposed_0 10
	
	/***
	if i == 8 local minage_exposed_1  
	if i == 8 local maxage_exposed_1 
	if i == 8 local minage_exposed_0  
	if i == 8 local maxage_exposed_0
	***/
	
	//create a hypothetical exposure variable. Individual was exposed in 2003 if age >= 10 and age <= 14. Same for other years .Then, suppose a state introduced the MDMS in year 2003. Then all children in that state aged 10-14 were actually exposed, and 15 to 16 were not exposed. Suppose in another state MDMS was introduced in 2004. Then all children 10-14 in that state were exposed, while 15-16 were not exposed. 
	
	forvalues year = 2001/2005{
		gen exposed_`i'_in_`year' = 1 if age_`year' >= `minage_exposed_1' & age_`year' <= `maxage_exposed_1'
		replace exposed_`i'_in_`year' = 0 if age_`year' >= `minage_exposed_0' & age_`year' >= `maxage_exposed_0' //all other values have nans in them. Thus, no need to filter now. 
	}
	
}

//expsoure dependent on state 
forvalues i = 1/$num_expose{
	gen exposed_`i' = .
	replace exposed_`i' = 1 if statename == "andhra pradesh" & exposed_`i'_in_2003 == 1
	replace exposed_`i' = 1 if statename == "assam" & exposed_`i'_in_2005 == 1
	replace exposed_`i' = 1 if statename == "bihar" & exposed_`i'_in_2005 == 1
	replace exposed_`i' = 1 if statename == "chhattisgarh" & exposed_`i'_in_2002 == 1
	replace exposed_`i' = 1 if statename == "haryana" & exposed_`i'_in_2004 == 1
	replace exposed_`i' = 1 if statename == "himachal pradesh" & exposed_`i'_in_2004 == 1
	replace exposed_`i' = 1 if statename == "karnataka" & exposed_`i'_in_2003 == 1
	replace exposed_`i' = 1 if statename == "madhya pradesh" & exposed_`i'_in_2003 == 1
	replace exposed_`i' = 1 if statename == "maharashtra" & exposed_`i'_in_2003 == 1
	replace exposed_`i' = 1 if statename == "orissa" & exposed_`i'_in_2004 == 1
	replace exposed_`i' = 1 if statename == "rajasthan" & exposed_`i'_in_2002 == 1
	replace exposed_`i' = 1 if statename == "uttar pradesh" & exposed_`i'_in_2004 == 1
	replace exposed_`i' = 1 if statename == "uttaranchal" & exposed_`i'_in_2003 == 1

	replace exposed_`i' = 0 if statename == "andhra pradesh" & exposed_`i'_in_2003 == 0 
	replace exposed_`i' = 0 if statename == "assam" & exposed_`i'_in_2005 == 0
	replace exposed_`i' = 0 if statename == "bihar" & exposed_`i'_in_2005 == 0
	replace exposed_`i' = 0 if statename == "chhattisgarh" & exposed_`i'_in_2002 == 0
	replace exposed_`i' = 0 if statename == "haryana" & exposed_`i'_in_2004 == 0
	replace exposed_`i' = 0 if statename == "himachal pradesh" & exposed_`i'_in_2004 == 0
	replace exposed_`i' = 0 if statename == "karnataka" & exposed_`i'_in_2003 == 0
	replace exposed_`i' = 0 if statename == "madhya pradesh" & exposed_`i'_in_2003 == 0
	replace exposed_`i' = 0 if statename == "maharashtra" & exposed_`i'_in_2003 == 0
	replace exposed_`i' = 0 if statename == "orissa" & exposed_`i'_in_2004 == 0
	replace exposed_`i' = 0 if statename == "rajasthan" & exposed_`i'_in_2002 == 0 
	replace exposed_`i' = 0 if statename == "uttar pradesh" & exposed_`i'_in_2004 == 0
	replace exposed_`i' = 0 if statename == "uttaranchal" & exposed_`i'_in_2003 == 0
	sum exposed_`i'
}
***/

//create num years of exposure 
//if mother born in 1996 in AP, then she was 7 in 2003, and thus was exposed for 11 - 7 = 4 years. 
//if mother born in 1996 in Himachal, then she was 8 in 2004, and thus was expoed for 11 - 8 = 3 years. (11 - 8 because child exposed to MDMS in age 10 too. Hence, 8, 9, 10: 3 years of exposure) 

//thus, if we fix birth year of mother, then we have potential randomness in number of years of exposure. 
//We need to find age of mother in year of implementation in that mother's state, and subtract it from from 10 to get years of implementation.

/***
if statename == "andhra pradesh" 
if statename == "assam" 
if statename == "bihar" 
if statename == "chhattisgarh" 
if statename == "haryana"
if statename == "himachal pradesh" 
if statename == "karnataka" 
if statename == "madhya pradesh" 
if statename == "maharashtra" 
if statename == "orissa" 
if statename == "rajasthan" 
if statename == "uttar pradesh" 
if statename == "uttaranchal" 
***/

gen years_of_exposure = .
replace years_of_exposure = 11 - schage_2003_jn1 if statename == "andhra pradesh" 
replace years_of_exposure = 11 - schage_2004_jn1 if statename == "arunachal pradesh" 
replace years_of_exposure = 11 - schage_2005_jn1 if statename == "assam"  
replace years_of_exposure = 11 - schage_2005_jn1 if statename == "bihar" 
replace years_of_exposure = 11 - schage_2002_jn1 if statename == "chhattisgarh" 
replace years_of_exposure = 11 - schage_2002_jn1 if statename == "dadra and nagar haveli" 
replace years_of_exposure = 11 - schage_2003_jn1 if statename == "daman and diu" 
replace years_of_exposure = 11 - schage_2004_jn1 if statename == "haryana"
replace years_of_exposure = 11 - schage_2004_jn1 if statename == "himachal pradesh"
replace years_of_exposure = 11 - schage_2005_jn1 if statename == "jammu and kashmir"
replace years_of_exposure = 11 - schage_2003_jn1 if statename == "karnataka"  
replace years_of_exposure = 11 - schage_2004_jn1 if statename == "madhya pradesh"  
replace years_of_exposure = 11 - schage_2003_jn1 if statename == "maharashtra"
replace years_of_exposure = 11 - schage_2004_jn1 if statename == "manipur"
replace years_of_exposure = 11 - schage_2006_jn1 if statename == "mizoram" 
replace years_of_exposure = 11 - schage_2003_jn1 if statename == "meghalaya"
replace years_of_exposure = 11 - schage_2004_jn1 if statename == "orissa" 
replace years_of_exposure = 11 - schage_2004_jn1 if statename == "punjab" 
replace years_of_exposure = 11 - schage_2002_jn1 if statename == "rajasthan"
replace years_of_exposure = 11 - schage_2002_jn1 if statename == "sikkim" 
replace years_of_exposure = 11 - schage_2003_jn1 if statename == "tripura"   
replace years_of_exposure = 11 - schage_2004_jn1 if statename == "uttar pradesh"
replace years_of_exposure = 11 - schage_2003_jn1 if statename == "uttaranchal" 
replace years_of_exposure = 11 - schage_2005_jn1 if statename == "west bengal" 

replace years_of_exposure = 5 if years_of_exposure != . & years_of_exposure >= 5

//early implemter if 2002-2004
//late if 2005-
gen early_implementer = . 
replace early_implementer = 1 if statename == "chhattisgarh" | statename == "dadra and nagar haveli" | statename == "daman and diu" | statename == "rajasthan" | statename == "sikkim" | statename == "andhra pradesh" | statename == "karnataka" | statename == "maharashtra" | statename == "meghalaya" | statename == "tripura" | statename == "uttaranchal"
replace early_implementer = 0 if early_implementer != 1 & years_of_exposure != .

//avg zhfa by early implemetner over birth years of respondents. 
bysort early_implementer birth_year_respondent: egen avg_zhfa_2015_birthyear = mean(zhfa_respondent)
bysort early_implementer years_of_exposure: egen avg_zhfa_2015_expsoure = mean(zhfa_respondent)

gen stunted_mother = .
replace stunted_mother = 1 if zhfa_respondent <= - 2 & zhfa_respondent != . & zhfa_respondent <= 10
replace stunted_mother = 0 if zhfa_respondent > - 2 & zhfa_respondent != . & zhfa_respondent <= 10

gen stunted_fb = .
replace stunted_fb = 1 if zhfa_fb <= - 2 & zhfa_fb != . & zhfa_fb <= 10
replace stunted_fb = 0 if zhfa_fb > - 2 & zhfa_fb != . & zhfa_fb <= 10

gen wasted_fb = .
replace wasted_fb = 1 if zwfa_fb <= - 2 & zwfa_fb != . & zwfa_fb <= 10
replace wasted_fb = 0 if zwfa_fb > - 2 & zwfa_fb != . & zwfa_fb <= 10

gen bmi_respondent = .
replace bmi_respondent = (weight_respondent/10) / ((height_respondent/1000)^2) if weight_respondent <= 1500 & height_respondent <= 3000

gen state_time = state * birth_year_respondent

//below this zhfa zwfa analysis because we drop many observations. 
global zhfa_fb_condition zhfa_fb <= 1000
global zwfa_fb_condition zwfa_fb <= 1000
global atleast_primry_edu education_respondent >= 2
global atleast_secondary education_respondent >= 4
global residence_condition residence == 2


//summary tables 
//chnage directory to save output files there. 
cd "C:\Users\savas\Documents\Ashoka\Courses\Social Policy in India\Social Policy Course Research\Output Files"

preserve 
eststo clear
gen early_implemnt_inv_forttest = -1 * early_implementer
keep if zhfa_respondent <= 10 
keep if years_of_exposure >= 0
keep if asthama_respondent <= 1 & thyroid_respondent <= 1 & heart_disease_respondent <= 1 
keep if hemoglobin_respondent <= 30
keep if height_respondent <= 250  //unit: cm
keep if weight_respondent <= 150 //unit: kg 
keep if $residence_condition
eststo: estpost sum years_of_exposure respondent_current_age height_respondent zhfa_respondent stunted_mother weight_respondent wealth_index tot_children_ever_born num_hh_mem asthama_respondent  thyroid_respondent heart_disease_respondent hemoglobin_respondent if early_implementer == 1 
eststo: estpost sum years_of_exposure respondent_current_age height_respondent zhfa_respondent stunted_mother weight_respondent wealth_index tot_children_ever_born num_hh_mem asthama_respondent  thyroid_respondent heart_disease_respondent hemoglobin_respondent if early_implementer == 0
eststo: estpost ttest  years_of_exposure respondent_current_age height_respondent zhfa_respondent stunted_mother weight_respondent wealth_index tot_children_ever_born num_hh_mem asthama_respondent  thyroid_respondent heart_disease_respondent hemoglobin_respondent, by (early_implemnt_inv_forttest)
esttab using "sumtable_women.tex",  cells("mean(pattern(1 1 0) fmt(3)) sd(pattern(1 1 0) fmt(3)) b(star pattern(0 0 1) fmt(3))") nolabel unstack nonum nogaps collabels("Mean" "SD" "Difference") mtitles("Early Implementer" "Late Implementer" "") rename(years_of_exposure "MDMS Exposure (Years)" respondent_current_age "Current Age (Years)" weight_respondent "Current Weight (kg)" height_respondent "Current Height (cm)" zhfa_respondent "Z-score Height for Age" stunted_mother "Proportion Stunted" wealth_index "Wealth Index" num_hh_mem "Number of HH Members" tot_children_ever_born "Total Children Ever Born" asthama_respondent "Proportion with Asthama" thyroid_respondent "Proportion with Thyroid"  heart_disease_respondent "Proportion with Heart Disease"  hemoglobin_respondent "Hemoglobin Level (g/dl)" ) title("Summary Statistics of Women from Individual Recode\label{sumstats-women}") addnotes("Sample Restricted to Rural Women.") replace
restore

/***
//for mother
forvalues i = 1/$num_expose{
	reghdfe zhfa_respondent exposed_`i' tot_children_ever_born if zhfa_respondent <= 1000 & $atleast_primry_edu & $residence_condition, absorb(state wealth_index respondent_current_age)
}

forvalues i = 1/$num_expose{
	reghdfe asthama_respondent exposed_`i' tot_children_ever_born if asthama_respondent <= 1 & $atleast_primry_edu & $residence_condition, absorb(state wealth_index respondent_current_age)
}

forvalues i = 1/$num_expose{
	reghdfe hemoglobin_fb exposed_`i' tot_children_ever_born if hemoglobin_fb <= 995 & $atleast_primry_edu & $residence_condition, absorb(state wealth_index respondent_current_age)
}

//raw exposed variable
forvalues i = 1/$num_expose{
	reg zhfa_fb exposed_`i' if $zhfa_fb_condition & $residence_condition
}

forvalues i = 1/$num_expose{
	reg zwfa_fb exposed_`i' if $zhfa_fb_condition & $residence_condition
}

//full specficiation 
forvalues i = 1/$num_expose{
	reghdfe zhfa_fb exposed_`i' tot_children_ever_born num_hh_mem if $zhfa_fb_condition & $atleast_primry_edu & $residence_condition, absorb(state birth_year_fb wealth_index respondent_current_age sex_fb caste)
}

forvalues i = 1/$num_expose{
	reghdfe zwfa_fb exposed_`i' tot_children_ever_born num_hh_mem if $zhfa_fb_condition & $atleast_primry_edu & $residence_condition, absorb(state birth_year_fb wealth_index respondent_current_age sex_fb caste)
}

//heterogeneity: by wealth_index 
forvalues i = 1/$num_expose{
	reghdfe zhfa_fb exposed_`i'##ib5.wealth_index tot_children_ever_born num_hh_mem if $zhfa_fb_condition & $atleast_primry_edu & $residence_condition, absorb(state birth_year_fb respondent_current_age sex_fb caste) baselevels
}

forvalues i = 1/$num_expose{
	reghdfe zwfa_fb exposed_`i'##ib5.wealth_index tot_children_ever_born num_hh_mem if $zhfa_fb_condition & $atleast_primry_edu & $residence_condition, absorb(state birth_year_fb respondent_current_age sex_fb caste) baselevels
}

//heterogeneity: by caste 
forvalues i = 1/$num_expose{
	reghdfe zhfa_fb exposed_`i'##ib4.caste tot_children_ever_born num_hh_mem if $zhfa_fb_condition & $atleast_primry_edu & $residence_condition, absorb(state birth_year_fb wealth_index respondent_current_age sex_fb) baselevels
}

forvalues i = 1/$num_expose{
	reghdfe zwfa_fb exposed_`i'##ib4.caste tot_children_ever_born num_hh_mem if $zhfa_fb_condition & $atleast_primry_edu & $residence_condition, absorb(state birth_year_fb wealth_index respondent_current_age sex_fb) baselevels
}
***/


//==============================================================================

stop running here. 

global controls num_hh_mem

//respondent: height: continous
reghdfe height_respondent years_of_exposure if height_respondent <= 3000 & years_of_exposure >= 0 & years_of_exposure != . & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent state wealth_index religion caste) 

//respondent: weight: continous
reghdfe weight_respondent years_of_exposure if weight_respondent <= 1500 & years_of_exposure >= 0 & years_of_exposure != . & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent state wealth_index religion caste) 

//respondent: bmi: continous
reghdfe bmi_respondent years_of_exposure if  years_of_exposure >= 0 & years_of_exposure != . & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent state wealth_index caste) 

//respondent: ZHFA: continous
eststo r1: reghdfe zhfa_respondent years_of_exposure if years_of_exposure >= 0 & years_of_exposure != . & zhfa_respondent <= 10 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent psu wealth_index religion caste) 
estadd local birth_year_respondent_FE "Yes"
estadd local psu_FE "Yes"
estadd local other_fe "Yes"


//respondent: stunting
eststo r2: reghdfe stunted_mother years_of_exposure if years_of_exposure >= 0 & years_of_exposure != . & zhfa_respondent <= 10 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent psu wealth_index religion caste) 
estadd local birth_year_respondent_FE "Yes"
estadd local psu_FE "Yes"
estadd local other_fe "Yes"

//respondent: ZHFA: discrete
preserve 
keep if years_of_exposure >= 0 & years_of_exposure != .
eststo r7: reghdfe zhfa_respondent ib0.years_of_exposure if years_of_exposure >= 0 & years_of_exposure != . & zhfa_respondent <= 10 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent psu wealth_index religion caste) baselevels
estadd local birth_year_respondent_FE "Yes"
estadd local psu_FE "Yes"
estadd local other_fe "Yes"

cd "C:\Users\savas\Documents\Ashoka\Courses\Social Policy in India\Social Policy Course Research\Output Files"
coefplot, vertical drop(_cons) yline(0) xlabel(, angle(vertical)) xtitle("Years of Exposure") ytitle("ZHFA of Mother") title("ZHFA by Years of Exposure to MDMS") coeflabels(1.years_of_exposure = "One" 2.years_of_exposure = "Two" 3.years_of_exposure = "Three" 4.years_of_exposure = "Four" 5.years_of_exposure = "Five") yscale(range(-0.02 0.2)) 

graph export "zhfa_impact_allwomen.png", as(png) name ("Graph") replace 

restore

//respondent: hemoglobin
eststo r3: reghdfe hemoglobin_respondent years_of_exposure if years_of_exposure >= 0 & years_of_exposure != . & hemoglobin_respondent <= 30 &  $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent psu wealth_index religion caste) baselevels
estadd local birth_year_respondent_FE "Yes"
estadd local psu_FE "Yes"
estadd local other_fe "Yes"

//respondent: asthama 
eststo r4: reghdfe asthama_respondent years_of_exposure if years_of_exposure >= 0 & years_of_exposure != . & asthama_respondent <= 1 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent psu wealth_index religion caste) baselevels
estadd local birth_year_respondent_FE "Yes"
estadd local psu_FE "Yes"
estadd local other_fe "Yes"

//respondent: diabetes 
eststo r5: reghdfe diabetes_respondent years_of_exposure if years_of_exposure >= 0 & years_of_exposure != . & diabetes_respondent <= 1 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent psu wealth_index religion caste) baselevels
estadd local birth_year_respondent_FE "Yes"
estadd local psu_FE "Yes"
estadd local other_fe "Yes"

//respondent: heart disease 
eststo r6: reghdfe heart_disease_respondent years_of_exposure if years_of_exposure >= 0 & years_of_exposure != . & heart_disease_respondent <= 1 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent psu wealth_index religion caste) baselevels
estadd local birth_year_respondent_FE "Yes"
estadd local psu_FE "Yes"
estadd local other_fe "Yes"

cd "C:\Users\savas\Documents\Ashoka\Courses\Social Policy in India\Social Policy Course Research\Output Files"
esttab r1 r2 r3 r4 r6  using "respondents_IR_regs.tex", varlabel(years_of_exposure "Years of Exposure" _cons "Intercept") mtitles("ZHFA" "Stunting" "Hemoglobin (g/dl)" "Asthama" "Heart Disease") se star(* 0.10 ** 0.05 *** 0.01) s(birth_year_respondent_FE psu_FE other_fe N r2, label("Mother Birth Year FE" "PSU FE" "Other FE" "Observations" "$ R^2$")) addnotes("Sample restricted to rural women who completed primary education. Other fixed effects include wealth index, caste, and religion fixed effects.") replace

//check impact on education. 

stop here. Go to the Births recode from now. 

/*
//fb:zhfa: continous 
eststo a1: reghdfe zhfa_fb years_of_exposure if  years_of_exposure >= 0 & years_of_exposure != . & zhfa_fb <= 1000 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent birth_year_fb district wealth_index caste sex_fb) baselevels
estadd local mother_education_condition "Primary"
estadd local birth_year_respondent_FE "Yes"
estadd local birth_year_fb_FE "Yes"
estadd local district_FE "Yes"
estadd local wealth_index_FE "Yes"
estadd local caste_FE "Yes"

//fb:stunting: dummy
eststo a2: reghdfe stunted_fb years_of_exposure if  years_of_exposure >= 0 & years_of_exposure != . & zhfa_fb <= 1000 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent birth_year_fb district wealth_index caste sex_fb) baselevels
estadd local mother_education_condition "Primary"
estadd local birth_year_respondent_FE "Yes"
estadd local birth_year_fb_FE "Yes"
estadd local district_FE "Yes"
estadd local wealth_index_FE "Yes"
estadd local caste_FE "Yes"

//fb:zwfa: continous 
eststo a3: reghdfe zwfa_fb years_of_exposure if years_of_exposure >= 0 & years_of_exposure != . & zwfa_fb <= 1000 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent birth_year_fb district wealth_index caste sex_fb) baselevels
estadd local mother_education_condition "Primary"
estadd local birth_year_respondent_FE "Yes"
estadd local birth_year_fb_FE "Yes"
estadd local district_FE "Yes"
estadd local wealth_index_FE "Yes"
estadd local caste_FE "Yes"

//fb:zwfa: wasted_fb + atleast_primry_edu of mother
eststo a4: reghdfe wasted_fb years_of_exposure if years_of_exposure >= 0 & years_of_exposure != . & zwfa_fb <= 1000 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent birth_year_fb district wealth_index caste sex_fb) baselevels
estadd local mother_education_condition "Primary"
estadd local birth_year_respondent_FE "Yes"
estadd local birth_year_fb_FE "Yes"
estadd local district_FE "Yes"
estadd local wealth_index_FE "Yes"
estadd local caste_FE "Yes"

//fb:zwfa: wasted_fb + atleast_secondary of mother 
eststo a5: reghdfe wasted_fb years_of_exposure if years_of_exposure >= 0 & years_of_exposure != . & zwfa_fb <= 1000 & $atleast_secondary & $residence_condition, absorb(birth_year_respondent birth_year_fb district wealth_index caste sex_fb) baselevels
estadd local mother_education_condition "Secondary"
estadd local birth_year_respondent_FE "Yes"
estadd local birth_year_fb_FE "Yes"
estadd local district_FE "Yes"
estadd local wealth_index_FE "Yes"
estadd local caste_FE "Yes"

esttab a1 a2 a3 a4 a5 using "test.rtf", varlabel(years_of_exposure "Years of Exposure") mtitles("ZHFA" "Stunted" "ZWFA" "Wasted" "Wasted") se star(* 0.10 ** 0.05 *** 0.01) s(mother_education_condition birth_year_respondent_FE birth_year_fb_FE district_FE wealth_index_FE caste_FE N r2, label("Minimum Education of Mother" "Mother Birth Year FE" "Child Birth Year FE" "District FE" "Wealth Index FE" "Caste FE" "Observations" "$ R^2$")) addnotes("Sample restricted to rural women.") replace

//fb: zhfa: discrete 
preserve 
keep if years_of_exposure >= 0 & years_of_exposure != .
reghdfe zhfa_fb i.years_of_exposure if zhfa_fb <= 1000 & $atleast_primry_edu &  $residence_condition, absorb(birth_year_respondent birth_year_fb district wealth_index caste sex_fb) baselevels
restore 

//fb: ZWFA: discrete 
preserve 
keep if years_of_exposure >= 0 & years_of_exposure != .
reghdfe zwfa_fb i.years_of_exposure if zwfa_fb <= 1000 & $atleast_primry_edu &  $residence_condition, absorb(birth_year_respondent birth_year_fb district wealth_index caste sex_fb) baselevels
restore 

//fb: ZHFA and ZWFA: heterogeneity by caste
reghdfe zhfa_fb c.years_of_exposure##ib4.caste if caste != 8 &  years_of_exposure >= 0 & years_of_exposure != . & zhfa_fb <= 1000 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent birth_year_fb district wealth_index sex_fb) baselevels

reghdfe zwfa_fb c.years_of_exposure##ib4.caste if caste != 8 & years_of_exposure >= 0 & years_of_exposure != . & zhfa_fb <= 1000 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent birth_year_fb district wealth_index sex_fb) baselevels

//fb: ZHFA and ZWFA: heterogeneity by wealth index
reghdfe zhfa_fb c.years_of_exposure##i.wealth_index if caste != 8 &  years_of_exposure >= 0 & years_of_exposure != . & zhfa_fb <= 1000 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent birth_year_fb district caste sex_fb) baselevels

reghdfe zwfa_fb c.years_of_exposure##i.wealth_index if caste != 8 & years_of_exposure >= 0 & years_of_exposure != . & zhfa_fb <= 1000 & $atleast_primry_edu & $residence_condition, absorb(birth_year_respondent birth_year_fb district caste sex_fb) baselevels

*/

//check for pre-trends: 

//for mothers born before 1992 - that is, all mothers in all states must have turned 10 by 2002
sort birth_year_respondent
twoway (line avg_zhfa_2015_birthyear birth_year_respondent if early_implementer == 1 & birth_year_respondent <= 1992) (line avg_zhfa_2015_birthyear birth_year_respondent if early_implementer == 0 & birth_year_respondent <= 1992) (lfit avg_zhfa_2015_birthyear birth_year_respondent if early_implementer == 1 & birth_year_respondent <= 1992) (lfit avg_zhfa_2015_birthyear birth_year_respondent if early_implementer == 0 & birth_year_respondent <= 1992) , legend(label (1 "early implementer states") label (2 "late implementer states") label (3 "linear trend: early states") label (4 "linear trend: late states"))

//for mothers born after 1992. 
sort birth_year_respondent
twoway (line avg_zhfa_2015_birthyear birth_year_respondent if early_implementer == 1 & birth_year_respondent >= 1995) (line avg_zhfa_2015_birthyear birth_year_respondent if early_implementer == 0 & birth_year_respondent >= 1992) (lfit avg_zhfa_2015_birthyear birth_year_respondent if early_implementer == 1 & birth_year_respondent >= 1992) (lfit avg_zhfa_2015_birthyear birth_year_respondent if early_implementer == 0 & birth_year_respondent >= 1992), legend(label (1 "early implementer states") label (2 "late implementer states") label (3 "linear trend: early states") label (4 "linear trend: late states"))

//we ideally want pre-trends of this sort: take the mean zhfa of 6 year old children in each year. THat is, for all c6 year old children in in year t, take the average zhfa right now. Then take the average of 6 year old children in year t + 1. And so on. The difference between early and late implementing states should be the same, and evolve similarly over time - parellal trends must hold. However, it is sufficient to show that parellal trends hold when we consider make the graph with respect to birth year. This is because the children did grow older and were 6 at some point, so there is a one to one mapping between age of birth and age at 6 for any individual. 

//on years of exposure: for those born before 1992.'
sort years_of_exposure
twoway (line avg_zhfa_2015_expsoure years_of_exposure if early_implementer == 1 & birth_year_respondent <= 1992) (line avg_zhfa_2015_expsoure years_of_exposure if early_implementer == 0 & birth_year_respondent <= 1992) (lfit avg_zhfa_2015_expsoure years_of_exposure if early_implementer == 1 & birth_year_respondent <= 1992) (lfit avg_zhfa_2015_expsoure years_of_exposure if early_implementer == 0 & birth_year_respondent <= 1992) , legend(label (1 "early implementer states") label (2 "late implementer states") label (3 "linear trend: early states") label (4 "linear trend: late states"))

//on years of exposure: for those born after 1992.
sort years_of_exposure
twoway (line avg_zhfa_2015_expsoure years_of_exposure if early_implementer == 1 & years_of_exposure >= 0) (line avg_zhfa_2015_expsoure years_of_exposure if early_implementer == 0 & years_of_exposure >= 0) (lfit avg_zhfa_2015_expsoure years_of_exposure if early_implementer == 1 & years_of_exposure >= 0) (lfit avg_zhfa_2015_expsoure years_of_exposure if early_implementer == 0 & years_of_exposure >= 0) , legend(label (1 "early implementer states") label (2 "late implementer states") label (3 "linear trend: early states") label (4 "linear trend: late states"))



