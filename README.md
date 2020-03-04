## Documentación del proyecto _Tension App_

Aqui estan los documentos tanto del anteproyecto, del servidor y de la app Android.
- El **anteproyecto**, lo puedes encontrar [aquí](https://github.com/hkfuertes/tension-app-guides/blob/master/proyecto.md).
- La **applicacion Flutter**, la puedes encontrar [aquí](https://github.com/hkfuertes/tension-app-guides/tree/master/app.md).
- El **servidor** se encuentra [aquí](https://github.com/hkfuertes/tension-app-guides/tree/master/server.md).

## Propuesta de Trabajo

>Ainara Garde, al frente de un equipo de diferentes disciplinas y cuatro países, desarrolló un instrumento que permite a los trabajadores de salud de primera línea detectar rápidamente la necesidad de los niños de ser hospitalizados.Y agregan que una característica común de la mayoría de las enfermedades infantiles tratables es la falta de oxígeno.
>
>Para medir este factor de riesgo, el proyecto utilizó un sensor de dedo, el oxímetro de teléfono. De hecho, recopila datos en una aplicación de teléfono inteligente para controlar la saturación de oxígeno en la sangre y la frecuencia cardíaca de una persona. Esta información se combina con una medición de la frecuencia respiratoria.
>
>Garde desarrolló un modelo predictivo que identifica datos anormales de forma fácil y automática.
>
>[Ainara Garde](https://www.diariodenavarra.es/noticias/navarra/2017/11/27/la-investigadora-navarra-ainaragarde-premio-internacional-medicina-infantil-564133-300.html)

Mi idea es que tú diseñaras un planteamiento TEÓRICO de una idea parecida a esto.
Es decir:
- Identificar componentes hardware y software que intervienen
    - Cámara del smartphone, pulsioxímetro (sensor de dedo)
    - Flash (o luz potente)
    - Software de procesamiento de imágenes y video.
- Identificar los sensores o dispositivos que intervienen
    - Cámara, bien del pulsioxímetro, bien del smartphone (tanto la freq.
cardiaca como la saturación en sangre se calculan en base a la variación
de color de un dedo iluminado)
- Identificar protocolos de comunicación entre los diferentes dispositivos
    - Esto es muy subjetivo y habría que estudiar el set-up que utilizo en sus
pruebas, pero de primeras, si todo se centraliza en el smartphone, no hay
mucho protocolo, es todo manejo de datos interno a la aplicación. Para la
incorporación del pulsioxímetro externo, sí que tendríamos que ver
protocolos de transmisión de datos seguros HL7.
- Plantear los procesos entre los diferentes elementos
    - En este apartado podríamos estudiar el ciclo completo de estudio de un
niño, es decir, desde la anamnesis, pasando por las diferentes pruebas,
hasta la posible predicción.

>**A Novel Method to Detect Heart Beat Rate Using a Mobile Phone** – *Pelegris P, Banitsas K, Orbach T, Marias K.*

Sobre todo, sería interesante centrarse en los apartados c) y d) ya que los apartados a) y b) están más trillados y son más triviales. Sería interesante profundizar en
+ Manejo de datos en la aplicación. Qué tipo de aplicación usar? muy compleja? simple? lenguajes de programación, etc
+ Los detalles del protocolo. Justificación de por qué se usa ese protocolo, etc
+ Para la incorporación del pulsioxímetro externo, sí que tendríamos que ver protocolos de transmisión de datos seguros HL7
