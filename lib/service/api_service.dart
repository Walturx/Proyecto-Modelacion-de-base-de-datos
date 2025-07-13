import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> insertarPedido() async {
  final url = Uri.parse('http://10.0.2.2:3000/insertar-pedido'); // 
  // final url = Uri.parse('http://localhost:3000/insertar-pedido'); 

  final data = {
    "factura": {
      "monto_total": 150,
      "fecha_emision": "2025-06-26",
      "estado_pago": "pendiente",
      "metodo_pago": "efectivo",
      "divisa": "PEN"
    },
    "pedido": {
      "fecha_ingreso": "2025-06-26",
      "estado_pedido": "registrado",
      "total": 150,
      "fecha_entrega_estimada": "2025-07-01"
    },
    "items": [
      {
        "cantidad": 2,
        "talla": "M",
        "color": "Azul",
        "personalizacion": "Logo bordado",
        "precio_unitario": 75,
        "id_producto": 1
      }
    ]
  };

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print("✅ Pedido insertado: $result");
    } else {
      print("❌ Error: ${response.statusCode}");
      print(response.body);
    }
  } catch (e) {
    print("⚠️ Error de conexión: $e");
  }
}
