# LAMMPS input script for melting point of 3d FCC Cu
# Volume--Tempearature relation

# problem setup


units		metal
boundary	p p p
atom_style	atomic
timestep	0.001

lattice         fcc 4.032
region          box block 0 6 0 6 0 6
create_box      1 box
create_atoms    1 box
 
pair_style      eam/alloy
pair_coeff      * * ../AlLEA.eam.alloy Al

# vars for V-T relation
#initial Temp and velocity is 10K, initial Pressure is 1
variable	step equal step
variable	time equal step*dt
variable	temp equal temp
variable	vol equal vol
variable	Et equal etotal
variable	press equal press*0.1 # in[Mpa] unit for pressure

variable	Tstart equal 10 # start temperature 
variable        Tdamp equal 8000*dt
variable	Pdamp equal 100
variable	Tstop equal 1500 # stop temperature
velocity        all create ${Tstart} 1234567

compute		pea all pe/atom
compute		kea all ke/atom

thermo          1000
thermo_style	custom step temp vol v_Et pe ke press

 
# equilibration run
dump            1 all custom 10000 rAl*.xyz id type x y z c_pea c_kea
fix		1 all npt temp ${Tstart} ${Tstart} ${Tdamp} iso 0 0 ${Pdamp} 
run	        10000
unfix		1
undump		1

# Heating from initial 10K to 1500K
reset_timestep  0
#compute		csp all centro/atom fcc
#compute		rdf all rdf 100
#fix		rdf all ave/time 100 10 1000 c_rdf[*]  &
#		ave running file AlMelt.rdf mode vector
dump		1 all custom 10000 vt*.xyz id type x y z c_pea c_kea #c_csp
fix             print all print 5000 "${step} ${temp} ${vol} ${Et} ${press}" file VT2.dat
fix		1 all npt temp ${Tstart} ${Tstop} ${Tdamp} iso 0 0 ${Pdamp} 

run	        400000

