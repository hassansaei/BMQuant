## BMQuant - A FIJI Macro to Quantify Basement Membrane Protein

The basement membrane quantification (BMQuant) is a FIJI macro and a framework for basement membrane protein quantification in organoid models. 
As we have developed an X-linked Alport syndrome (XLAS) kidney organoid models from male iPSCs. With developing this macro we aimed to quantify collagen a5(IV) mean intensity in the basement membranes of our model after antisense oligonucleotide treatment. 

---

This macro takes raw data in .czi format, regeans of interest (ROIs), and ilastk project file as input.
We can assign the thickness of the border indicating the basement membranes in our objects (glomeruli or tubule). 
It calculates border area and mean fluorscent intensity of the channel of interest and generate a csv file with the values for each object.

---

