import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/features/profile/domain/entities/client.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Client> _clients = [
    Client(
      id: '1', 
      name: 'John', 
      lastName: 'Doe', 
      dni: '12345678', 
      username: 'johndoe', 
      image: 'https://ibb.co/LXjJRDrz'
      )
  ];


  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}