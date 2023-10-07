cd "C:/Users/savas/Documents/Ashoka/Courses/Social Policy in India/Social Policy Course Research/Data"
use "NFHS4 Individual Recode.dta", clear

preserve 
keep v010 v009 bord_01-bord_20 hw70_1-hw70_6 hw71_1-hw71_6 b4_01 hw2_1 hw5_1 hw8_1 hw71_1 v024 v101 b2_01 m1_1 hep0_1 b0_01 b5_01 b8_01 m1_1 m4_1 m10_1 m15_1 v190 s723b v481d s723bb v042 v452c v453 v455 hw53_1 hw53_2 hw53_3 hw53_4 hw53_5 hw53_6 hw56_1 hw56_2 hw56_3 hw56_4 hw56_5 hw56_6 v025 s723a v440 v149 b2_01-b2_09 b8_01-b8_09 b4_01- b4_06 v012 v136 v201 v454 s116 v007 v006 v438-v444a s723d s723c v437 sdistri v021
save nfhs4_relevant_vars, replace


cd "C:/Users/savas/Documents/Ashoka/Courses/Social Policy in India/Social Policy Course Research/Data"
use "NFHS5 Individual Recode.dta", clear


