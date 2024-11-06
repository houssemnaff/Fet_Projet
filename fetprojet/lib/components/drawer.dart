// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          
          UserAccountsDrawerHeader(
       decoration:const BoxDecoration(color: Color.fromARGB(255, 14, 7, 157),
       image: DecorationImage(

        image: AssetImage("assets/background.jpeg"),
        fit: BoxFit.cover)),
       
            accountName:Text("naffouti houssem",) ,
           accountEmail: Text("houssemnaffouti28@gmail.com"),

           currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: Image.asset("assets/logo.png"),
            ),
           ),
          
           ),
           ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: (){print("object");
            },
           ),
                 Divider(color: Colors.transparent),

            ListTile(
            leading: Icon(Icons.group),
            title: Text("Etudiant"),
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,height: 20,
                child: Center(child: Text("9",style: TextStyle(color: Colors.white,fontSize: 12),)),
              ),
            ),
            onTap: (){print("object");
            },
           ),
            ListTile(
               trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,height: 20,
                child: Center(child: Text("9",style: TextStyle(color: Colors.white,fontSize: 12),)),
              ),
            ),
            leading: Icon(Icons.person),
            title: Text("Prof"),
            onTap: (){print("object");
            },
           ),
            ListTile(
            leading: Icon(Icons.timelapse),
            title: Text("emploi"),
            onTap: (){print("object");
            },
           ),
            ListTile(
               trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,height: 20,
                child: Center(child: Text("9",style: TextStyle(color: Colors.white,fontSize: 12),)),
              ),
            ),
            leading: Icon(Icons.bookmark_add),
            title: Text("cours"),
            onTap: (){print("object");
            },
           ),
           Divider(color: Colors.transparent),
            ListTile(
            leading: Icon(Icons.settings),
            title: Text("Setting"),
            onTap: (){print("object");
            },
           )
        ],
        
      )
    );
  }
}