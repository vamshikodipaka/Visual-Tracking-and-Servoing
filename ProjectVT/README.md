# Multiple face tracking in video
 
MATLAB implemented software for multi-face tracking in videos. Originally developed for an [ECCV 2016 workshop paper](#citation) to track characters' faces in TV shows.
 
## Included
 
* Software for tracking faces in videos.
* Visualisation function to view the tracks.
* Demo script and video to illustrate how to use the code.

## How it works

This software detects faces using the frontal-face detector of Viola-Jones. Face bounding boxes are then tracked using the Kanade-Lucas-Tomasi (KLT) algorithm. The tracked key points (BRISK) are updated when a new face detection appears. Key points are only searched for within the centre of the face bounding box, this reduces drift to background content but also enables tracking to profile faces.
 
## Dependencies
 
The code has been tested in MATLAB R2018a and will presumably also run in later versions. 
 
The following MATLAB toolboxes are required:
 
* Computer Vision System Toolbox
* Control System Toolbox
* Image Processing Toolbox
 
## Citation
 
If you use this code then please cite:
 
```
@Article{Charles16b,
  author       = "Charles, J. and Magee, D. and Hogg.",
  title        = "Virtual Immortality: Reanimating characters from TV shows",
  booktitle    = "ECCV Workshop on Virtual/Augmented Reality for Visual Artificial Intelligence (VARVAI)",  
  year         = "2016",
}
```

