# Face Detection using HoG
### HTML introduction and evaluation
You can have a look at the index.html in the html folder
### HKUST COMP5421 Project2
[Project Page](https://course.cs.ust.hk/comp5421/Password_Only/projects/faces/index.html) (You may need a HKUST CSD to login to the page)  
### Project Description 
The sliding window model is conceptually simple: independently classify all image patches as being object or non-object. Sliding window classification is the dominant paradigm in object detection and for one object category in particular -- faces -- it is one of the most noticeable successes of computer vision.  
  
For this project, we have implemented the simpler (but still very effective!) sliding window detector of [Dalal and Triggs 2005](https://lear.inrialpes.fr/people/triggs/pubs/Dalal-cvpr05.pdf). Dalal-Triggs focuses on representation more than learning and introduces the SIFT-like **Histogram of Gradients (HoG)** representation.  

This project has implement the rest of the detection pipeline -- handling heterogeneous training and testing data, training a linear classifier (a HoG template), and using resulted classifier to classify millions of sliding windows at multiple scales. Fortunately, linear classifiers are compact, fast to train, and fast to execute. A linear SVM can also be trained on large amounts of data, including mined hard negatives.

### Pipeline
The face detection mainly contains the following steps:

1. Extract Histogram of Oriented Gradient(HOG) features from positive samples and random negative samples.  
2. Train a Linear SVM classifer from both positive and negative samples.
3. Detact test dataset by sliding window and adjusting the scale of window(multiscale), determing whether each window contains a face or not.
4. Generate a bounding box with confidence threshold.
5. Compute ROC, precision-recall curve and average precision.  

*The positive training database of 6,713 cropped 36x36 faces from Caltech Web Faces project, and negative training database come from Wu et al. and the SUN scene database.*  

#### Determine random negative samples  
For each negative images, we randomly generate two integers, indicating the position of the 36x36 images. And the total number of random negative samples is 300,000.

#### Train Linear SVM  
We use Linear SVM(vl_svmtrain) with lambda as 0.0001 to get a linear classifier. 

#### Multi-scaling and step size
We change the scale of window by zooming the original test picture, downsampled to 90% recursively, and not stop downsampling until the picture has size less then 36x36.The step size we decided is 4, in compromising the efficiency and accuracy.

