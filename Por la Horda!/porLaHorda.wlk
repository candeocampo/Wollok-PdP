
class Personaje {
    
    const property fuerza 
    const property inteligencia // son constante  
    var property rol // definimos un atributo Rol
    // el property es un setter, me permite cambiarlo desde afuera

    method potencialOfensivo() = 10 * fuerza + rol.potencialOfensivoExtra()


}

class Humano inherits Personaje {


}

class Orco inherits Personaje { 

    override method potencialOfensivo() = super() * 1.1
    // con override pisamos el metodo de personaje
// En el caso particular de los orcos, producto de su brutalidad innata, su potencial ofensivo es
// un 10% más


}

// ROLES
object guerrero {
    method potencialOfestivoExtra() = 100

}

object brujo {
    method potencialOfestivoExtra() = 0
    
}

class Cazador {
    var mascota 
    method potencialOfestivoExtra() = mascota.potencialOfensivo()
  
}

class Mascota{
    const fuerza
    const edad
    const tieneGarras

    method potencialOfesivo() =
        if(tieneGarras) fuerza * 2
        else fuerza

}

// new Orco = new Cazador(mascota=...)
// const pirulo = new Orco ( rol = new Cazador(mascota=...))


//No hace falta que hagamos una clase de roles porque sus logicas son diferentes.
//Para que sean polimorfimos solamente basta con que entienden el msj de potencialOfensivoExtra

// const pirulo = new Orco(rol=brujo) instanciamos un orco con su rol
// pirulo.rol(guerrero) acá le cambiamos el rol





