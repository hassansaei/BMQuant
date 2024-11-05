## BMQuant - A FIJI Macro to Quantify Basement Membrane Protein

BMQuant is a FIJI macro and a framework for basement membrane protein quantification in organoid samples. 

Three steps must have been taken to use this macro:

- **Object Segmentation**: We use QuPath to annotate and segment our objects in which we want to perform the quantification (Gloms and tubules in our example). 
- **Export annotations**: We export the region of interests (ROIs) using the provided script.
- **Pixel classification**: iLastik software is used to perform pixel classification on the channel of interest using machine learning model inplemented in ilastik.
- **Measurement**: We used teh Fiji macro to measure the mean fluorscent intensity in the basement membrane and inside our objects with calculating the area

As we have developed an X-linked Alport syndrome (XLAS) kidney organoid models from male iPSCs. With developing this macro we aimed to quantify collagen a5(IV) mean intensity in the basement membranes of our model after antisense oligonucleotide treatment. 

---

This macro takes raw data in .czi format, regeans of interest (ROIs), and ilastk project file as input.
We can assign the thickness of the border indicating the basement membranes in our objects (glomeruli or tubule). 
It calculates border area and mean fluorscent intensity of the channel of interest and generate a csv file with the values for each object.

---