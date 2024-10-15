
// import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class AmbulanceEmergency extends StatelessWidget {
_callNumber(String  number) async{
  await FlutterPhoneDirectCaller.callNumber(number);
}
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,bottom: 5,),
      
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () => _callNumber('102'),
          child: Container(
            height: 180,
            width: MediaQuery.of(context).size.width *0.7,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.bottomRight, colors:[Colors.pink,const Color.fromARGB(255, 233, 77, 129),const Color.fromARGB(255, 220, 142, 168)])),
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                CircleAvatar(
                  radius: 25,
                   child: Image.asset('assets/ambulance.png'),
                  
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        Text('Ambulace Emergency',style: TextStyle(
                          color: const Color.fromARGB(255, 238, 238, 238),fontSize:MediaQuery.of(context).size.width*0.05, fontWeight:FontWeight.bold,
                          
                        ),),
                          Text('dial 1-0-2 for emergency',style: TextStyle(
                          color: const Color.fromARGB(255, 238, 238, 238),fontSize:MediaQuery.of(context).size.width*0.04, 
                          
                        ),),
                        Container(
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white ,borderRadius:BorderRadius.circular(20), 
                          ),
                          child: Center(
                            child: Text('1-0-2',
                            style: TextStyle(fontSize:MediaQuery.of(context).size.width*0.04,
                            fontWeight: FontWeight.bold),
                                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],),
            ) ,
          ),
        ),
      ),
    );
  }
}