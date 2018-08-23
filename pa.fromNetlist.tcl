
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name ARQ_TP1_ALU -dir "C:/Users/Guille/ARQ_TP1_ALU/planAhead_run_2" -part xc3s100ecp132-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/Guille/ARQ_TP1_ALU/main.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/Guille/ARQ_TP1_ALU} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "main.ucf" [current_fileset -constrset]
add_files [list {main.ucf}] -fileset [get_property constrset [current_run]]
link_design
