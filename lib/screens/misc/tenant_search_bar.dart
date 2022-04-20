import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roomfy_proj/providers/tenant.dart';
import 'package:roomfy_proj/screens/room/room_detail_screen.dart';
import 'package:roomfy_proj/screens/tenant/tenant_detail_screen.dart';
import '../../providers/room.dart';

class SearchTenant extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(
    BuildContext context,
  ) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(
    BuildContext context,
  ) {
    return FutureBuilder<List<dynamic>>(
        future: fetchQuery(query: query, context: context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          List<dynamic>? data = snapshot.data;
          return ListView.builder(
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(
                        TenantDetailScreen.routeName,
                        arguments: data?[index].id);
                  },
                  child: ListTile(
                    title: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              Center(child: Image.network(data?[index].photo1)),
                        ),
                        const SizedBox(width: 20),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data?[index].title}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '${data?[index].location}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ])
                      ],
                    ),
                  ),
                );
              });
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container(
        color: Colors.black,
        child: FutureBuilder<List<Tenant>>(
          future: fetchQuery(query: query, context: context),
          builder: (context, snapshot) {
            if (query.isEmpty) return buildNoSuggestions();
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                ));
              default:
                if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return buildNoSuggestions();
                } else {
                  return Column(
                    children: [
                      //  Text(snapshot.data.length),
                      buildSuggestionsSuccess(snapshot.data!),
                    ],
                  );
                }
            }
          },
        ),
      );

  Widget buildNoSuggestions() => const Center(
        child: Text(
          'No Tenant Found!',
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      );

  Widget buildSuggestionsSuccess(List<Tenant> suggestions) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // String foundCourse =
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Found " + suggestions.length.toString() + " Tenants",
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
            SizedBox(
              //  color: darkBlueColor,
              height: 450,
              width: double.infinity,
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  final queryText =
                      suggestion.title.toString().substring(0, query.length);
                  final remainingText =
                      suggestion.title.toString().substring(query.length);

                  return Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: ListTile(
                      onTap: () {
                        showResults(context);
                      },
                      title: RichText(
                        text: TextSpan(
                          text: queryText,
                          style: const TextStyle(
                            color: Colors.black,
                            //fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: remainingText,
                              style: const TextStyle(
                                color: Color(0xFFB4B4B4),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Tenant>> fetchQuery(
      {required String query, required BuildContext context}) async {
    List<Tenant> temp =
        await Provider.of<Tenants>(context).fetchQuery(query: query);
    return temp;
  }
}
