import 'package:flutter/material.dart';

class Pharmacycard extends StatelessWidget {
 final Function ? openMapFunction ;
  const Pharmacycard({Key? key ,this.openMapFunction}):super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
      children: [
          InkWell(
             onTap: (){
              openMapFunction!('phamacies near me ') ;
            },
            child: Card(
                color: const Color.fromARGB(255, 247, 93, 144),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 70,
                width: 70,
                child: Center(
                  child: Image.asset('assets/pharmacy.jpg',
                  height: 40,),
                ), // Center
              ), // Container
            ),
          ), // Card
          Text("Pharmacy")
        ], // Column children
      ),
    );
  }
}