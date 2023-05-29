
import 'package:flutter/material.dart';
import 'package:project_db/sql_helper.dart';

class HomeScreen extends StatefulWidget
{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Map<String, dynamic>> _allData =[];
  bool _isLoading =true;



  void _refreshData() async{
    final data= await SQLHelper.GetAllData();
    setState(() {
      _allData= data;
      _isLoading = false;
    });
  }


  @override
  void initState(){
    super.initState();
    _refreshData();
  }


  Future<void> _addData() async {
    await SQLHelper.createData(_nomController.text, _telController.text);
    _refreshData();
  }


  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(id, _nomController.text, _telController.text);
    _refreshData();
  }

  Future<void> _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.red,
      content: Text("Contact Deleted"),
    ));
    _refreshData();
  }


  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _telController = TextEditingController();

  void showBottomSheet(int? id) async{
    if(id!=null){
      final existingData=
      _allData.firstWhere((element) => element['id'] == id);
      _nomController.text=existingData['nom'];
      _telController .text=existingData['tel'];
    }
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_)=> Container(padding:EdgeInsets.only(top: 30, left: 15, right: 15, bottom: MediaQuery.of(context).viewInsets.bottom+50,) ,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _nomController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nom",
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _telController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Telephone",
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed:() async{
                  if (id==null){
                    await _addData();
                  }
                  if (id!=null){
                    await _updateData(id);
                  }
                  _nomController.text="";
                  _telController.text="";

                  Navigator.of(context).pop();
                  print("Contact Added");
                },
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(id == null ? "Add Contact": "Update",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Contact List"),
        ),
        body: _isLoading? Center(
          child: CircularProgressIndicator(),):
        ListView.builder(
          itemCount: _allData.length,
          itemBuilder: (context,index) => Card(
            margin: EdgeInsets.all(15),
            child:  ListTile(
              title: Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child:Text(
                  _allData[index]['nom'],
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              subtitle: Text(_allData[index]['tel']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){
                    showBottomSheet(_allData[index]['id']);
                  }, icon: Icon(
                      Icons.edit,
                      color: Colors.blueAccent
                  ),
                  ),
                  IconButton(onPressed: (){
                    _deleteData(_allData[index]['id']);
                  }, icon: Icon(
                      Icons.delete,
                      color: Colors.deepOrange
                  ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showBottomSheet( null),
          child: Icon(Icons.add),
        )
    );
  }
}






























