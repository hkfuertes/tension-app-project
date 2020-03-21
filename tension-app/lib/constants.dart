import 'model/Settings.dart';

//const host = "https://tension-app-server.herokuapp.com";
const host = "https://tensionapp.herokuapp.com";
//const host = "http://192.168.1.48";
const baseUrl = host + "/api/v1";

const token_key = "Authorization";
const prefs_token_key = "token";
const prefs_refresh_key = "refresh";
const prefs_email_key = "email";
const not_logged_string = "NOT LOGGED IN";

//Tittles
const historics_title = "Histórico";
const dashboard_title = "Dashboard";
const patients_title = "Mis Pacientes";
const profile_title = "Perfil";
const stats_title = "Estadisticas";
const settings_title = "Ajustes";

//Texts
const log_out_text = "¿Quieres cerrar sesión?";
const log_out_title = "Cerrar Sesión";
const log_out_button = "Cerrar";
const save_button = "Guardar";
const save_title = "Confirmación";
const save_text = "¿Quieres guardar?";
const delete_patient_text = "¿Quieres borrar a <patient.name>?";
const delete_patient_title = "Confirmación";
const delete_patient_button = "Borrar";

const patient_graph_title = "Gráficas de paciente";
const patient_graph_text = "Son las graficas que se muestran al principio de la lista de medidas de un paciente.";

const patient_weight_obj_title = "Objetivo de peso";
const patient_weight_obj_text = "Muestra una linea en la grafica de peso.";

const patient_weight_obj_value_title = "Valor del objetivo";
const patient_weight_obj_value_text = "Selecciona el peso objetivo";
const patient_weight_obj_value_text_selected = "El objetivo actual es de "+Settings.WEIGHT_OBJ+" kg";

const device_enabled_title = "Conexión con dispositivo Arduino";
const device_enabled_text = "Utilizar el dispositivo arduino via USB para medir la frecuencia cardiaca";

const yes = "Sí";
const no = "No";

//Months
const meses = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octurbre','Noviembre','Diciembre'];
const meses_ab = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];