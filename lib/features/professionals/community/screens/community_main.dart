import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_app/core/common/widgets/error.dart';
import 'package:health_app/core/common/widgets/loader.dart';
import 'package:health_app/features/professionals/community/controller/community_controller.dart';
import 'package:health_app/features/professionals/community/screens/community_profile.dart';
import 'package:health_app/features/public_user/community/screens/community_main.dart';
import 'package:health_app/models/Community.dart';

import '../../../../core/common/widgets/community_card.dart';

class ProfessionalCommunityMainScreen extends ConsumerStatefulWidget {
  const ProfessionalCommunityMainScreen({super.key});

  @override
  ConsumerState<ProfessionalCommunityMainScreen> createState() =>
      _ProfessionalForumScreenState();
}

class _ProfessionalForumScreenState
    extends ConsumerState<ProfessionalCommunityMainScreen> {
  int selectedCommunityIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final selectedCommunity = ref.watch(selectedCommunityProvider.notifier);

    return ref.watch(getCommunitiesProvider).when(
        data: (communities) {
          var santeGenerale = communities[0];
          var santeMentale = communities[1];
          var santeReproductive = communities[2];
          var santeSexuelle = communities[3];
          void onCommunityTap(index) {
            setState(() {
              selectedCommunityIndex = index;
            });
            selectedCommunity.state = Community(
                banner: communities[index].banner,
                description: communities[index].description,
                name: communities[index].name);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const ProfessionalCommunityProfileScreen()));
          }

          return Scaffold(
            // backgroundColor: primary,
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Rejoignez nos communautés ',
                        style: TextStyle(fontSize: 28.0),
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text(
                      'Ensemble pour votre santé',
                      style: TextStyle(fontSize: 24.0),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      children: [
                        // community card
                        Expanded(
                          child: CommunityCard(
                            isSelected: selectedCommunityIndex == 0,
                            onTap: () => onCommunityTap(0),
                            name: santeGenerale.name,
                            description: santeGenerale.description,
                            banner: santeGenerale.banner,
                            screenHeight: screenHeight,
                          ),
                        ),
                        Expanded(
                          child: CommunityCard(
                            isSelected: selectedCommunityIndex == 1,
                            onTap: () => onCommunityTap(1),
                            name: santeMentale.name,
                            description: santeMentale.description,
                            banner: santeMentale.banner,
                            screenHeight: screenHeight,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // community card
                        Expanded(
                          child: CommunityCard(
                            isSelected: selectedCommunityIndex == 2,
                            onTap: () => onCommunityTap(2),
                            name: santeReproductive.name,
                            description: santeReproductive.description,
                            banner: santeReproductive.banner,
                            screenHeight: screenHeight,
                          ),
                        ),
                        Expanded(
                          child: CommunityCard(
                            isSelected: selectedCommunityIndex == 3,
                            onTap: () => onCommunityTap(3),
                            name: santeSexuelle.name,
                            description: santeSexuelle.description,
                            banner: santeSexuelle.banner,
                            screenHeight: screenHeight,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) => ErrorText(error: '$error'),
        loading: () => const Loader());
  }
}
