import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.yellow[700]
                      ),
                    ),
                    Icon(
                      CupertinoIcons.person_fill,
                      color: Theme.of(context).colorScheme.outline,  
                    ),
                  ],
                ), 
                const SizedBox(width: 8,),
                Column(
                  children: [
                    Text(
                      "Welcome!",
                        style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600, 
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    Text(
                      "Nizar Afham",
                        style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold, 
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: (){}, 
                    icon: Icon(CupertinoIcons.settings),
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}