//Parcial Black Sails

/*
existen distintas embarcaciones, cada una con su respectiva tripulación y una serie de cañones. 
También se conoce la ubicación, 
que es una posición en el océano y está dada por el nombre del mismo y una coordenada X y otra Y. 
Por último, cada embarcación tiene un botín medido en cantidad de monedas de oro.
*/
class Embarcacion {
  const tripulacion
  const caniones
  const property ubicacion
  var botin

  method aumentarCorajeBase(cantCoraje) {
    tripulacion.aumentarCorajeBase(cantCoraje)
  }
  

  method cambiarCapitan(nuevoCapitan) {
    tripulacion.cambiarCapitan(nuevoCapitan)
  }

  method modificarBotin(cantidad){
    botin += cantidad
  }
  

  //Punto 1
  /* Calcular el poder de daño de una embarcación, 
  que está dada por la suma total de los corajes del total de la tripulación, 
  más el poder de daño de todos los cañones.
  */

  method poderDanio() = tripulacion.coraje() + self.totalDanio()

  method totalDanio() = caniones.sum{arma => arma.danio()}

  //Punto 2
  // Obtener al tripulante más corajudo de la embarcación (que no es capitán, ni contramaestre).

  method tripulanteMasCorajudo() = tripulacion.pirataMasCorajudo()

  //Punto 3
  /*
  Saber si dos embarcaciones pueden entrar en conflicto. 
  Esto ocurre cuando la diferencia de las coordenadas es menor a un valor configurable en el sistema, 
  siempre y cuando correspondan al mismo océano. Nota: Utilizar el cálculo de distancia entre dos puntos.
  */

  method puedenEntrarEnConflicto(otraEmbarcacion, distanciaPosible) = 
            self.ubicacion().estaEnMismoOceano(otraEmbarcacion.ubicacion()) &&
            self.ubicacion().distancia(otraEmbarcacion.ubicacion() <= distanciaPosible)
}

class Ubicacion {
  const property posicionOceano
  const property coordenadaX 
  const property coordenadaY

  method estaEnMismoOceano(otraUbicacion) = posicionOceano == otraUbicacion.posicionOceano()

  method distancia(otraUbicacion) = ((coordenadaX - otraUbicacion.coordenadaX()) + 
                                    (coordenadaY - otraUbicacion.coordenadaY()))

}

//En la embarcación están el capitán, el contramaestre y la tripulación general (piratas); 
class Tripulacion{
  var capitan
  var contramaestre
  const piratas

  method cambiarCapitan(nuevoCapitan) {
    capitan = nuevoCapitan
  }

  method pirataMasCorajudo() = piratas.max{pirata => pirata.coraje()}

  method aumentarCorajeBase(cantCoraje) {
    piratas.forEach{pirata => pirata.aumentarCorajeBase(cantCoraje)}
  }
}

/*
cada uno de ellos tiene un nivel de coraje base (indicado por un número, que se estima no mayor a 100) 
que está afectado por las armas que posea, determinando un coraje “total”, o simplemente coraje. 
También se conoce su nivel de inteligencia. 
Claro que ciertos eventos pueden hacer que existan cambios dentro de la tripulación, 
por ejemplo que un contramaestre se convierta en capitán.
*/
class Tripulante {
  var corajeBase
  const armas
  const property inteligencia

  method coraje() = corajeBase + self.totalDanio()

  method totalDanio() = armas.sum{arma => arma.danio()}

  method aumentarCorajeBase(cantCoraje) {
    corajeBase += cantCoraje
  }

}

/*
Todos los cañones se fabrican con el mismo nivel de daño, que John estima que en este momento es de 350, 
pero que puede cambiar a lo largo del tiempo por la continua evolución en las técnicas de fabricación 
(claro que dicho cambio no afecta a los ya existentes, solo a los nuevos). 
Para calcular el daño que efectivamente realiza, 
dicho nivel se disminuye en un 1% del valor de fabricación por cada año de antigüedad que tiene el cañón, 
ya que se ve progresivamente desgastado.
*/
class Canion {
  const danioBase
  var antiguedad

  //method danio() = danioBase - (danioBase * 0.01 * antiguedad)
  method danio() = danioBase - 0.01 * antiguedad

  method aumentarAntiguedad(cantAnios) {
    antiguedad += cantAnios
  }
}

//Cuchillo: Todos los cuchillos tienen la misma cantidad de daño, que puede variar a nivel general, es decir para todos.
object cuchillo {
  var property danio = 1

  method danio(tripulante) = danio
}

//Espada: Cada espada tiene su complejidad, por lo tanto el daño es específico para cada una.
class Espada {
  const complejidad
  const danio

  method danio(tripulante) = complejidad.danio()
}

//Pistola: En este caso el daño está dado por el calibre * un índice de material, del cual solo sabemos el nombre. 
class Pistola {
  const danio
  const calibre
  const material

  method danio(tripulante) = calibre * material.indice()
}

//Insulto: El daño está dado por la cantidad de palabras del insulto multiplicado por el coraje base del pirata que lo enuncia.
class Insulto {
  const danio
  const insulto

  method danio(tripulante) = self.cantPalabras() * tripulante.corajeBase()

  method cantPalabras() = insulto.split(" ").size()
}

/*Las embarcaciones pueden entrar en contienda. En el caso de que esto ocurra, 
una embarcación puede ser vencida por otra en distintas contiendas:
*/

class Contienda {
  //Punto 4
  /*
  Dadas dos embarcaciones y una forma de contienda, saber si la primera puede tomar a la segunda o no.
  Por otra parte, realizar la toma (el resultado de la contienda) propiamente dicha de la embarcación vencida. 
  Tener en cuenta que dependiendo de la toma de la embarcación pasan cosas distintas.

  */
  method puedeVencer(embarcacionGanadora, embarcacionPerdedora) {}
  method resultado(embarcacionGanadora, embarcacionPerdedora) {}
  method tomar(embarcacionGanadora, embarcacionPerdedora) {}
}

/*
Clásica batalla: Una embarcación puede vencer a otra si 
el poder de daño de la primera es superior al de la segunda. 
Como resultado de la batalla, las embarcaciones se mezclan:
- El coraje base del total de la tripulación de la primera embarcación aumenta en 5 unidades.
- Los 3 integrantes más cobardes de la tripulación de la embarcación vencida mueren.
- El contramestre de la segunda embarcación mantiene su puesto,
  pero el capitán es reemplazado por el contramaestre de la primera.
- El más corajudo de la primera embarcación se convierte en contramestre.
- 3 integrantes de la tripulación vencedora pasan a la embarcación vencida 
(los de mayor coraje, para poder controlar a los otrora enemigos).
*/

class Batalla inherits Contienda {
  override method puedeVencer(embarcacionGanadora, embarcacionPerdedora) = embarcacionGanadora.poderDanio() > embarcacionPerdedora.poderDanio()

  override method tomar(embarcacionGanadora, embarcacionPerdedora){
    embarcacionGanadora.aumentarCorajeBase(5)
    embarcacionPerdedora.removerCobardes(3)
    embarcacionPerdedora.cambiarCapitan(embarcacionGanadora.contramestre())
    embarcacionGanadora.cambiarContramestre()
  }
}

/*
Negociación: Para que esto pase, la primera embarcación debe tener un hábil negociador, 
que es un pirata de inteligencia mayor a 50. 
Como resultado, la mitad del botín de la segunda pasa a la primera. 
*/

class Negociacion inherits Contienda {
  override method puedeVencer(embarcacionGanadora, embarcacionPerdedora) = embarcacionGanadora.tieneHabilNegociador()

  override method resultado(embarcacionGanadora, embarcacionPerdedora){
    const mitadBotin = embarcacionPerdedora.botin() / 2
    embarcacionGanadora.modificarBotin(mitadBotin)
    embarcacionPerdedora.modificarBotin(-mitadBotin)

  }
}