## BMQuant - A FIJI Macro to Quantify Basement Membrane Protein

BMQuant is a FIJI macro and a framework for basement membrane protein quantification in organoid samples. 

Three steps must have been taken to use this macro:

- **Object Segmentation**: We use QuPath to annotate and segment our objects in which we want to perform the quantification (Gloms and tubules in our example). 
- **Export annotations**: We export the region of interests (ROIs) using the provided script.
- **Pixel classification**: iLastik software is used to perform pixel classification on the channel of interest using machine learning model inplemented in ilastik.
- **Measurement**: We used teh Fiji macro to measure the mean fluorscent intensity in the basement membrane and inside our objects with calculating the area

As we have developed an X-linked Alport syndrome (XLAS) kidney organoid models from male iPSCs. With developing this macro we aimed to quantify collagen a5(IV) mean intensity in the basement membranes of our model after antisense oligonucleotide treatment. 

## Usage

### Getting Started

- **Install QuPath software**: [Download QuPath](https://qupath.github.io/) for object annotation and ROI extraction (available for macOS, windows and linux OS)

- **Install FIJI**: [Download FIJI](https://imagej.net/software/fiji/downloads) which is a powerful and free image analysis tool.
- **Install iLastik software**: [Download iLastik](https://www.ilastik.org/download) for pixel classification

---

This macro takes raw data in .czi format, regeans of interest (ROIs), and ilastk project file as input.
We can assign the thickness of the border indicating the basement membranes in our objects (glomeruli or tubule). 
It calculates border area and mean fluorscent intensity of the channel of interest and generate a csv file with the values for each object.

---

## 📃 License

This pipeline is distributed under the MIT license. You can review the full license agreement at the license tab. 

For non-commercial use, this product is available for free.

---

## 🗨️ Contacts

This macro is designed in collaboration with Nicolas Gaudin. For more information and help you can wite to:

Nicolas Gaudin: nicolas.gaudin@inserm.fr
Hassan Saei: hassan.saeiahan@gmail.com

---

## 🗨️ Citations

If you used BMQuant in your project, please cite following papers:

1. For QuPath: Bankhead, P., Loughrey, M.B., Fernández, J.A. et al. QuPath: Open source software for digital pathology image analysis. Sci Rep 7, 16878 (2017). https://doi.org/10.1038/s41598-017-17204-5
2. For sam-api: Training deep learning models for cell image segmentation with sparse annotations Ko Sugawara bioRxiv 2023.06.13.544786; doi: https://doi.org/10.1101/2023.06.13.544786
3. For SAM: Chaoning Zhang et al. Faster Segment Anything: Towards Lightweight SAM for Mobile Applications.
4. For ilastik: Berg, S., Kutra, D., Kroeger, T. et al. ilastik: interactive machine learning for (bio)image analysis. Nat Methods 16, 1226–1232 (2019). https://doi.org/10.1038/s41592-019-0582-9
5. For FIJI: Schindelin, J., Arganda-Carreras, I., Frise, E. et al. Fiji: an open-source platform for biological-image analysis. Nat Methods 9, 676–682 (2012). https://doi.org/10.1038/nmeth.2019

---