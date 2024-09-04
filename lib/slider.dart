import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatelessWidget {
  final List<String> imagePaths = [
    'asset/FacialTreatment.png',
    'asset/hair color.jpg',
    'asset/hair treatment.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: 200.0,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 200.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            viewportFraction: 0.8,
          ),
          items: imagePaths.map((imagePath) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50.0),  // Curved top edge
                      bottom: Radius.circular(50.0), // Curved bottom edge
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(0, 4), // Offset in x and y
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.0),
                      bottom: Radius.circular(20.0),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
