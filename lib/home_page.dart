import 'dart:io';

import 'package:celebrare/provider_state/provider_state.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:widget_mask/widget_mask.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  File? image;
  bool isPicked=false;
  // int currentFrame = 0;


  Future<void> pickImageMethod(context)async{
  XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
  if(file!=null){
    ImageCropperMethod(context,file.path);

  }
  }

  Future<void> ImageCropperMethod(context,filepath)async{
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: filepath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
    uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Color(0xff2B2B2B),
          toolbarWidgetColor: Colors.white60,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Crop',
      ),
    ]
    );
    if(croppedFile!=null) {
      showDialog(context: context,
          builder: (context) => myDialog(context, croppedFile!.path));
      isPicked = true;
    }
  }



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var myprovider = Provider.of<ProviderState>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){},
          icon: Icon(Icons.arrow_back_ios,
            color: Color.fromRGBO(66, 66, 66, 1.0),), //
        ),
        title: Text("Add Image / Icon",style: TextStyle(color:Color.fromRGBO(137, 134, 134, 0.9,) ,fontFamily: "Lora"),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
            child: Container(
              height:height*0.14,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                border: Border.fromBorderSide(BorderSide(color:Color.fromRGBO(137, 134, 134, 0.9) ))
              ),
              child:Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding:const EdgeInsets.symmetric(vertical: 10),child: Text("Upload Image",style: TextStyle(fontSize: 15,color:Color.fromRGBO(137, 134, 134, 0.9,) ,fontFamily: "Lora"),),),
                    GestureDetector(
                      onTap: (){
                        myprovider.UpdateFrame(0);
                        pickImageMethod(context);
                      },
                      child: Container(
                        height: height*0.049,
                        width: width*0.43,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(7, 127, 105, 0.9),
                          borderRadius: BorderRadius.all(Radius.circular(6))
                        ),
                        child: Center(
                          child: Text("Choose from Device",style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          isPicked?Consumer<ProviderState>(
            builder: (context,provider,child){
              return Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: height*0.44,
                  width: double.infinity,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // color: Colors.red,
                  child: provider.finalFrame==0?Image.file(image!,fit: BoxFit.contain,):WidgetMask(
                      blendMode: BlendMode.srcATop,
                      childSaveLayer: true,
                      mask: Image.file(image!,fit: BoxFit.cover,),
                      child: Image.asset("assets/user_image_frame_${provider.finalFrame}.png",fit: BoxFit.contain,)
                  ),
                ),
              );
            },
          ):Container()
        ],
      ),
    );
  }

  Widget myDialog(context,filePath){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
     var myprovider = Provider.of<ProviderState>(context,listen: false);
    return Dialog(
      child: Container(
        height: height*0.55,
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(icon: Icon(Icons.cancel,size: 29,color:Color.fromRGBO(137, 134, 134, 0.9) ,),onPressed: (){Navigator.pop(context);},),
            ),
            Text("Uploaded Image",style: TextStyle(fontSize: 17,color:Color.fromRGBO(137, 134, 134, 0.9,) ,fontFamily: "Lora"),),
            Consumer<ProviderState>(
              builder: (context,provider,child){
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    height:height*0.27,
                    width: width*0.5,
                    // color: Colors.red,
                    child: provider.currentFrame==0?Image.file(File(filePath),fit: BoxFit.contain,):WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: Image.file(File(filePath),fit: BoxFit.cover,),
                        child: Image.asset("assets/user_image_frame_${provider.currentFrame}.png",fit: BoxFit.contain,)
                    ),
                  ),
                );
              },
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: GestureDetector(
                    onTap: (){
                      myprovider.UpdateFrame(0);
                      // setState(() {
                      //   currentFrame=0;
                      // });
                    },
                    child: Container(
                      height:height*0.06,
                      width: width*0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.fromBorderSide(BorderSide(color:Color.fromRGBO(137, 134, 134, 0.9) ))
                      ),
                      child: Center(child: Text("Original")),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: GestureDetector(
                    onTap: (){
                      myprovider.UpdateFrame(1);
                    //   setState(() {
                    //     currentFrame=1;
                    //   });
                    },
                    child: Container(
                      height:height*0.06,
                      width: width*0.13,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.fromBorderSide(BorderSide(color:Color.fromRGBO(137, 134, 134, 0.9) ))
                      ),
                      child: Center(child:Image.asset("assets/user_image_frame_1.png")),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: GestureDetector(
                    onTap: (){
                      myprovider.UpdateFrame(2);
                      // setState(() {
                      //   currentFrame=2;
                      // });
                    },
                    child: Container(
                      height:height*0.06,
                      width: width*0.13,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.fromBorderSide(BorderSide(color:Color.fromRGBO(137, 134, 134, 0.9) ))
                      ),
                      child: Center(child: Image.asset("assets/user_image_frame_2.png")),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: GestureDetector(
                    onTap: (){
                      myprovider.UpdateFrame(3);
                      // setState(() {
                      //   currentFrame=3;
                      // });
                    },
                    child: Container(
                      height:height*0.06,
                      width: width*0.13,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.fromBorderSide(BorderSide(color:Color.fromRGBO(137, 134, 134, 0.9) ))
                      ),
                      child: Center(child: Image.asset("assets/user_image_frame_3.png")),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: GestureDetector(
                    onTap: (){
                      myprovider.UpdateFrame(4);
                      // setState(() {
                      //   currentFrame=4;
                      // });
                    },
                    child: Container(
                      height:height*0.06,
                      width: width*0.13,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.fromBorderSide(BorderSide(color:Color.fromRGBO(137, 134, 134, 0.9) ))
                      ),
                      child: Center(child: Image.asset("assets/user_image_frame_4.png")),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: GestureDetector(
                onTap: (){
                  var finalFrame= myprovider.currentFrame;
                  myprovider.UpdateFinalFrame(finalFrame);
                  setState(() {
                    image = File(filePath);
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  height: height*0.059,
                  width: width*0.7,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(7, 127, 105, 0.9),
                      borderRadius: BorderRadius.all(Radius.circular(6))
                  ),
                  child: Center(
                    child: Text("Use this image",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

}

/*class AllFrameShape extends CustomPainter{
  final  shape;

  AllFrameShape({
    required this.shape
});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 1
      ..style=PaintingStyle.stroke
      ..color= Colors.white60;

    Paint paint1 = Paint()
      ..strokeWidth = 1
      ..style=PaintingStyle.stroke
      ..color= Colors.white60;

    drawShape(canvas,size,paint,paint1);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }


  Path drawShape(Canvas canvas, Size size,Paint paint,Paint paint1){
    double height = size.height;
    double width = size.width;
    Path path = Path();

    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6,
        0.5 * width, height);
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6,
        0.5 * width, height);

    canvas.drawImage(image, offset, paint)
    canvas.drawPath(path, paint1);
    canvas.drawPath(path, paint);

   return path;
  }

}*/


/*
class HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint = Paint();
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    Paint paint1 = Paint();
    paint1
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 0;

    double width = size.width;
    double height = size.height;

    Path path = Path();
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6,
        0.5 * width, height);
    path.moveTo(0.5 * width, height * 0.35);
    path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6,
        0.5 * width, height);

    canvas.drawPath(path, paint1);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
*/
