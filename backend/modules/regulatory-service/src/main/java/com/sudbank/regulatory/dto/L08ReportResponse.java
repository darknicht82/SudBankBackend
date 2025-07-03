package com.sudbank.regulatory.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * DTO para las respuestas de reporte L08
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class L08ReportResponse {
    
    private String idReporte;
    private String reporteId;
    private String nombreReporte;
    private LocalDateTime fechaGeneracion;
    private LocalDateTime fechaInicio;
    private LocalDateTime fechaFin;
    private Integer totalRegistros;
    private BigDecimal montoTotalCreditos;
    private BigDecimal saldoTotalCapital;
    private BigDecimal saldoTotalIntereses;
    private List<L08ReportData> datos;
    private String estado;
    private String mensaje;
    private String usuarioGeneracion;
} 