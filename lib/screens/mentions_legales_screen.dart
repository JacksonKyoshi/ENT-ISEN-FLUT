import 'package:flutter/material.dart';

class MentionsLegalesScreen extends StatelessWidget {
  const MentionsLegalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flut - ENT ISEN'),
        foregroundColor: const Color(0xFFFFFFFF),
        backgroundColor: const Color(0xFF2A2450)
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Dénomination : ISEN ENGINEERING"),
              Text("Adresse : Maison du numérique et de l'innovation, Place Georges Pompidou, 83000 TOULON"),
              Text("Contact : bureau-engineering@yncrea.fr"),
              Text("SIREN : 501 150 247"),
              Text("SIRET : 50115024700010"),
              Text("TVA Intracommunautaire : FR29501150247"),
              Text("Code NAF : Autres organisations fonctionnant par adhésion volontaire (9499Z)"),
              Text("Forme juridique : Association déclarée à but non lucratif et non académique"),
              SizedBox(height: 20),
              Text("Les données fournies par l'utilisateur sont envoyées au serveur de l'ISEN Méditerranée puis sont détruites par le serveur de l'ISEN ENGINEERING"),
              Text("Pour assurer la rapidité de l'application, des informations personnelles sont conservées dans le téléphone telles que le planning, les absences et les notes. Les informations de connection sont conservées uniquement si la case \"Se souvenir de moi\" a été cochée."),
              Text("Pour toute réclamation concernant les données personnelles, contactez nous à"),
              Text("bureau-engineering@yncrea.fr")
            ],
        )
        )
      )
    );
  }
}