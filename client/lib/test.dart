import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartclass_fyp_2024/dataprovider/data_provider.dart';
import 'package:smartclass_fyp_2024/models/class_models.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MyWidget extends ConsumerWidget {
  const MyWidget({super.key});

  Future<void> _handleRefresh(WidgetRef ref) async {
    //Reload the data in class provider
    await ref.refresh(classDataProvider);
    //reloading take some time..
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(classDataProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('SmartClass')),
      body: data.when(
        data: (data) {
          List<ClassModel> classes = data;
          return LiquidPullToRefresh(
            onRefresh: () => _handleRefresh(ref),
            color: Colors.deepPurple,
            height: 100,
            backgroundColor: Colors.deepPurple[200],
            animSpeedFactor: 4,
            showChildOpacityTransition: false,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: classes.length,
                    itemBuilder: (_, index) {
                      return Card(
                        color: Colors.blueAccent,
                        child: ListTile(
                          title: Text(classes[index].courseName),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        error: (err, s) => Text(err.toString()),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
