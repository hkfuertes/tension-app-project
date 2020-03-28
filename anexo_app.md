#### Anexo 2: Pantallas de la App

##### Pantallas generales

La aplicacion tiene varias 3 pantallas principales, como son `pacientes`, `estadisticas` y `perfil`, a parte de la pagina de login que solo veremos la primera vez que nos logueemos.

<table>
<thead><tr><td><strong>Pantalla</strong></td><td><strong>Comentario</strong></td></tr></thead>
<tbody>
    <tr>
        <td><img src="images/app/login.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de login</strong><br/>Para poder acceder al sistema, el médico debera hacer login en el sistema.<br/><small><i>(A dia de hoy la unica forma de generar un usuario es mediante una llamada a la API, via postman, explicada en la parte del server.)</i></small></td>
    </tr>
    <tr>
        <td><img src="images/app/pacientes.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de Pacientes</strong><br/>Nad mas entrar en la aplicacion se nos presenta esta pantalla.<br/>Aqui veremos nuestros pacientes y podremos, clicando sobre ellos, consultar el historico de las medidas asi como realizar nuevas mediciones.</td>
    </tr>
    <tr>
        <td><img src="images/app/estadistica.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de Estadisticas</strong><br/>La segunda pestaña que nos encontramos es la de estadistica.<br/>Aqui se cargaran todos los datos numericos de todos los pacientes de todos los medicos en forma de grafica.</td>
    </tr>
    <tr>
        <td><img src="images/app/perfil.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de Perfil</strong><br/>La tercera pestaña es la del perfil de usuario.<br/>Aqui se encuentrasn todas las configuraciones de la plataforma asi como los datos privados de los médicos, nombre, apellidos, contraseña, etc.</td>
    </tr>
</tbody>
</table>

##### Pantallas de Medición

Si nos centramos en la pantalla de pacientes y entramos en su historico podremos introducir nuevas mediciones de peso, presion y pulso.

<table>
<thead><tr><td><strong>Pantalla</strong></td><td><strong>Comentario</strong></td></tr></thead>
<tbody>
    <tr>
        <td><img src="images/app/historico.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de historico de Paciente</strong><br/>Al seleccionar un paciente de la lista de pacientes llegaremos a esta pantalla.<br/>Aquí podemos ver las ultimas mediciones, asi como realizar nuevas.</td>
    </tr>
    <tr>
        <td><img src="images/app/toma_peso.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de introduccion de peso</strong><br/>Pulsando sobre el boton <strong><i>Peso</i></strong> se nos desplegara un dialogo para introducir la medida. </td>
    </tr>
    <tr>
        <td><img src="images/app/toma_tension.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de introduccion de tension</strong><br/>Pulsando sobre el boton <strong><i>Tensión</i></strong> se nos desplegara un dialogo para introducir la medida.<br/> En este caso podemos introducir mas de una toma, simplemente dandole al boton "<strong><i>+</i></strong>"</td>
    </tr>
    <tr>
        <td><img src="images/app/toma_tension_enviar.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de envio de tension</strong><br/>Cuando tengamos todas las tomas deseadas, simplemente las enviamos dandole al boton de guardar.<br/> Se nos abrira un cuadro de dialogo preguntando que queremos enviar, si la media o la ultima.</td>
    </tr>
    <tr>
        <td><img src="images/app/pulso_menu.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de introducción de pulso</strong><br/>Pulsando sobre el boton <strong><i>Pulso</i></strong> se nos desplegara una para seleccionar como queremos introducir la medida.<br/>Podra ser manual, utilizando el flash y la camara del movil, o mediante un aparato conectado al USB del movil.<br/> Una vez tengamos la medida, simplemente le damos a guardar.<br/>
        <small><i>(Actualemente la opcion USB esta por desarrollar)<br>
        (La opcion de flash + camara solo esta disponible para Android)</i></small></td>
    </tr>
    <tr>
        <td><img src="images/app/pulso_manual.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de introducción de pulso</strong><br/>Pulsando sobre el boton <strong><i>introducir manualmente</i></strong> se activara el campo de texto y podremos introducri la medida.</td>
    </tr>
    <tr>
        <td><img src="images/app/pulso_camara_0.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de introducción de pulso</strong><br/>Pulsando sobre el boton <strong><i>medir con el movil</i></strong> se lanzara la siguente pantalla y se encendera el flash del telefono.<br/>
        <small><i>(Es necesario que haya un visor de la camara, para que funcione, asi que lo he camuflado en el corazon. Además sirve para atinar donde poner el dedo)</i></small></td>
    </tr>
    <tr>
        <td><img src="images/app/pulso_camara_1.PNG" width=200/></td>
        <td valign="top"><strong>Pantalla de introducción de pulso</strong><br/>Cuando veamos que tenemos <i>"xxx bpm"</i> tras un tiempo, ya podremos darle a guardar.<br/>Voleremos a la primera pantalla, y veremos que el campo se ha rellenado automaticamente.</td>
    </tr>
    </tbody>
</table>