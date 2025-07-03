package com.sudbank.regulatory.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

/**
 * DTO para las solicitudes de reporte L08
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class L08ReportRequest {
    
    @NotNull(message = "La fecha de inicio es obligatoria")
    private LocalDate fechaInicio;
    
    @NotNull(message = "La fecha de fin es obligatoria")
    private LocalDate fechaFin;
    
    private String tipoCredito;
    private String clasificacionRiesgo;
    private String sectorEconomico;
    private String tipoMoneda;
    private Boolean incluirHistorial = false;
    // Campos adicionales requeridos por el servicio
    private String tipoReporte;
    private String formato;
    private String usuarioGenerador;
} 