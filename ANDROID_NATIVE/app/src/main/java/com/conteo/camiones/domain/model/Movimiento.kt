package com.conteo.camiones.domain.model

import kotlinx.serialization.Serializable

@Serializable
data class Movimiento(
    val id: String,
    val obraId: String,
    val camionId: String?,
    val usuarioId: String?,
    val tipo: TipoMovimiento,
    val capacidad: Double,
    val material: String? = null,
    val ubicacion: String? = null,
    val timestamp: String,
    val fecha: String,
    val camionNombre: String? = null,
    val camionPatente: String? = null
)
