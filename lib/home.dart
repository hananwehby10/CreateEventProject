import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'event.dart';
import 'addOn.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Event selectedOne = eventsList.first;
int finalPrice = eventsList.first.getTotalPrice();
TextEditingController  guestsController = TextEditingController();

  void clearBtn() {
    setState(() {
      selectedOne = eventsList.first;
      guestsController.clear();
      selectedOne.guests = 1;
      selectedOne.isIndoor = true;
      selectedOne.selectedAddOns = List<bool>.filled(selectedOne.addOns.length, false);
      finalPrice = selectedOne.getTotalPrice();
    });
  }


//Sets the currently selected event and recalculates the total price.
  void selectedEventFun(Event event) {
    setState(() {
      selectedOne = event;
      selectedOne.isIndoor = true;
      selectedOne.selectedAddOns = List<bool>.filled(selectedOne.addOns.length, false);
      finalPrice = selectedOne.getTotalPrice();
    });
  }

  //name of on and called if selected or deselected
  void updateAddOn(String addOn,bool isSelected){
    setState(() {
      //search in the list of equal addon 
      int index = selectedOne.addOns.indexWhere((a) => a.name == addOn);
      if(index != -1)
        {
          // Update the selection status of the specified addon.
          selectedOne.selectedAddOns[index] = isSelected;
        }
      finalPrice = selectedOne.getTotalPrice();
  });
        }

  void updateEvent(Event event) {
    setState(() {
      selectedOne= event;
      finalPrice = selectedOne.getTotalPrice();
    });
  }

  void updateLocation(bool isIndoor){
    setState(() {
      selectedOne.isIndoor = isIndoor;
      finalPrice = selectedOne.getTotalPrice();
    });
  }

  void updateGuests(String value){
    setState(() {
      selectedOne.guests = int.tryParse(value) ?? 1;//ensure valid
      finalPrice = selectedOne.getTotalPrice();
    });
        }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //select event type
            Row(
              children: [
                const Text('Select Event Type:',style: TextStyle(fontSize: 18.0),),
                const SizedBox(width: 10.0,),
                DropDownWidget(selectedEventFun: selectedEventFun,
                selectedValue: selectedOne,),

              ],
            ),
            const SizedBox(height: 10.0,),

            //select location
            Row(
             children: [
               const Text('Select Location:', style: TextStyle(fontSize: 18.0),),
               const SizedBox(height: 10.0,),
                Radio(value: true,
                groupValue: selectedOne.isIndoor,
                onChanged: (value){
                  if(value !=null){
                    updateLocation(value);
                  }
                }),
        const Text('Indoor'),

        Radio(value: false,
            groupValue: selectedOne.isIndoor,
            onChanged: (value){
              if(value != null){
                updateLocation(value);
              }
            }),
        const Text('Outdoor'),
             ],
            ),
            const SizedBox(height: 10.0,),
            //GUESTS SECTION
            Row(
              children: [
                //num of guests
                const Text('Number Of Guests:',style: TextStyle(fontSize: 18.0),),
                const SizedBox(width: 20.0),// Space between Text and TextField
                Container(
                  width: 200,
                  height: 50,
                  child: TextField(
                    controller: guestsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: updateGuests,
                    decoration: const InputDecoration(
                      hintText: "Type here",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            //ADD ONS SECTION
            const SizedBox(height: 20.0,),
            const Text('Add-ons:', style: TextStyle(fontSize: 18.0)),
            OnsCheckBoxWidget(
              event: selectedOne,
              updateAddOn: updateAddOn,
            ),
            const SizedBox(height: 10.0),

            Text(
              'Total Price: \$${finalPrice.toString()}',
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0,),
            ElevatedButton(
                onPressed: clearBtn,
                child: const Text('Clear')),
          ],
        ),
      ),
    );
  }
}
