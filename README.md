# ErwinJr_MATLAB
ErwinJr_MATALB is an open source design and simulation of multiple quantum well heterostructure devices. 
The program calculates the confined energy levels and the spacial distribution of the electron probability 
wave in the conduction band. The Schrodinger equation is solved based on the semiclassical approach. 
That is, the entire heterostructure is treated as a single quantum mechanical system with a well-defined Hamiltonian. 
The eigenstates are stationary without considering the coherent time evolution. The effective mass of the 
electrons is energy and spacial dependent based on the kp theory and the heterostructure of the material system. 
The lifetime of the electron on a energy level is based on the logitudinal optical (LO) phonon and interfacr roughness 
(IFR) scatterings. It is calculated using Fermi's golden rule and Frolich Hamiltonian. 


## Energy Levels and Probability Waves
### Pre-calculation:
None
### Input:
Temperature, material system, layer structure, bias, number of period, strain 
### Output:
All the confined energy levels, the spacial distribution of the prbability wave


## Lifetimes, Dipole Moment and FoM
### Pre-calculation:
Energy levels and probability waves
### Input:
Two selected confined energy levels, temperature
### Output:
LO phonon scattering lifetimes, IFR scattering lifetimes, Optical dipole moment and FoM between the selected two energy levels


## Steady State Electron Distribution
### Pre-calculation:
Energy levels and probability waves
### Input:
All the confined energy levels in the single target period, all the confined energy levels in the consecutive period, 
doping density, doping area, upper and lower laser levels, temperature
### Output:
Initial electron distribution, steady state electron distribution on each of the confined energy level, 
time evolution of the electron distribution, broadening, electroluminescence speactra


## Scattering Current
### Pre-calculation:
Steady state electron distribution
### Input:
All the energy levels in two consecutive period, temperature
### Output:
Scattering current density


## Stimulated Interaction
### Pre-calculation:
Energy levels and probability wave
### Input:
Selected interactive optical levels, spectra-overlap ratio, all the confined energy levels in the single target period, all the confined energy levels in the consecutive period, doping density, doping area, upper and lower laser levels, temperature
### Output:
Time evolution of the photon flux, time evolution of the electron distribution, steady state electron distribution
