import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/custom/custom_drawer.dart';

class UserProfile extends StatelessWidget {
  final String _fullName = "Dwight Schrute";
  final String _status = "Assistant Regional Manager at Dunder Mifflin";
  final String _bio =
      "\"Hi, I am a Freelance developer working for hourly basis. If you wants to contact me to build your product leave a message.\"";
  final String _followers = "173";
  final String _posts = "24";
  final String _scores = "450";
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
          'Profile'.toUpperCase(),
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
      drawer: CustomDrawer('PROFILE'),
    );
  }

  Widget _buildInfo(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          _buildInfoItem("Member Type", _memberType, screenSize),
          _buildInfoItem("E-mail", _email, screenSize),
          _buildInfoItem("Phone", _phone, screenSize),
        ],
      ),
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
              "Membership",
              style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              _memberType,
              style:
                  TextStyle(fontFamily: 'Roboto', fontSize: 17, color: Colors.yellow[700], fontWeight: FontWeight.w700),
            ),
          ]),
          TableRow(children: [
            Text(
              "E-mail",
              style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              _email,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 17,
              ),
            ),
          ]),
          TableRow(children: [
            Text(
              "Phone",
              style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              _phone,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 17,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String info, Size screenSize) {
    return Container(
      width: screenSize.width / 1.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.grey[600]),
          ),
          Text(
            info,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
            ),
          )
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
      fontFamily: 'Roboto',
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
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      child: Text(
        _status,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
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

  Widget _buildStatContainer() {
    return Container(
      height: 60.0,
      margin: EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildStatItem("Followers", _followers),
          _buildStatItem("Posts", _posts),
          _buildStatItem("Scores", _scores),
        ],
      ),
    );
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400, //try changing weight to w500 if not thin
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        "_bio",
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildGetInTouch(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.only(top: 8.0),
      child: Text(
        "Get in Touch with Dwight,",
        style: TextStyle(fontFamily: 'Roboto', fontSize: 16.0),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => print("followed"),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: Color(0xFF404A5C),
                ),
                child: Center(
                  child: Text(
                    "FOLLOW",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10.0),
          Expanded(
            child: InkWell(
              onTap: () => print("Message"),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "MESSAGE",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
