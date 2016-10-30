A panopoly of other tools are available, including a tools to [automatically generate the input file](Building_FP_input_file.html), and tools to do a variety of other kinds of calculations. You can see many of them by invoking fp/testing/test.fp: this script serves both to test that the code works as it should, and to showcase program features. To see the test cases on offer with a brief description of their purpose, run from the top-level directory:

        fp/test/test.fp --list
        
You can generate and plot the energy bands using **lmf**. It proceeds in the same way as in the [ASA tutorial](ASAtutorial.html#bands). Generate the band file this way:

        cp startup/syml.fcc ./syml.al
        lmf al --band:fn=syml 

Plot the bands as in the ASA tutorial, or look at this [this tutorial](generating-energy-bands.html).

The generation of the core-level spectroscopy, Mulliken analysis or density-of-states is done first by invoking **lmf** with the appropriate [command-line switch](fp.html#section3), followed by **lmdos**. The **lmdos** step is illustrated (including a way to plot results) in the [ASA tutorial](ASAtutorial.html#dos).

To compute the density of states, see [this tutorial](generating-density-of-states.html). To compute core-level EELS spectra or Mulliken analysis in Fe, try running

        fp/test/test.fp fe 2 

To compute total or partial DOS in hcp Co, try running

        fp/test/test.fp co 2 

[Another tutorial](siged-tutorial.html#AsAntisiteLatticeRelaxation) goes through a lattice relaxation of an As antisite defect in the LDA. It also shows how quasiparticle self-consistent _GW_ self-energies can be incorporated into **lmf** to obtain a quasiparticle description of the defect level. This tutorial also shows how to use **lmf** to calculate the [spin orbit coupling and magnetic anisotropy](siged-tutorial.html#SOcoupling) in Fe. Quasiparticle self-consistent _GW_ self-energies can be incorporated there as well. While QS_GW_ significantly improves on the LDA band structure, it is not yet known whether they improve on the LDA's prediction of the anisotropy.
