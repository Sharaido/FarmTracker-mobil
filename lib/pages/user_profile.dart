import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/custom/custom_drawer.dart';

class UserProfile extends StatelessWidget {
  final String _fullName = "Dwight Schrute";
  final String _status = "Dunder Mifflin'de Yardımcı Bölge Müdürü";
  final String _email = "dwight@dundermifflin.com";
  final String _phone = "1-800-984-DMPC";
  final String _memberType = "Gold";

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profil'.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: new IconThemeData(color: Colors.green),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.green,
            ),
            onPressed: null,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 5.4),
                  _buildProfileImage(),
                  _buildFullName(),
                  _buildStatus(context),
                  _buildInfoTable(screenSize),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer('PROFIL'),
    );
  }

  Widget _buildInfoTable(Size screenSize) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      width: screenSize.width / 1.3,
      child: Table(
        columnWidths: {0: const FixedColumnWidth(110)},
        children: [
          TableRow(children: [
            Text(
              "Üyelik Türü",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              _memberType,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.yellow[700],
                  fontWeight: FontWeight.w700),
            ),
          ]),
          TableRow(children: [
            Text(
              "E-mail",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              _email,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ]),
          TableRow(children: [
            Text(
              "Telefon",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              _phone,
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 3.6,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 7, color: Colors.green)),
        image: DecorationImage(
          image: AssetImage('assets/images/dwightbackground.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dwight.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.green,
            width: 7.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      _fullName,
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
      child: Text(
        _status,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w200,
    );

    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count,
          style: _statCountTextStyle,
        ),
        Text(
          label,
          style: _statLabelTextStyle,
        ),
      ],
    );
  }
}
