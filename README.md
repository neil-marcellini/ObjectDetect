# ObjectDetect
Object Detect is an app that uses CoreML and the Resnet50 model to identify objects through the camera. I followed [this tutorial](https://youtu.be/p6GA8ODlnX0) to get the camera set up 
and to use the CoreML model. I then added labels to show the observation and its associated confidence.

## Getting Started
You will need to download the [Resnet50.mlmodel](https://ml-assets.apple.com/coreml/models/Image/ImageClassification/Resnet50/Resnet50.mlmodel) file and drag it into Xcode, as it was too large to commit to git. Make sure to run it on a real device to see the camera.

## Examples
<table>
  <tr>
    <td>Keyboard Recognized</td>
     <td>Banana Recognized</td>
     <td>Mouse Not Recognized</td>
  </tr>
  <tr>
    <td valign="top"><img src="https://i.imgur.com/6qkc5SZ.jpg" alt="Keyboard Recognized" width="300"></td>
    <td valign="top"><img src="https://i.imgur.com/TuuNdVa.jpg" alt="Banana Recognized" width="300"></td>
    <td valign="top"><img src="https://i.imgur.com/HUEJX9h.jpg" alt="Mouse Not Recognized" width="300"></td>
  </tr>
 </table>




## What I Learned
I had a lot of fun with this short project! It is amazing how easy it is to use a CoreML model, and to pass it images from the camera. I also got some experience with programmatic UI through UIkit. It's interesting to see the objects that the model can recognize, and those that it can not.
