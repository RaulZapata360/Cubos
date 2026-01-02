package com.conteo.camiones.domain.model

import kotlinx.serialization.Serializable

@Serializable
data class Obra(
    val id: String,
    val nombre: String,
    val ubicacion: String? = null,
    val descripcion: String? = null,
    val fechaInicio: String? = null,
    val estado: EstadoObra = EstadoObra.ACTIVA,
    val createdAt: String? = null,
    val updatedAt: String? = null
)

enum class EstadoObra {
    ACTIVA,
    PAUSADA,
    FINALIZADA
}
