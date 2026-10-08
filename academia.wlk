/** Reemplazar por la solución del enunciado */


// muebles [ArmarioConvencional, GabineteMagico, Baul, ArmarioConvencional, Baul, Baul]
class Academia {
	const property muebles = []

	method agregar(cosa){
		self.verificarExcepciones(cosa)
		self.agregarCosa(cosa)
	}

	method verificarExcepciones(cosa){
		self.verificarMuebles()
		self.verificarSiEstaGuardada(cosa)
		self.verificarEspacio(cosa)
	}

	method verificarMuebles(){
		if (muebles.isEmpty()){
			self.error("Muebles se encuentra vacío")
		}
	}

	method verificarSiEstaGuardada(cosa){
		if(self.estaGuardada(cosa)){
			self.error("La cosa ya esta guardada")
		}
	}

	method estaGuardada(cosa){
		return muebles.any({ mueble => mueble.cosas().contains(cosa) })
	}

	method verificarEspacio(cosa){
		if(not self.hayMueble(cosa)){
			self.error("No hay espacio")
		}
	}

	method hayMueble(cosa){
		return muebles.any({ mueble => mueble.sePuedeAgregar(cosa) })
	}

	method agregarCosa(cosa){
		const mueble = self.mueble(cosa)
		mueble.agregar(cosa)
	}
	method mueble(cosa){
		return muebles.find({ mueble => mueble.sePuedeAgregar(cosa) })
	}

	method removerCosasMenosUtiles(){
    	if (muebles.size() < 3) {
    	    self.error("La academia debe tener al menos 3 muebles")
    	}

    	muebles.forEach({ mueble => self.remover(mueble)})
	}
	
	method remover(mueble){
		const cosa = mueble.cosaMenosUtil()

    	if (not cosa.esElementoMagico()) {
    	    mueble.remover(cosa) 
		}
	}
}

class Mueble {
	const property cosas = #{}

	method agregar(cosa)

	method sumatoria(){
		return cosas.sum({ cosa => cosa.utilidad() })
	}
	method cosaMenosUtil(){
		return cosas.min({ cosa => cosa.utilidad()})
	}

	method remover(cosa){
		cosas.remove(cosa)
	}
}

class ArmarioConvencional inherits Mueble{
	var property capacidadMaxima //para testear


	method sePuedeAgregar(cosa){
		return self.cosas().size() < self.capacidadMaxima()
	}

	override method agregar(cosa){
		cosas.add(cosa)
	}

	method utilidad(){
		return self.sumatoria() / self.precio()
	}


	method precio(){
		return 5 * self.capacidadMaxima()
	}

	
}

class GabineteMagico inherits Mueble{
	const precio

	method sePuedeAgregar(cosa){
		return cosa.esElementoMagico()
	}

	override method agregar(cosa){
		cosas.add(cosa)
	}

	method utilidad(){
		return self.sumatoria() / self.precio()
	}

	method precio(){
		return precio
	}
}

class Baul inherits Mueble {
	const capacidadMaxima
	var volumenUsado = 0 //la suma de los volumenes de las cosas que tiene adentro

	method volumenUsado(){
		return volumenUsado
	}

	method volumenUsado(cosa){
		volumenUsado += cosa.volumen()
	}

	method capacidadMaxima(){
		return capacidadMaxima
	}

	method sePuedeAgregar(cosa){
		return self.volumenTotal(cosa) <= self.capacidadMaxima()
	}

	method volumenTotal(cosa){
		return cosa.volumen() + self.volumenUsado()
	}

	override method agregar(cosa){
		cosas.add(cosa)
		self.volumenUsado(cosa)
	}
	
	method utilidad(){
		return self.division() + self.reliquias()
	}

	method division(){
		return self.sumatoria() / self.precio()
	}

	method precio(){
		return self.capacidadMaxima() + 2
	}
	method reliquias(){
		return if(self.sonTodasReliquias()) { 2 } else { 0 }
	}

	method sonTodasReliquias(){
		return cosas.all({ cosa => cosa.esReliquia() })
	}
}

class BaulMagico inherits Baul {

	override method utilidad(){
		return self.division() + self.reliquias() + self.cantidadElementosMagicos()
	}

	override method precio(){
		return super() * 2
	}

	method cantidadElementosMagicos(){
		return cosas.count({ cosa => cosa.esElementoMagico() })
	}
}

class Cosa {
	var marca
	var volumen
	var esElementoMagico
	var esReliquia


	method esReliquia(){
		return esReliquia
	}

	method esElementoMagico(){
		return esElementoMagico
	}

	method volumen(){
		return volumen
	}

	method marca(){
		return marca
	}
	method utilidad(){
		return volumen + self.utilidadTotal(self)
	}
	
	method utilidadTotal(cosa){
		return self.magia() + self.reliquia() + marca.utilidad(cosa)
	}

	method magia(){
		return if(esElementoMagico) { 3 } else { 0 }
	}

	method reliquia(){
		return if(esReliquia) { 5 } else { 0 }
	}
}

object acme {

	method utilidad(cosa){
		return cosa.volumen() / 2
	}
}

object fenix {

	method utilidad(cosa){
		return if(cosa.esReliquia()) { 3 } else { 0 }
	}
}

object cuchuflito {

	method utilidad(cosa){
		return 0
	}
}