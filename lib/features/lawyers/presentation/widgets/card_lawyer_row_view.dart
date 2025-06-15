import 'package:flutter/material.dart';

class CardLawyerRowView extends StatelessWidget {
  //
  final String name;
  final String specialty;
  final String rating;
  final String description;
  final String imageUrl;

  const CardLawyerRowView({
    super.key, 
    required this.name,
    required this.specialty,
    required this.rating,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    int totalStars = int.parse(rating); // Convertir el rating a un entero
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey, // Set your border color
              width: 1,           // Set your border width
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: SizedBox(
            height: 150, // Set height
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(22), // Adjust the radius as needed
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      imageUrl, // Replace with your image source
                      width: 80, // Set width
                      height: 110, // Set height
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Text(specialty,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.normal,
                        )),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 120), // Limita el ancho
                      child: Text(
                        description.length > 50
                            ? '${description.substring(0, 50)}...'
                            : description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(totalStars, (index) {
                        return Icon(Icons.star, color: Colors.amber);
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}