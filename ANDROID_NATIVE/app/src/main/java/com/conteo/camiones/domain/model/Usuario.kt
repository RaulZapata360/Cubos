package com.conteo.camiones.domain.model

import kotlinx.serialization.Serializable

@Serializable
data class Usuario(
    val id: String,
    val nombreCompleto: String,
    val rol: Rol,
    val email: String,
    val telefono: String? = null,
    val createdAt: String? = null
)

enum class Rol {
    JEFE,
    CONTADOR
}
