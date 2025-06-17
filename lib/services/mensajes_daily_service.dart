class MensajesDailyService {
  static List<String> mensajes = [
    "Hoy es un buen día para aprender algo nuevo.",
    "El éxito es la suma de pequeños esfuerzos repetidos día tras día.",
    "La felicidad es la mejor medicina.",
    "El amor es la mejor medicina.",
    "Tu destino está en tus manos, literalmente.",
    "Las líneas de tu mano cuentan la historia de tu vida.",
    "Cada día es una nueva oportunidad para descubrir tu potencial.",
    "La sabiduría antigua puede iluminar tu camino presente.",
    "Tu futuro se construye con las decisiones de hoy.",
    "Las estrellas te guían, pero tú tienes el control.",
    "La intuición es tu mejor consejera.",
    "Confía en el proceso, todo sucede por una razón.",
    "Tu energía atrae tu realidad.",
    "Hoy es perfecto para una nueva lectura de manos.",
    "Los secretos de tu personalidad están al alcance de tus dedos.",
    "La palmistría revela lo que tu corazón ya sabe.",
    "La luz que buscas está dentro de ti.",
    "Una nueva etapa comienza cuando cierras el ciclo anterior.",
    "Tus manos hablan más de lo que imaginas.",
    "Sigue tu intuición, no te fallará.",
    "El universo conspira a tu favor cuando actúas con fe.",
    "Los caminos se abren cuando estás listo para caminar.",
    "Hoy tu energía será clave para atraer lo que deseas.",
    "Tus pensamientos crean tu mañana.",
    "El cambio comienza con una decisión valiente.",
    "Las señales están ahí, solo debes prestar atención.",
    "Escucha a tu alma, ella conoce el camino.",
    "Todo lo que das, vuelve multiplicado.",
    "Tu esencia es única, no temas mostrarla.",
    "La claridad llegará cuando estés en paz.",
    "La magia ocurre cuando alineas mente, cuerpo y espíritu.",
    "Un corazón agradecido es un imán para los milagros.",
    "La transformación comienza desde adentro.",
    "No estás solo, el universo te acompaña.",
    "El equilibrio es la clave de todo.",
    "Respira, suelta, confía.",
    "Tu propósito ya vive en ti.",
    "La energía que entregas es la que recibes.",
    "Mereces todo lo que sueñas.",
    "La paciencia es parte del poder.",
    "El tiempo perfecto es el del universo.",
    "Abraza tu presente para liberar tu futuro.",
    "El conocimiento antiguo vive en tu interior.",
    "Tu alma recuerda lo que tu mente ha olvidado.",
    "Nada es casualidad, todo es sincronicidad.",
    "La gratitud transforma tu vibración.",
    "El amor propio es el primer paso hacia cualquier amor.",
    "Permítete empezar de nuevo.",
    "Tu espíritu es más fuerte de lo que crees.",
    "Haz silencio para escuchar tu verdad.",
    "Las respuestas que buscas están dentro de ti.",
    "El universo siempre responde.",
    "Honra tus emociones, ellas son guías.",
    "Hoy es un portal para comenzar de nuevo.",
    "Despierta tu intuición, ella es tu brújula.",
    "Tus decisiones crean tu realidad.",
    "El arte de vivir está en soltar el control.",
    "La magia es real, empieza contigo.",
    "La verdad de tu alma se manifiesta en tus acciones.",
    "Escucha tu cuerpo, él guarda tus memorias.",
    "La energía de tus manos puede sanar.",
    "Estás donde debes estar.",
    "Cada signo tiene un mensaje para ti.",
    "La noche trae la sabiduría de lo oculto.",
    "Tus sueños son mensajes del más allá.",
    "Abraza tus sombras, allí está tu poder.",
    "Nada externo puede definirte.",
    "Recuerda quién eres antes de que te lo olvidaran.",
    "Eres parte del todo, y el todo está en ti.",
    "Las manos que curan también crean.",
    "Abre tu mente, pero también tu corazón.",
    "Los ciclos se cierran para dar paso a otros mejores.",
    "Los elementos te acompañan: tierra, aire, fuego y agua.",
    "Hoy es un día para conectar con tu poder interno.",
    "Una intención clara es más poderosa que mil acciones vacías.",
    "Las palabras que te dices crean tu mundo.",
    "Permite que el universo te sorprenda.",
    "Tu esencia es tu mayor tesoro.",
    "Alinea tus pensamientos con tu propósito.",
    "La calma es señal de sabiduría.",
    "Escoge el amor, no el miedo.",
    "Tus guías te hablan en susurros.",
    "El pasado es maestro, no prisión.",
    "Cada encuentro tiene una razón espiritual.",
    "Los desafíos son portales hacia la evolución.",
    "Todo lo que necesitas ya está en ti.",
    "Tú eres el milagro que esperabas.",
    "El silencio también es respuesta.",
    "Cuando te amas, todo cambia.",
    "Haz espacio para lo nuevo soltando lo viejo.",
    "Tu luz puede guiar a otros.",
    "Agradece, incluso antes de recibir.",
    "Los sueños que más te asustan son los más importantes.",
    "Eres canal de sabiduría universal.",
    "No corras, fluye.",
    "Tu camino es único, confía en cada paso.",
    "Hay belleza en el caos.",
    "Cuando te escuchas, todo se alinea.",
    "Confía en el misterio de la vida.",
    "La verdadera fuerza es la que nace del alma.",
    "Hoy es un buen día para volver a empezar.",
  ];

  /// Obtiene el mensaje del día basado en la fecha actual
  static String getMensajeDelDia() {
    final DateTime now = DateTime.now();
    // Crear un seed único para cada día del año
    final int dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final int seed = now.year + dayOfYear;

    // Usar el seed para obtener un índice consistente para todo el día
    final int index = seed % mensajes.length;

    return mensajes[index];
  }

  /// Obtiene un mensaje específico por índice
  static String getMensajePorIndice(int index) {
    if (index >= 0 && index < mensajes.length) {
      return mensajes[index];
    }
    return mensajes[0]; // Mensaje por defecto
  }

  /// Obtiene la cantidad total de mensajes
  static int get totalMensajes => mensajes.length;

  /// Obtiene todos los mensajes
  static List<String> get todosMensajes => List.unmodifiable(mensajes);
}
