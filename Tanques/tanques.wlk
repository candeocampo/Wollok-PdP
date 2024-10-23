class Tanque{
    const armas = [] //colección de armas
    const tripulantes = 2 
    var salud = 1000
    var property prendidoFuego = false

    method emiteCalor() = prendidoFuego || tripulantes > 3

    method sufrirDanio(danio){
        salud -= danio
    }

    method atacar(objetivo){
        armas.anyOne().dispararA(objetivo)
    }
    //anyOne elije un arma aleatoriamente

}

// Lanzallamas: al tanque al que se dispara se prende fuego.
class Lanzallamas inherits Recargable{
    method causarEfecto(objetivo){
        objetivo.prendidoFuego(true)
    }
}

// tanto el lanzallamas como la metralla tmb tienen un cargador como el misil;
// por lo que le tendriamos que agg a c/u tmb lo de cargador y agotada. 

// SOLO SE PUEDE HEREDAR DE CLASES, NO DE OBJETOS!

class Metralla inherits Recargable{
    const property calibre

    method dispararA(objetivo){
        cargador -= 10
        if(calibre > 50){
            objetivo.sufrirDanio(calibre/4)
        }
    } 
}


class Recargable{
    var cargador = 100

    method agotada() = cargador <=0
}

class Misil{
    const potencia
    var agotada = false

    method agotada() = agotada

    method dispararA(objetivo){
        agotada = true // cuando disparo ya lo seteo 
        objetivo.sufrirDanio(potencia)
    }

}

class MisilTermico inherist Misil{ // este nuevo misil ya entiende el msj de dispararA por Misil
    //queremos que haga un disparo diferente
    override method dispararA(objetivo){ 
        if(objetivo.emiteCalor()){
            super(objetivo) // super: no es un envío de msj; es una INDICACIÓN al ejecutor de código: necesito encontrar el lookUp, necesito el método que me hubiera faltado ejecutar (busca desde super para arriba)
        }
    }
}


// override: que cuando piso un método lo hago aproposito

// el SUPER solamente se usa en el OVERRIDE

//el metodo Lookup; que primero busca en la clase que estamos haciendo y después busca en el siguiente
// y en el siguiente hasta encontrar al método; si lo encuentra en el 1° después toma lo que necesita de la superclase.

class TanqueBlindado inherist Tanque{
    const blindaje = 200

    override method emiteCalor() = false

    override method sufrirDanio(danio){
        if(danio > blindaje){
            super(danio - blindaje)
        }
    }

}


class Matafuego inherits Rociador{
    method causarEfecto(objetivo){
        objetivo.prendidoFuego(false)
    }
}


class Rociador inherist Recargable{
    method dispararA(objetivo){
        cargador -=self.descargaPorRafaga()
        self.causarEfecto(objetivo)
    }

    method causarEfecto(objetivo) // metodo abstracto: no le digo que hacer; metodo que tengo que tener poprque mis subclases necesitan implementarlo.
    method descargaPorRafaga() = 20
}

// clase abstracta: clase que no instancio

class Sellador inherist Rociador{
    method causarEfecto(objetivo){
        objetivo.salud(objetivo.salud() * 1.1)
    }
    override method descargaPorRafaga() = 25
}
















