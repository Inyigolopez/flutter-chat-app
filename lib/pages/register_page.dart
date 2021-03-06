import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/services/auth_service.dart';

import 'package:chat_app/helpers/mostrar_alerta.dart';

import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/custom_input.dart';


class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                
                Logo( titulo: 'Registro' ),

                _Form(),

                Labels( 
                  ruta: 'login', 
                  titulo: '¿Ya tienes una cuenta?', 
                  subtitulo: 'Login aquí'
                ),

                Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200)),


              ],
            ),
          ),
        ),
      ),
   );
  }
}


class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[

          CustomInput(
            icon: Icons.perm_identity_outlined,
            placeholder: 'Nombre',
            textController: nameCtrl,
            keyboardType: TextInputType.text
          ),

          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            textController: emailCtrl,
            keyboardType: TextInputType.emailAddress
          ),

          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),

          BotonAzul(
            text: 'Crear cuenta',
            onPressed: authService.autenticando ? null : () async {
              print(nameCtrl.text);
              print(emailCtrl.text);
              print(passCtrl.text);

              final registroMSG = await authService.register(nameCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim());
              print(registroMSG);

              if( registroMSG == true ){
                socketService.connect();
                Navigator.pushReplacementNamed(context, 'usuarios');

              } else {
                mostrarAlerta(context, 'Registro incorrecto', registroMSG);
              }


            }
          )

        ],
      ),    
    );
  }
}

