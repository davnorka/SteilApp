import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const SteilApp());
}

class SteilApp extends StatelessWidget {
  const SteilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'STEIL Werkstatt App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const WerkstattFormularScreen(),
    );
  }
}

class WerkstattFormularScreen extends StatefulWidget {
  const WerkstattFormularScreen({super.key});

  @override
  State<WerkstattFormularScreen> createState() =>
      _WerkstattFormularScreenState();
}

class _WerkstattFormularScreenState extends State<WerkstattFormularScreen> {
  final _monteurController = TextEditingController();
  final _kwController = TextEditingController();
  final _kundeController = TextEditingController();

  final _geraetController = TextEditingController();
  final _herstellerController = TextEditingController();
  final _bezeichnungController = TextEditingController();
  final _kfzController = TextEditingController();
  final _finController = TextEditingController();

  final _huController = TextEditingController();
  final _auController = TextEditingController();
  final _spController = TextEditingController();
  final _kmController = TextEditingController();
  final _stdController = TextEditingController();

  final _auftragsnotizenController = TextEditingController();
  final _arbeitenController = TextEditingController();
  final _anmerkungenController = TextEditingController();

  Future<void> _generateAndSharePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.blueGrey900,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('STEIL KRANARBEITEN',
                        style: pw.TextStyle(
                            color: PdfColors.white,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text('Werkstatt SW (Digitalvorlage)',
                        style: const pw.TextStyle(
                            color: PdfColors.white, fontSize: 12)),
                  ],
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Text('AUFTRAG & MONTEUR',
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey700)),
              pw.Divider(),
              pw.Row(
                children: [
                  pw.Expanded(
                      child: pw.Text('Monteur: ${_monteurController.text}')),
                  pw.Expanded(child: pw.Text('KW-Nr.: ${_kwController.text}')),
                  pw.Expanded(
                      child: pw.Text('Kunden-Nr.: ${_kundeController.text}')),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text('GERÄT & FAHRZEUGDATEN',
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey700)),
              pw.Divider(),
              pw.Bullet(text: 'Gerät: ${_geraetController.text}'),
              pw.Bullet(text: 'Hersteller: ${_herstellerController.text}'),
              pw.Bullet(text: 'Bezeichnung: ${_bezeichnungController.text}'),
              pw.Bullet(text: 'KFZ-Kennzeichen: ${_kfzController.text}'),
              pw.Bullet(
                  text: 'Fahrzeug-Ident.Nr. (FIN): ${_finController.text}'),
              pw.SizedBox(height: 10),
              pw.Text('PRÜFUNGEN & STÄNDE',
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey700)),
              pw.Divider(),
              pw.Row(
                children: [
                  pw.Expanded(
                      child: pw.Text('Nächste HU: ${_huController.text}')),
                  pw.Expanded(
                      child: pw.Text('Nächste AU: ${_auController.text}')),
                  pw.Expanded(
                      child: pw.Text('Nächste SP: ${_spController.text}')),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                children: [
                  pw.Expanded(
                      child: pw.Text('KM-Stand: ${_kmController.text}')),
                  pw.Expanded(
                      child:
                          pw.Text('Betriebsstunden: ${_stdController.text}')),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text('ARBEITEN & ANMERKUNGEN',
                  style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey700)),
              pw.Divider(),
              pw.Text('Auftragsannahme:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Paragraph(
                  text: _auftragsnotizenController.text.isEmpty
                      ? '-'
                      : _auftragsnotizenController.text),
              pw.Text('Ausgeführte Arbeiten & Zeiten:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Paragraph(
                  text: _arbeitenController.text.isEmpty
                      ? '-'
                      : _arbeitenController.text),
              pw.Text('Anmerkungen:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Paragraph(
                  text: _anmerkungenController.text.isEmpty
                      ? '-'
                      : _anmerkungenController.text),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'werkstatt_bericht.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('STEIL Werkstatt App'),
        backgroundColor: const Color(0xFF1A2530),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionHeader('AUFTRAG & MONTEUR'),
            _buildTextField('MONTEUR / NAME', _monteurController),
            _buildTextField('KW NR.', _kwController),
            _buildTextField('KUNDEN-NR.', _kundeController),
            const SizedBox(height: 15),
            _buildSectionHeader('GERÄT & FAHRZEUGDATEN'),
            _buildTextField('GERÄT', _geraetController),
            _buildTextField('HERSTELLER', _herstellerController),
            _buildTextField('BEZEICHNUNG', _bezeichnungController),
            _buildTextField('KFZ KENNZEICHEN', _kfzController),
            _buildTextField('FAHRZEUG-IDENT. NR. (FIN)', _finController),
            const SizedBox(height: 15),
            _buildSectionHeader('PRÜFUNGEN & STÄNDE'),
            _buildTextField('NÄCHSTE HU', _huController),
            _buildTextField('NÄCHSTE AU', _auController),
            _buildTextField('NÄCHSTE SP', _spController),
            _buildTextField('KM-STAND', _kmController),
            _buildTextField('BETRIEBSSTUNDEN', _stdController),
            const SizedBox(height: 15),
            _buildSectionHeader('ARBEITEN & ANMERKUNGEN'),
            _buildTextField('AUFTRAGSANNAHME', _auftragsnotizenController),
            _buildTextField(
                'AUSGEFÜHRTE ARBEITEN & ZEITEN', _arbeitenController,
                maxLines: 3),
            _buildTextField('ANMERKUNGEN', _anmerkungenController),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _generateAndSharePdf,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E5631),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('PDF mit diesen Daten Erstellen'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 10),
      color: const Color(0xFFE9ECEF),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A2530),
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
        ),
      ),
    );
  }
}
