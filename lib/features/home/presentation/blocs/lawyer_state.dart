import 'package:lawconnect_mobile_flutter/features/home/domain/entities/lawyer.dart';

abstract class LawyerState {
  const LawyerState();
}

class InitialLawyerState extends LawyerState {
 
}

class LoadedLawyerState extends LawyerState {
  final List<Lawyer> lawyers;
  const LoadedLawyerState(this.lawyers);
}