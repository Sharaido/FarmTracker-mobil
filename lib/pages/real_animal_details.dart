import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/custom/custom_drawer.dart';

class RealAnimalDetails extends StatefulWidget {
  final String title;

  const RealAnimalDetails({Key key, @required this.title}) : super(key: key);

  @override
  _RealAnimalDetailsState createState() => _RealAnimalDetailsState();
}

class _RealAnimalDetailsState extends State<RealAnimalDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer('ANIMAL - DETAILS'),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "NUMARALI HAYVAN",
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Colors.green[600], fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                //Navigator.popUntil(context, ModalRoute.withName('/'));
              })
        ],
        elevation: 0,
        backgroundColor: Colors.grey[200],
        iconTheme: new IconThemeData(color: Colors.green[600]),
      ),
      body: Column(
        children: [
          //İnegin olduğu satır
          Row(
            children: [
              //En yukarıdan boşluk
              SizedBox(height: 200),
              //Resim boyutu
              SizedBox(
                height: 150,
                child: Image(
                  image: AssetImage("assets/images/cow.png"),
                ),
              ),
              //Sağdaki yazıyla boşluk
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tür:          İnek"),
                  SizedBox(height: 10),
                  Text("Yaş:          15"),
                  SizedBox(height: 10),
                  Text("Kilo:         400 kg"),
                  SizedBox(height: 10),
                  Text("Seks:        Dişi"),
                  SizedBox(height: 10),
                  Text("Durum:   Ölü"),
                ],
              ),
            ],
          ),
          //Geçmiş
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20),
              Text("GEÇMİŞ:"),
            ],
          ),
          SizedBox(height: 10),
          //Geçmiş içeriği
          SizedBox(
            width: 300,
            child: Card(
              elevation: 3,
              color: Colors.brown[50],
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.brown[500],
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.fence,
                        color: Colors.green[900],
                        size: 25,
                      ),
                      Text(
                        "  Çiftliğe eklendi 20/20/2020",
                        style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 8,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.sanitizer,
                        color: Colors.pink,
                        size: 25,
                      ),
                      Text(
                        "  Aşılandı 20/20/2020",
                        style: TextStyle(
                          color: Colors.pink,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 8,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.sick,
                        color: Colors.red,
                        size: 25,
                      ),
                      Text(
                        "  Hastalandı 20/20/2020",
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 8,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.healing,
                        color: Colors.green,
                        size: 25,
                      ),
                      Text(
                        "  İyileşti 20/20/2020",
                        style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 8,
                    color: Colors.black,
                  ),
                  Row(
                    children: [  
                      Icon(
                        Icons.wash,
                        color: Colors.blue,
                        size: 25,
                      ),                    
                      Text(
                        "  Sağıldı 20/20/2020",
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 8,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.food_bank_rounded,
                        color: Colors.yellow[900],
                        size: 25,
                      ),
                      Text(
                        "  Yemlendi 20/20/2020",
                        style: TextStyle(
                          color: Colors.yellow[900],
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 8,
                    color: Colors.black,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.payments,
                        color: Colors.green,
                        size: 25,
                      ),
                      Text(
                        "  Satıldı 20/20/2020",
                        style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2),
          //Kartların olduğu satır
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //1. Kart
              SizedBox(
                width: 85,
                height: 100,
                child: Card(
                  elevation: 10,
                  color: Colors.green[500],
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.payments_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Sat",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "20/12/2021",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.green[900],
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              // İki kart arası boşluk
              SizedBox(width: 5),
              //2. Kart
              SizedBox(
                width: 85,
                height: 100,
                child: Card(
                  elevation: 10,
                  color: Colors.pink[600],
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.sanitizer,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Aşıla",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "20/12/2021",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.pink[900],
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              // İki kart arası boşluk
              SizedBox(width: 5),
              //3. kart
              SizedBox(
                width: 85,
                height: 100,
                child: Card(
                  elevation: 10,
                  color: Colors.yellow[700],
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.food_bank_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Yemle",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "20/12/2021",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.yellow[900],
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
              // İki kart arası boşluk
              SizedBox(width: 5),
              //4. Kart
              SizedBox(
                width: 85,
                height: 100,
                child: Card(
                  elevation: 10,
                  color: Colors.blue[700],
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.wash,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Sağ",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "20/12/2021",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.blue[900],
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10.0)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
