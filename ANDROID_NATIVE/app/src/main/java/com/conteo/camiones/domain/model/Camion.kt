package com.conteo.camiones.domain.model

import kotlinx.serialization.Serializable

@Serializable
data class Camion(
    val id: String,
    val obraId: String,
    val nombre: String,
    val patente: String,
    val capacidad: Double,
    val tipoRegistrado: TipoMovimiento,
    val contadorEntrante: Int = 0,
    val contadorSaliente: Int = 0,
    val createdAt: String? = null,
    val updatedAt: String? = null
)

enum class TipoMovimiento {
    INCOMING,
    OUTGOING,
    MIXED
}
