import 'package:flutter/material.dart';
import 'addOn.dart';

class Event {

  String type;
  bool isIndoor = true;
  int guests = 1;
  List<bool> selectedAddOns=[]; //selected ons
  final List<AddOn> addOns; //each on with its price

Event(this.type,this.addOns){
 selectedAddOns = List<bool>.filled(addOns.length,false);
}

int getTotalPrice(){
  int price1 = guests *(isIndoor ? 5 : 10);
  int priceOfOns = 0;
  for(int i = 0 ; i<addOns.length;i++){
    if(selectedAddOns[i]==true)
      priceOfOns += addOns[i].price;
  }
  return price1 + priceOfOns;
}

}
//events types and prices
final List<Event> eventsList = [
  Event('Wedding',[
    AddOn('Buffet', 500),
    AddOn('Flowers', 300),
    AddOn('Music', 400),
  ]),
  Event('Birthday',[
    AddOn('Cake', 200),
    AddOn('Decorations', 150),
    AddOn('Games', 250),
  ]),
  Event('Baby Shower', [
    AddOn('Chocolate', 300),
    AddOn('Photoshoot', 350),
    AddOn('Snacks', 200),
  ]),
  Event('Graduation Party', [
    AddOn('Catering', 400),
    AddOn('Photo Booth', 250),
    AddOn('Party Favors', 100),
  ]),

  Event('Conference', [
    AddOn('Lunch', 150),
    AddOn('Guest Speaker', 500),
    AddOn('Networking Session', 200),
  ]),
];
class DropDownWidget extends StatelessWidget {
  final Function(Event) selectedEventFun;
  final Event selectedValue;

  const DropDownWidget({
    required this.selectedEventFun,
    required this.selectedValue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Event>(
      //Sets the currently selected item.
      value: selectedValue,
      onChanged: (Event? newValue) {
        if (newValue != null) {
          selectedEventFun(newValue);
        }
      },
      items: eventsList.map<DropdownMenuItem<Event>>((Event event) {
        return DropdownMenuItem<Event>(
          value: event,
          child: Text(event.type),
        );
      }).toList(),
    );
  }
}


class OnsCheckBoxWidget extends StatelessWidget {
  // The event holds the details of the selected event with its add-ons.
final Event event;
  //updates the add-on selection (name and status).
final Function(String,bool) updateAddOn;

  const OnsCheckBoxWidget({required this.event,
    required this.updateAddOn,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //event.addOns.length is the num of add-ons that are available
      // for the selected event,
      children:
        //each add on will have a checkbox
        //create checkbox for each index containing on
        List.generate(event.addOns.length, (index) {
          final addOnForm = event.addOns[index]; // Get the current add-on
          return CheckboxListTile(
              title: Text('${addOnForm.name} (\$${addOnForm.price})'),
              value: event.selectedAddOns[index],
              onChanged: (bool ? selected){
            if(selected != null){
              updateAddOn(addOnForm.name,selected);//is called when a checkbox is selected
            }
              });
        },
        ),

    );
  }
}
