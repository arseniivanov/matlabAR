# matlabAR
-----Simple augmented reality done in MATLAB-----


The simplest version homographyPlacement.m works by selecting 4 points in a photo, creating a homography using SVD that transforms an arbitrary image from it's corner points into the scene.

The more advanced cameraMotionAutomatic.m works by thresholding a contrasting scene, finding a square object and extracting it's corners. pgonCorners sorts these corners in the same way every time, so we can use that information to perform the simple homography operation automatically every frame.

-------------------------------------------------

pgonCorners - Implementation of the cMinMax-algorithm by Mathworks user Matt J, use to detect corners of a binary polygon.

Augmented.MP4 - Demo video of result

blackbook.MP4 - Video to apply augmented reality to

cameraMotionAutomatic.m - Automatic detection of binary object using cMinMax-algorithm

checkerAbove.jpg - Photo for calibration of KLT-tracker

decompHomography.XXX - C++-wrapper to decompose homography into Rotation, translation and normal vector of surface, supposed to be used to render geometry into the scene, but this is hard to perform in MATLAB, check out the C++-implementation instead.

food.jpg - image to insert into scene, can be switched out to arbitrary image

homographyPlacement.m - Simplest form of AR done with homography by choosing 4 points in scene

homographyAutomaticKLT.m - NOT WORKING PROPERLY. Issue with corner point ambiguity causes homography to freak out 

imchecker.jpg - Photo for calibration of KLT-tracker once video is too different from checkerAbove.jpg to detect similarity
