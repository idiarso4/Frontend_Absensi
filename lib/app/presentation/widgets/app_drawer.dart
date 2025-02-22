import 'package:flutter/material.dart';
import 'package:skansapung_presensi/app/data/model/menu_item.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(243, 154, 0, 0.988),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Color.fromRGBO(243, 154, 0, 0.988),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'PRESENSI SKANSAPUNG',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: MenuItems.mainMenuItems.length,
              itemBuilder: (context, index) {
                final menu = MenuItems.mainMenuItems[index];
                if (menu.subMenus.isEmpty) {
                  return _buildMenuItem(context, menu);
                } else {
                  return _buildExpandableMenuItem(context, menu);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem menu) {
    return ListTile(
      leading: Icon(menu.icon, color: Color.fromRGBO(243, 154, 0, 0.988)),
      title: Text(menu.title),
      onTap: () {
        Navigator.pop(context); // Close drawer
        Navigator.pushNamed(context, menu.route);
      },
    );
  }

  Widget _buildExpandableMenuItem(BuildContext context, MenuItem menu) {
    return ExpansionTile(
      leading: Icon(menu.icon, color: Color.fromRGBO(243, 154, 0, 0.988)),
      title: Text(menu.title),
      children: menu.subMenus.map((subMenu) {
        return ListTile(
          leading: Icon(subMenu.icon, color: Color.fromRGBO(243, 154, 0, 0.988)),
          title: Text(subMenu.title),
          contentPadding: EdgeInsets.only(left: 32.0, right: 16.0),
          onTap: () {
            Navigator.pop(context); // Close drawer
            Navigator.pushNamed(context, subMenu.route);
          },
        );
      }).toList(),
    );
  }
}
