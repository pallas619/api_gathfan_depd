part of 'widgets.dart';

class CardOngkir extends StatefulWidget {
  final Costs cost;
  const CardOngkir(this.cost);

  @override
  State<CardOngkir> createState() => _CardOngkirState();
}

class _CardOngkirState extends State<CardOngkir> {
  @override
  Widget build(BuildContext context) {
    Costs c = widget.cost;

    return Card(
      color: Color(0xFFFFFFFF),
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        leading: Image.asset(
          'assets/images/courier.png', 
          width: 40, 
          height: 40,
        ),
        title: Text("Service: ${c.service}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${c.description}"),
            for (var cost in c.cost ?? [])
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Biaya: ${cost.value}"),
                  Text("Estimasi Sampai: Rp ${cost.etd}"),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
