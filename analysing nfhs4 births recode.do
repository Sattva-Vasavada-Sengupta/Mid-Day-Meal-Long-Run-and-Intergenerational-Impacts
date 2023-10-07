cd "C:\Users\savas\Documents\Ashoka\Courses\Social Policy in India\Social Policy Course Research\Data"

use "NFHS4 Births Recode.dta", clear

//Renaming and generating new variabels. 

//identifier variables 
rename v024 state
decode state, gen (statename)
rename sdistri district

//mother variabels 
rename v009 birth_month_mother
rename v010 birth_year_mother
rename s723b asthama_mother
rename v453 hemoglobin_mother
replace hemoglobin_mother = hemoglobin_mother / 10
rename v149 education_mother

rename v440 zhfa_mother
replace zhfa_mother = zhfa_mother/100

rename v201 tot_children_ever_born 
rename v012 current_age_mother
rename s116 caste	

rename v438 height_mother //is in 1 decimal cm. 
replace height_mother = height_mother/10

rename v439 height_age_percentile_mother
rename v444 weight_height_percent_stddev_who
rename s723a diabetes_mother
rename s723c thyroid_mother
rename s723d heart_disease_mohter

rename v437 weight_mother
replace weight_mother = weight_mother/10

rename v155 literacy 
rename v745b owns_land
rename v481 health_insurance_mother
rename v627 ideal_num_boys
rename v628 ideal_num_girls
rename v701 husband_edu 
rename v704 husband_occupation 
rename v716 occupation_mother 
rename v731 worked_last_12_months 
rename m5 months_breastfeeding
rename m15 place_of_delivery 

//dummies for education. 
tab education_mother, gen(mother_edu_)

rename v133 motheredusingleyears

//hh variables
rename v190 wealth_index
rename v025 residence
rename v136 num_hh_mem
rename v113 source_drinking_water 
rename v116 type_of_toilet 
rename v119 electricity_hh 
rename v130 religion 
rename v151 sex_hh_head 
rename v152 age_hh_head 
rename v161 type_of_cookingfuel
rename v021 psu

//child variabels 
rename b8 current_age_child 
rename b2 birth_year_child
rename b4 sex_child
replace sex_child = 0 if sex_child == 1 //all males are 0 
replace sex_child = 1 if sex_child == 2 //all females are 1. Order of running is important, or else all females become 1's who then become 0's 

rename hw70 zhfa_child 
replace zhfa_child = zhfa_child/100 

rename hw71 zwfa_child 	
replace zwfa_child = zwfa_child / 100 

rename hw2 weight_child 
replace weight_child = weight_child / 10

rename hw3 height_child 
replace height_child = height_child / 10

rename m19 birthweight_child 
replace birthweight_child = birthweight_child/1000

gen lbw = 1 if birthweight_child <= 2.5 & birthweight_child != . 
replace lbw = 0 if birthweight_child > 2.5 & birthweight_child != .

rename m19a birthweight_child_recallmethod 
gen bw_recall_written = 1 if birthweight_child_recallmethod == 1
replace bw_recall_written = 0 if birthweight_child_recallmethod == 2

rename bidx birthindex

gen stunted_child = .
replace stunted_child = 1 if zhfa_child <= - 2 & zhfa_child != . & zhfa_child <= 10
replace stunted_child = 0 if zhfa_child > - 2 & zhfa_child != . & zhfa_child <= 10

gen wasted_child = .
replace wasted_child = 1 if zwfa_child <= - 2 & zwfa_child != . & zwfa_child <= 10
replace wasted_child = 0 if zwfa_child > - 2 & zwfa_child != . & zwfa_child <= 10

gen bw_child_written = birthweight_child if birthweight_child_recallmethod == 1
gen bw_child_recall = birthweight_child if birthweight_child_recallmethod == 2

rename h10 ever_vaccinated_child 

//##############################################################################

//the oldest child has the highest birth index. Total number of children = birth index of first born. Hence, to get the first born, simply take birthindex == total children ever born. 
keep if birthindex == tot_children_ever_born

//use current age of respondent_current_age to get age in years. 
//suppose july 1 is cutoff for school. 

local birth_month_cutoff 12 //currently: December. Mostly is it july. 
forvalues year = 2000/2006{
	gen schage_`year'_jn1 = .
	replace schage_`year'_jn1 = `year' - birth_year_mother if birth_month_mother <= `birth_month_cutoff' //school age in 2000 for a mother is 2000 - birth year (say 1995), then school age 00' is 5. 
	replace schage_`year'_jn1 = `year' - birth_year_mother - 1 if birth_month_mother > `birth_month_cutoff' 
}

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
replace years_of_exposure = 11 - schage_2003_jn1 if statename == "uttarakhand" 
replace years_of_exposure = 11 - schage_2005_jn1 if statename == "west bengal" 

replace years_of_exposure = 5 if years_of_exposure != . & years_of_exposure >= 5

tab state if years_of_exposure == . 
drop if years_of_exposure == . //drops all states where years of exposure is not defined. 

gen early_implementer = . 
replace early_implementer = 1 if statename == "chhattisgarh" | statename == "dadra and nagar haveli" | statename == "daman and diu" | statename == "rajasthan" | statename == "sikkim" | statename == "andhra pradesh" | statename == "karnataka" | statename == "maharashtra" | statename == "meghalaya" | statename == "tripura" | statename == "uttarakhand"

replace early_implementer = 0 if early_implementer != 1 & years_of_exposure != . //when years_of_exposure == ., 

gen mdms_start_year = . 
replace mdms_start_year = 2003 if statename == "andhra pradesh" 
replace mdms_start_year = 2004 if statename == "arunachal pradesh" 
replace mdms_start_year = 2005 if statename == "assam"  
replace mdms_start_year = 2005 if statename == "bihar" 
replace mdms_start_year = 2002 if statename == "chhattisgarh" 
replace mdms_start_year = 2002 if statename == "dadra and nagar haveli" 
replace mdms_start_year = 2003 if statename == "daman and diu" 
replace mdms_start_year = 2004 if statename == "haryana"
replace mdms_start_year = 2004 if statename == "himachal pradesh"
replace mdms_start_year = 2005 if statename == "jammu and kashmir"
replace mdms_start_year = 2003 if statename == "karnataka"  
replace mdms_start_year = 2004 if statename == "madhya pradesh"  
replace mdms_start_year = 2003 if statename == "maharashtra"
replace mdms_start_year = 2004 if statename == "manipur"
replace mdms_start_year = 2006 if statename == "mizoram" 
replace mdms_start_year = 2003 if statename == "meghalaya"
replace mdms_start_year = 2004 if statename == "orissa" 
replace mdms_start_year = 2004 if statename == "punjab" 
replace mdms_start_year = 2002 if statename == "rajasthan"
replace mdms_start_year = 2002 if statename == "sikkim" 
replace mdms_start_year = 2003 if statename == "tripura"   
replace mdms_start_year = 2004 if statename == "uttar pradesh"
replace mdms_start_year = 2003 if statename == "uttarakhand" 
replace mdms_start_year = 2005 if statename == "west bengal" 
 
//avg zhfa by early implemetner over birth years of respondents. 
bysort early_implementer birth_year_mother: egen avg_zhfa_2015_birthyear = mean(zhfa_mother)
bysort early_implementer years_of_exposure: egen avg_zhfa_2015_expsoure = mean(zhfa_mother)

//conditions 
global varabsorb psu caste source_drinking_water type_of_toilet type_of_cookingfuel religion sex_hh_head age_hh_head health_insurance_mother ideal_num_boys ideal_num_girls months_breastfeeding place_of_delivery
global atleast_primry_edu education_mother >= 2 //2 is complete primary
global residence_condition residence == 2 //rural

//create service utilisation variables at the statelevel. 
bysort statename: egen famplan_state = mean(s365a) //is a 0/1 dummy for no/yes
bysort statename: egen immunize_state = mean(s365b) //is a 0/1 dummy for no/yes
bysort statename: egen antenatal_state = mean(s365c) //is a 0/1 dummy for no/yes
bysort statename: egen deliverycare_state = mean(s365d) //is a 0/1 dummy for no/yes
bysort statename: egen postnatalcare_state = mean(s365e) //is a 0/1 dummy for no/yes
bysort statename: egen diseaseprevention_state = mean(s365f) //is a 0/1 dummy for no/yes
bysort statename: egen selfmedicaltreat_state = mean(s365g) //is a 0/1 dummy for no/yes
bysort statename: egen growthmonitoring_state = mean(s365j) //is a 0/1 dummy for no/yes
bysort statename: egen healthcheckup_state = mean(s365k) //is a 0/1 dummy for no/yes

sum famplan_state immunize_state antenatal_state deliverycare_state postnatalcare_state diseaseprevention_state selfmedicaltreat_state growthmonitoring_state healthcheckup_state

//##############################################################################

//chnage directory to save output files there. 
cd "C:\Users\savas\Documents\Ashoka\Courses\Social Policy in India\Social Policy Course Research\Output Files"

//##############################################################################

//summary table for children. 

preserve 
eststo clear
gen early_implemnt_inv_forttest = -1 * early_implementer
keep if birthweight_child <= 7.5
keep if weight_child <= 100 //unit: kg 
keep if height_child <= 250 //unit: cm 
keep if zwfa_child <= 10 //unit: std dev 
keep if zhfa_child <= 10 
keep if $residence_condition //only rural
eststo: estpost sum years_of_exposure sex_child current_age_child birthweight_child weight_child height_child zwfa_child wasted_child zhfa_child stunted_child wealth_index num_hh_mem if early_implementer == 1 //early implementer
eststo: estpost sum years_of_exposure  sex_child current_age_child birthweight_child weight_child height_child zwfa_child wasted_child zhfa_child stunted_child wealth_index num_hh_mem if early_implementer == 0 //late implementer 
eststo: estpost ttest years_of_exposure  sex_child current_age_child birthweight_child weight_child height_child zwfa_child wasted_child zhfa_child stunted_child wealth_index num_hh_mem, by(early_implemnt_inv_forttest)
esttab using "sumtable_child.tex",  cells("mean(pattern(1 1 0) fmt(3)) sd(pattern(1 1 0) fmt(3)) b(star pattern(0 0 1) fmt(3))") nolabel unstack nonum nogaps collabels("Mean" "SD" "Difference") mtitles("Early Implementer" "Late Implementer" "") rename(years_of_exposure "MDMS Exposure (Years)" sex_child "Proportion Female" current_age_child "Current Age (Years)" birth_year_child "Birth Year" birthweight_child "Birthweight (kg)" weight_child "Current Weight (kg)" height_child "Current Height (cm)" zwfa_child "Z-score Weight for Age" zhfa_child "Z-score Height for Age" wasted_child "Proportion Wasted"  stunted_child "Proportion Stunted" wealth_index "Wealth Index" num_hh_mem "Number of HH Members") title("Summary Statistics of Children from Births Recode\label{sumstats-children}") addnotes("Sample Restricted to Rural Children.") replace
restore

//##############################################################################

//Regressions 

//for mother regressions, refer to nfhs4 Indiviudal Recode. This is because we want the sample of all women exposed to the MDMS, not just mothers. When we analyse children, then of course we will look at only mothers. 

//mother regressions 
//height of mother 
eststo m1: reghdfe height_mother years_of_exposure i.wealth_index i.caste if years_of_exposure >= 0 & years_of_exposure != . & height_mother <= 200 & caste != 8 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother psu religion) 
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local religion_FE "Yes"


//zhfa mother 
eststo m2: reghdfe zhfa_mother years_of_exposure i.wealth_index i.caste if years_of_exposure >= 0 & years_of_exposure != . & zhfa_mother <= 10 & caste != 8 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother psu) 
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local religion_FE "Yes"

//weight of mother
eststo m3: reghdfe weight_mother years_of_exposure i.wealth_index i.caste if years_of_exposure >= 0 & years_of_exposure != . & weight_mother <= 150 & caste != 8 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother psu religion) 
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local religion_FE "Yes"

//asthama mother
eststo m4: reghdfe asthama_mother years_of_exposure i.wealth_index i.caste if years_of_exposure >= 0 & years_of_exposure != . & asthama_mother <= 1 & caste != 8 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother psu religion)
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local religion_FE "Yes"

//heart disease mother 
eststo m5: reghdfe heart_disease_mohter years_of_exposure i.wealth_index i.caste if years_of_exposure >= 0 & years_of_exposure != . & heart_disease_mohter <= 1 & caste != 8 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother psu religion)
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local religion_FE "Yes"

//hemoglobin_mother 

eststo m6: reghdfe hemoglobin_mother years_of_exposure i.wealth_index i.caste if years_of_exposure >= 0 & years_of_exposure != . & hemoglobin_mother <= 30 & caste != 8 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother psu religion) 
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local religion_FE "Yes"

preserve 
keep if years_of_exposure >= 0 & years_of_exposure != .
reghdfe hemoglobin_mother i.years_of_exposure if years_of_exposure >= 0 & years_of_exposure != . & hemoglobin_mother <= 30 & caste != 8 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother psu wealth_index caste $varabsorb) 
restore 

coefplot, vertical drop(_cons) yline(0) xlabel(, angle(vertical)) xtitle("Years of Exposure") ytitle("Hemoglobin Improvement") title("Hemoglobin Improvement vs MDMS Exposure") coeflabels(1.years_of_exposure = "One" 2.years_of_exposure = "Two" 3.years_of_exposure = "Three" 4.years_of_exposure = "Four" 5.years_of_exposure = "Five") yscale(range(-0.02 0.2)) 

graph export "hemoglobin_mothers_BR.png", as(png) name("Graph") replace

//coefplot, vertical drop(_cons) yline(0) xlabel(, angle(vertical)) xtitle("Years of Exposure") ytitle("Hemoglobin Improvement of Mother (g/dl)") title("Hemoglobin Improvement by Years of Exposure to MDMS") coeflabels(1.years_of_exposure = "One" 2.years_of_exposure = "Two" 3.years_of_exposure = "Three" 4.years_of_exposure = "Four" 5.years_of_exposure = "Five") yscale(range(-0.02 0.2)) 

cd "C:\Users\savas\Documents\Ashoka\Courses\Social Policy in India\Social Policy Course Research\Output Files"
esttab m1 m2 m3 m4 m5 m6 using "mothers_BR_regs.tex",  refcat(2.wealth_index "\textbf{Wealth Quintiles}" 2.caste "\textbf{Caste}", nolabel) varlabel(years_of_exposure "Years of Exposure" _cons "Intercept" 1.wealth_index "Poorest" 2.wealth_index "Poorer" 3.wealth_index "Middle" 4.wealth_index "Richer" 5.wealth_index "Richest" 1.caste "SC" 2.caste "ST" 3.caste "OBC" 4.caste "General") mtitles("\shortstack{Height\\(cm)}" "ZHFA" "\shortstack{Weight\\(kg)}" "Asthama" "Heart Disease" "\shortstack{Hemoglobin\\(g/dl)}") r2 obslast noomitted nobase se star(* 0.10 ** 0.05 *** 0.01) s(birth_year_mother_FE geograhical_FE religion_FE N r2, label("Mother Birth Year FE" "Geographical FE" "Religion FE" "Observations" "$ R^2$")) addnotes("Sample restricted to rural women who completed primary education.") replace

esttab m1 m2 m3 m4 m5 m6 using "prst_mothers_BR_regs.tex",  keep(years_of_exposure 2.wealth_index 3.wealth_index 4.wealth_index 5.wealth_index) refcat(2.wealth_index "\textbf{Wealth Quintiles}", nolabel) varlabel(years_of_exposure "Years of Exposure" _cons "Intercept" 1.wealth_index "Poorest" 2.wealth_index "Poorer" 3.wealth_index "Middle" 4.wealth_index "Richer" 5.wealth_index "Richest" 1.caste "SC" 2.caste "ST" 3.caste "OBC" 4.caste "General") mtitles("\shortstack{Height\\(cm)}" "ZHFA" "\shortstack{Weight\\(kg)}" "Asthama" "Heart Disease" "\shortstack{Hemoglobin\\(g/dl)}") r2 obslast noomitted nobase se star(* 0.10 ** 0.05 *** 0.01) s(birth_year_mother_FE geograhical_FE religion_FE N r2, label("Mother Birth Year FE" "Geographical FE" "Religion FE" "Observations" "$ R^2$")) addnotes("Sample restricted to rural women who completed primary education.") replace


//education of mother: impact of differntial exposure. 


eststo clear
forvalues i = 1/6{
	eststo m`i': reghdfe mother_edu_`i' years_of_exposure i.wealth_index i.caste if years_of_exposure >= 0 & years_of_exposure != . & caste != 8  & $residence_condition, absorb(birth_year_mother psu religion) 
	estadd local birth_year_mother_FE "Yes"
	estadd local geograhical_FE "PSU"
	estadd local religion_FE "Yes"
}

eststo m7: reghdfe motheredusingle years years_of_exposure i.wealth_index i.caste if years_of_exposure >= 0 & years_of_exposure != . & caste != 8 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother psu religion) 
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local religion_FE "Yes"

cd "C:\Users\savas\Documents\Ashoka\Courses\Social Policy in India\Social Policy Course Research\Output Files"
esttab m1 m2 m3 m4 m5 m6 m7 using "mothers_edu_regs.tex",  refcat(2.wealth_index "\textbf{Wealth Quintiles}" 2.caste "\textbf{Caste}", nolabel) varlabel(years_of_exposure "Years of Exposure" _cons "Intercept" 1.wealth_index "Poorest" 2.wealth_index "Poorer" 3.wealth_index "Middle" 4.wealth_index "Richer" 5.wealth_index "Richest" 1.caste "SC" 2.caste "ST" 3.caste "OBC" 4.caste "General") mtitles("\shortstack{No\\Education}" "\shortstack{Incomplete\\Primary}" "\shortstack{Complete\\Primary}" "\shortstack{Inomplete\\Seconday}" "\shortstack{Complete\\Seconday}" "Higher" "\shortstack{Total Years\\of Education}") r2 obslast noomitted nobase se star(* 0.10 ** 0.05 *** 0.01) s(birth_year_mother_FE geograhical_FE religion_FE N r2, label("Mother Birth Year FE" "Geographical FE" "Religion FE" "Observations" "$ R^2$")) addnotes("Sample restricted to rural women only.") replace

//child regressions 

//ZHFA firstborn
eststo a1: reghdfe zhfa_child years_of_exposure ib1.sex_child i.wealth_index if years_of_exposure >= 0 & zhfa_child<= 10 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother birth_year_child current_age_child $varabsorb) baselevels
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local other_FE "Yes"

//stunting firstborn 
eststo a2: reghdfe stunted_child years_of_exposure ib1.sex_child i.wealth_index if years_of_exposure >= 0 & zhfa_child<= 10 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother birth_year_child current_age_child $varabsorb) baselevels
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local other_FE "Yes"

//ZWFA firstborn 
eststo a3: reghdfe zwfa_child years_of_exposure ib1.sex_child i.wealth_index if years_of_exposure >= 0 & zwfa_child <= 10 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother birth_year_child current_age_child $varabsorb) baselevels
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local other_FE "Yes"

//wasted firstborn 
eststo a4: reghdfe wasted_child years_of_exposure ib1.sex_child i.wealth_index if years_of_exposure >= 0 & zwfa_child <= 10 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother birth_year_child $varabsorb) baselevels
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local other_FE "Yes"

//child birthweight 
eststo a5: reghdfe birthweight_child years_of_exposure ib1.sex_child i.wealth_index if years_of_exposure >= 0 & birthweight_child <= 7 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother birth_year_child $varabsorb antenatal_state deliverycare_state postnatalcare_state education_mother) baselevels
estadd local birth_year_mother_FE "Yes"
estadd local sample_restriction "Both"
estadd local geograhical_FE "PSU"
estadd local other_FE "Yes"

preserve 
keep if years_of_exposure >= 0 & years_of_exposure != .
eststo a6: reghdfe birthweight_child i.years_of_exposure if years_of_exposure >= 0 & birthweight_child <= 7 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother birth_year_child sex_child wealth_index current_age_child education_mother $varabsorb) level (90) baselevels
estadd local birth_year_mother_FE "Yes"
estadd local sample_restriction "Both"
estadd local geograhical_FE "PSU"
estadd local other_FE "Yes"
restore 

//coefplot, vertical drop(_cons) yline(0) xlabel(, angle(vertical)) xtitle("Years of Exposure") ytitle("Birthweight Improvement (kg)") title("Birthweight Improvement by Years of Exposure to MDMS") coeflabels(1.years_of_exposure = "One" 2.years_of_exposure = "Two" 3.years_of_exposure = "Three" 4.years_of_exposure = "Four" 5.years_of_exposure = "Five") yscale(range(-0.02 0.2)) 

//child birthweight if recall is written
eststo a7: reghdfe birthweight_child years_of_exposure ib1.sex_child i.wealth_index if years_of_exposure >= 0 & birthweight_child <= 7 & birthweight_child_recallmethod == 1 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother birth_year_child current_age_child education_mother  $varabsorb) baselevels
estadd local birth_year_mother_FE "Yes"
estadd local sample_restriction "Written"
estadd local geograhical_FE "PSU"
estadd local other_FE "Yes"

//child birthweight if recall is mothers recall. 
eststo a8: reghdfe birthweight_child years_of_exposure ib1.sex_child i.wealth_index if years_of_exposure >= 0 & birthweight_child <= 7 & birthweight_child_recallmethod == 2 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother birth_year_child current_age_child education_mother $varabsorb) baselevels
estadd local birth_year_mother_FE "Yes"
estadd local sample_restriction "Mental"
estadd local geograhical_FE "PSU"
estadd local other_FE "Yes"

//check if written and mothers recall have similar distributions. 
preserve 
keep if birthweight_child <= 7
twoway kdensity bw_child_written || kdensity bw_child_recall, xtitle("Birthweight (kg)") ytitle("Density") title("Density Plot of Birthweight by Recall Type")
graph export "recall_density_difference.png", as(png) name("Graph") replace

//get cdf of both distributions. 
cumul bw_child_written, gen(cumul_bw_child_written)
sort cumul_bw_child_written
line cumul_bw_child_written bw_child_written

eststo a9: reghdfe height_child years_of_exposure ib1.sex_child i.wealth_index if years_of_exposure >= 0 & height_child <= 200 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother birth_year_child current_age_child $varabsorb) baselevels
estadd local birth_year_mother_FE "Yes"
estadd local geograhical_FE "PSU"
estadd local other_FE "Yes"

//recall response bias: "written recall"
preserve 
keep if years_of_exposure >= 0 & years_of_exposure != .
eststo a10: reghdfe birthweight_child i.years_of_exposure if years_of_exposure >= 0 & birthweight_child <= 7 & birthweight_child_recallmethod == 1 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother birth_year_child sex_child wealth_index current_age_child education_mother $varabsorb) baselevels
estadd local birth_year_mother_FE "Yes"
estadd local sample_restriction "Written"
estadd local geograhical_FE "PSU"
estadd local other_FE "Yes"
restore 

//recall response bias: "mothers recall"
preserve 
keep if years_of_exposure >= 0 & years_of_exposure != .
eststo a11: reghdfe birthweight_child i.years_of_exposure if years_of_exposure >= 0 & birthweight_child <= 7 & birthweight_child_recallmethod == 2 & $atleast_primry_edu & $residence_condition, absorb(birth_year_mother birth_year_child sex_child wealth_index current_age_child education_mother  $varabsorb) baselevels
estadd local birth_year_mother_FE "Yes"
estadd local sample_restriction "Mental"
estadd local geograhical_FE "PSU"
estadd local other_FE "Yes"
restore 

//check if recall varies by state 
reg bw_recall_written i.mdms_start_year, baselevels


//Without Birthweight 
cd "C:\Users\savas\Documents\Ashoka\Courses\Social Policy in India\Social Policy Course Research\Output Files"
esttab a1 a2 a3 a4 a9 using "children_BR_woBW_regs.tex", refcat(2.wealth_index "\textbf{Wealth Quintiles}" 0.sex_child "\textbf{Sex of Child}", nolabel) varlabel(years_of_exposure "Years of Exposure" _cons "Intercept" 1.wealth_index "Poorest" 2.wealth_index "Poorer" 3.wealth_index "Middle" 4.wealth_index "Richer" 5.wealth_index "Richest" 1.sex_child "Male" 0.sex_child "Female") mtitles("ZHFA" "Stunted" "ZWFA" "Wasted" "Height (cm)") r2 obslast noomitted nobase se star(* 0.10 ** 0.05 *** 0.01) s(birth_year_mother_FE geograhical_FE other_FE N r2, label("Mother Birth Year FE" "Geographical FE" "Other FE" "Observations" "$ R^2$")) addnotes("Sample restricted to rural women who completed primary education. Other Fixed effects includes fixed effects of caste, months breastfed, place of delivery, source of drinking water, type of toilets, cooking fuel, religion, sex and age of household head, mother possesing health insurance, ideal number of boys and girls" ) replace

//Without birthweight - for presentation - same table. 


//With Birthweight 
cd "C:\Users\savas\Documents\Ashoka\Courses\Social Policy in India\Social Policy Course Research\Output Files"
esttab a5 a7 a8 a6 a10 a11 using "children_BR_w_BW_regs.tex", refcat(2.wealth_index "\textbf{Wealth Quintiles}" 0.sex_child "\textbf{Sex of Child}" 1.years_of_exposure "\textbf{Years of Exposure}", nolabel) varlabel(years_of_exposure "Years of Exposure" _cons "Intercept" 1.wealth_index "Poorest" 2.wealth_index "Poorer" 3.wealth_index "Middle" 4.wealth_index "Richer" 5.wealth_index "Richest" 1.sex_child "Male" 0.sex_child "Female" 1.years_of_exposure "One" 2.years_of_exposure "Two" 3.years_of_exposure "Three" 4.years_of_exposure "Four" 5.years_of_exposure "Five") mtitles("Birthweight (kg)" "Birthweight (kg)" "Birthweight (kg)" "Birthweight (kg)" "Birthweight (kg)" "Birthweight (kg)") r2 obslast noomitted nobase se star(* 0.10 ** 0.05 *** 0.01) s(birth_year_mother_FE sample_restriction geograhical_FE other_FE N r2, label("Mother Birth Year FE" "Recall Type" "Geographical FE" "Other FE" "Observations" "$ R^2$")) addnotes("Sample restricted to rural women who completed primary education. Other Fixed effects includes fixed effects like child birth year and age fixed effects, caste, months breastfed, place of delivery, source of drinking water, type of toilets, cooking fuel, religion, sex and age of household head, mother possesing health insurance, ideal number of boys and girls fixed effects." ) replace

//with birtweight, for presentation. 
esttab a5 a7 a8 a6 a10 a11 using "child_pres_BR_w_BW_regs.tex", keep(years_of_exposure 1.years_of_exposure 2.years_of_exposure 3.years_of_exposure 4.years_of_exposure 5.years_of_exposure) refcat(1.years_of_exposure "\textbf{Years of Exposure}", nolabel) varlabel(years_of_exposure "Years of Exposure" _cons "Intercept" 1.wealth_index "Poorest" 2.wealth_index "Poorer" 3.wealth_index "Middle" 4.wealth_index "Richer" 5.wealth_index "Richest" 1.sex_child "Male" 0.sex_child "Female" 1.years_of_exposure "One" 2.years_of_exposure "Two" 3.years_of_exposure "Three" 4.years_of_exposure "Four" 5.years_of_exposure "Five") mtitles("Birthweight (kg)" "Birthweight (kg)" "Birthweight (kg)" "Birthweight (kg)" "Birthweight (kg)" "Birthweight (kg)") r2 obslast noomitted nobase se star(* 0.10 ** 0.05 *** 0.01) s(birth_year_mother_FE sample_restriction geograhical_FE other_FE N r2, label("Mother Birth Year FE" "Recall Type" "Geographical FE" "Other FE" "Observations" "$ R^2$")) addnotes("Sample restricted to rural women who completed primary education. Other Fixed effects includes fixed effects like child birth year and age fixed effects, caste, months breastfed, place of delivery, source of drinking water, type of toilets, cooking fuel, religion, sex and age of household head, mother possesing health insurance, ideal number of boys and girls fixed effects." ) replace

//checking if service delivery changes by state. 
preserve 
duplicates drop statename, force
local serviceutilisation growthmonitoring_state immunize_state antenatal_state postnatalcare_state deliverycare_state diseaseprevention_state selfmedicaltreat_state healthcheckup_state famplan_state
local i 1
foreach service of local serviceutilisation{
	eststo t`i': reg `service' mdms_start_year
	local ++i
}

cd "C:\Users\savas\Documents\Ashoka\Courses\Social Policy in India\Social Policy Course Research\Output Files"
esttab t1 t2 t3 t4 t5 using "serviceutilisation_1.tex", mtitles("\shortstack{Growth\\Monitoring}" "\shortstack{Immunisation}" "\shortstack{Antental\\Care}" "\shortstack{Postnatal\\Care}" "\shortstack{Delivery\\Care}") varlabel(mdms_start_year "MDMS Start Year") replace

esttab t6 t7 t8 t9 using "serviceutilisation_2.tex", mtitles("\shortstack{Disease\\Prevention}" "\shortstack{Medical\\Treatment}" "\shortstack{Health\\Checkup}" "\shortstack{Family\\Planning}")varlabel(mdms_start_year "MDMS Start Year") replace

//recall method analysis 
eststo clear
eststo a1: reg bw_recall_written mdms_start_year
estadd local FE "No"

eststo a2: reg bw_recall_written mdms_start_year i.wealth_index
estadd local FE "No"

eststo a3: reg bw_recall_written mdms_start_year i.wealth_index ib1.sex_child
estadd local FE "No"

eststo a4: reg bw_recall_written mdms_start_year i.wealth_index ib1.sex_child i.caste if caste <= 4
estadd local FE "No"

eststo a5: reghdfe bw_recall_written mdms_start_year i.wealth_index ib1.sex_child i.caste if caste <= 4, absorb(source_drinking_water type_of_toilet type_of_cookingfuel religion sex_hh_head age_hh_head health_insurance_mother ideal_num_boys ideal_num_girls months_breastfeeding place_of_delivery)
estadd local FE "Yes"

cd "C:\Users\savas\Documents\Ashoka\Courses\Social Policy in India\Social Policy Course Research\Output Files"
esttab a1 a2 a3 a4 a5 using "recall_determinants.tex", refcat(2.wealth_index "\textbf{Wealth Quintiles}" 0.sex_child "\textbf{Sex of Child}" 1.caste "Caste", nolabel) varlabel(mdms_start_year "MDMS Start Year" 1.wealth_index "Poorest" 2.wealth_index "Poorer" 3.wealth_index "Middle" 4.wealth_index "Richer" 5.wealth_index "Richest" 1.caste "SC" 2.caste "ST" 3.caste "OBC" 4.caste "General" _cons "Intercept" 0.sex_child "Female") mtitles("\shortstack{Written Recall\\(0/1)}" "\shortstack{Written Recall\\(0/1)}" "\shortstack{Written Recall\\(0/1)}" "\shortstack{Written Recall\\(0/1)}") r2 obslast noomitted nobase se star(* 0.10 ** 0.05 *** 0.01) s(FE N r2, label("Other FE" "Observations" "$ R^2$")) addnotes("Sample restricted to rural women who completed primary education. Other Fixed effects includes fixed effects like child birth year and age fixed effects, caste, months breastfed, place of delivery, source of drinking water, type of toilets, cooking fuel, religion, sex and age of household head, mother possesing health insurance, ideal number of boys and girls fixed effects." ) replace

reghdfe birthweight_child bw_recall_written i.wealth_index i.caste, absorb(psu source_drinking_water type_of_toilet type_of_cookingfuel religion sex_hh_head age_hh_head health_insurance_mother ideal_num_boys ideal_num_girls months_breastfeeding place_of_delivery)




//check for pre-trends: 

//for mothers born before 1992 - that is, all mothers in all states must have turned 10 by 2002
sort birth_year_mother	
twoway (line avg_zhfa_2015_birthyear birth_year_mother if early_implementer == 1 & birth_year_mother <= 1992) (line avg_zhfa_2015_birthyear birth_year_mother if early_implementer == 0 & birth_year_mother <= 1992) (lfit avg_zhfa_2015_birthyear birth_year_mother if early_implementer == 1 & birth_year_mother <= 1992) (lfit avg_zhfa_2015_birthyear birth_year_mother if early_implementer == 0 & birth_year_mother <= 1992) , legend(label (1 "early implementer states") label (2 "late implementer states") label (3 "linear trend: early states") label (4 "linear trend: late states")) ytitle("ZHFA") title("ZHFA vs Mother Year of Birth")
graph export "pre-trends_birthyear_mother.png", as(png) name("Graph") replace















