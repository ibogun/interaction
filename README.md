Interaction
===========

Supporting code for the trajectory clustering project.

Dependencies
===========

The code requires CVX for solving convex optimization problems. It can be downloaded fom the official website:

http://cvxr.com/cvx/download/

( to install cvx unpack the zip file and run cvx_setup.m)


Demo
===========

After cvx installation you should be able to run  demo.m


Annotations to the dataset
===========

Data set annotations are contained in the file fullRawDataSet.mat, which is an
array of objects of type 'dataEntry'. Every dataEntry object represent a video in the same order as it appears in  the data set.

Each dataEntry consists of the following parts: 

- trajectory of the left hand
- trajectory of the right hand
- trajectory of the head
- trajectory of the torso
- trajectory of the object
- time of the grasp ( frame when it happens)
- time when interaction starts
- time when interaction ends
- time when the object is placed back

Every trajectory is an object of the class trajectory, which consists of the 2-dimensional array and the name of the part
it represents. 2-dimensional array represents the tracked points of that particular part thought the video

